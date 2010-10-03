-------------------------------------------------------------------------------
-- Title      : com
-- Project    : dmkons, vhdl-øving på Nalle
-------------------------------------------------------------------------------
-- File       : com.vhd
-- Author     : Asbjørn Djupdal  <asbjoern@djupdal.org>
-- Company    : 
-- Last update: 2008-06-17
-- Platform   : BenERA, Virtex 1000E
-------------------------------------------------------------------------------
-- Description: Communication with PCI FPGA
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2003/08/06  1.0      djupdal	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;

library unisim; 
use unisim.all;

entity cpucom is
  
  port (
    -- signals for communicating with PCI-FPGA
    -- see BenERA users guide
    pciBusy   : in    std_logic;
    pciEmpty  : in    std_logic;
    pciRW     : out   std_logic;
    pciEnable : out   std_logic;
    pciData   : inout std_logic_vector(31 downto 0);

    -- imem write port
    imem_w_address : out std_logic_vector(IADDR_BUS - 1 downto 0);
    imem_w_data    : out std_logic_vector(IDATA_BUS - 1 downto 0);
    imem_w_enable  : out std_logic;

    -- register values in regfile
    reg_values : in regfile_type;

    -- clock used for cpu core
    core_clk : out std_logic;
    -- reset used for cpu core
    core_rst : out std_logic;

    rst : in std_logic;
    clk : in std_logic);

end cpucom;

architecture cpucom_arch of cpucom is

  type com_state_type is (idle, receive_cmd, interpret_command,
                          send_registers, send_register,
                          receive_program, receive_getword, receive_storeword,
                          step, run, stop);

  signal com_state : com_state_type;

  signal command : std_logic_vector(31 downto 0);

  signal reg_value : std_logic_vector (DDATA_BUS - 1 downto 0);

  signal count_reg     : unsigned(IADDR_BUS downto 0);
  signal count         : std_logic;
  signal reset_counter : std_logic;

  signal run_core       : std_logic;
  signal com_clk        : std_logic;
  signal core_clk_i     : std_logic;
  signal core_clk_value : std_logic;
  signal clk_i1, clk_i2 : std_logic;

  signal rst_n : std_logic;
  signal rst_i : std_logic;

  component bufg
    port (i : in  std_logic;
          o : out std_logic);
  end component;

  component ibufg
    port (i : in  std_logic;
          o : out std_logic);
  end component;

  component clkdllhf
    port (clkin  : in  std_logic;
          clkfb  : in  std_logic;
          rst    : in  std_logic;
          clk0   : out std_logic;
          clk180 : out std_logic;
          clkdv  : out std_logic;
          locked : out std_logic);
  end component;

begin  -- comArch

  -----------------------------------------------------------------------------
  -- clock DLL and buffers
  -----------------------------------------------------------------------------

  buf1 : ibufg
    port map (
      i => clk,
      o => clk_i1);

  dll : clkdllhf
    port map (
      clkin  => clk_i1,
      clkfb  => com_clk,
      rst    => rst_n,
      clk0   => clk_i2,
      clk180 => open,
      clkdv  => open,
      locked => rst_i);

  buf2 : bufg
    port map (
      i => clk_i2,
      o => com_clk);

  buf3 : bufg
    port map (
      i => core_clk_i,
      o => core_clk);
  
  -----------------------------------------------------------------------------
  -- generate core clock (clock used for cpu core)
  -- core clock is gated to enable single stepping of cpu core
  -----------------------------------------------------------------------------

  process (com_clk, rst_i)
  begin
    if rst_i = '0' then
      core_clk_i <= '0';
    elsif rising_edge (com_clk) then
      if run_core = '1' then
        core_clk_i <= not core_clk_i;
      else
        core_clk_i <= core_clk_value;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- reset signals
  -----------------------------------------------------------------------------

  rst_n <= not rst;
  core_rst <= rst_i;

  debug_dll_locked <= rst_i;            -- for probing in test bench

  -----------------------------------------------------------------------------
  -- counter
  -----------------------------------------------------------------------------

  process (com_clk)
  begin

    if rising_edge (com_clk) then
      if reset_counter = '1' then
        count_reg <= to_unsigned (0, IADDR_BUS+1);
      elsif count = '1' then
        count_reg <= count_reg + 1;
      end if;
    end if;

  end process;

  -----------------------------------------------------------------------------
  -- a third read port in register file
  -----------------------------------------------------------------------------

  -- registered output to meet timing constraints
  process (rst_i, com_clk)
  begin

    if rst_i = '0' then
      reg_value <= (others => '0');

    elsif rising_edge (com_clk) then
      case count_reg(3 downto 0) is
        when "0000" =>
          reg_value <= reg_values(0);
        when "0001" =>
          reg_value <= reg_values(1);
        when "0010" =>
          reg_value <= reg_values(2);
        when "0011" =>
          reg_value <= reg_values(3);
        when "0100" =>
          reg_value <= reg_values(4);
        when "0101" =>
          reg_value <= reg_values(5);
        when "0110" =>
          reg_value <= reg_values(6);
        when "0111" =>
          reg_value <= reg_values(7);
        when "1000" =>
          reg_value <= reg_values(8);
        when "1001" =>
          reg_value <= reg_values(9);
        when "1010" =>
          reg_value <= reg_values(10);
        when "1011" =>
          reg_value <= reg_values(11);
        when "1100" =>
          reg_value <= reg_values(12);
        when "1101" =>
          reg_value <= reg_values(13);
        when "1110" =>
          reg_value <= reg_values(14);
        when "1111" =>
          reg_value <= reg_values(15);
        when others =>
          reg_value <= (others => '0');
      end case;

    end if;
  end process;

  -----------------------------------------------------------------------------
  -- state machine, clocked part
  -----------------------------------------------------------------------------

  process (com_clk, rst_i) 
  begin
    
    if rst_i = '0' then
      com_state <= idle;
      imem_w_enable <= '0';
      imem_w_address <= (others => '0');
      imem_w_data <= (others => '0');
      run_core <= '0';
      core_clk_value <= '0';

    elsif rising_edge (com_clk) then

      imem_w_enable <= '0';
      core_clk_value <= '0';

      case com_state is

        -- wait for request
        when idle =>
          if pciEmpty = '0' then
            com_state <= receive_cmd;
          else
            com_state <= idle;
          end if;

        -- receive command from PCI FPGA
        when receive_cmd =>
          com_state <= interpret_command;
          command <= pciData;

        when interpret_command =>
          case command(2 downto 0) is
            when "000" =>
              com_state <= send_registers;
            when "001" =>
              com_state <= receive_program;
            when "010" =>
              com_state <= step;
            when "011" =>
              com_state <= run;
            when "100" => 
              com_state <= stop;
            when others =>
              com_state <= idle;
          end case;

        -- Send register file to PCI PFGA
        when send_registers =>
          if pciBusy = '0' then
            com_state <= send_register;
          else
            com_state <= send_registers;
          end if;

        when send_register =>
          com_state <= send_registers;
          if count_reg = REGISTERS - 1 then
            com_state <= idle;
          end if;

        -- receive imem contents from PCI FPGA
        when receive_program =>
          com_state <= receive_program;

          if pciEmpty = '0' then
            com_state <= receive_getword;
          end if;

        when receive_getword =>
          com_state <= receive_storeword;

          imem_w_address <= std_logic_vector(count_reg(IADDR_BUS-1 downto 0));
          imem_w_data <= pciData;
          imem_w_enable <= '1';

          core_clk_value <= '1';

        when receive_storeword =>
          com_state <= receive_program;
          imem_w_enable <= '1';

          if count_reg = IMEM_SIZE then
            com_state <= idle;
          end if;

        -- single stepping
        when step =>
          com_state <= idle;
          core_clk_value <= '1';

        -- running
        when run =>
          com_state <= idle;
          run_core <= '1';

        when stop => 
          com_state <= idle;
          run_core <= '0';

        when others =>
          com_state <= idle;

      end case;
    end if;

  end process;

  -----------------------------------------------------------------------------
  -- state machine, comb. part
  -----------------------------------------------------------------------------

  process (com_state, pciBusy, reg_values, pciEmpty, reg_value)
  begin
    
    pciData <= (others => 'Z');
    pciEnable <= '1';
    pciRW <= '0';

    count <= '0';
    reset_counter <= '0';

    case com_state is

      when idle =>
        reset_counter <= '1';

      when receive_cmd =>
        pciEnable <= '0';
        pciRW <= '0'; -- READ

      when send_register =>
        pciData(31 downto 0) <= (others => '0');
        pciData(DDATA_BUS - 1 downto 0) <= reg_value;
        pciEnable <= '0';
        pciRW <= '1'; -- WRITE
        count <= '1';

      when receive_getword =>
        pciEnable <= '0';
        pciRW <= '0'; -- READ
        count <= '1';

      when others =>
        null;

    end case;

  end process;

end cpucom_arch;
