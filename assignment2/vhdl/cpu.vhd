-------------------------------------------------------------------------------
-- Title      : cpu
-- Project    : dmkons multicycle
-------------------------------------------------------------------------------
-- File       : cpu.vhd
-- Author     : DM
-- Company    : 
-- Last update: 2008-06-18
-- Platform   : BenERA, Virtex 1000E
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;

entity cpu is
  
  port (
      -- imem write port
      imem_w_address : in std_logic_vector(IADDR_BUS - 1 downto 0);
      imem_w_data    : in std_logic_vector(IDATA_BUS - 1 downto 0);
      imem_w_enable  : in std_logic;

      -- register values in regfile
      reg_values : out regfile_type;

      -- clock used for cpu core
      core_clk : in std_logic;
      -- reset used for cpu core
      core_rst : in std_logic;
		-- BenERA LEDS
		led : out std_logic_vector(15 downto 0));
	 
end cpu;

architecture cpu_arch of cpu is

   component regfile is
      port (
         -- read port A
         reg_a : in std_logic_vector(REG_ADDR_BUS - 1 downto 0);
         data_a : out std_logic_vector(DDATA_BUS - 1 downto 0);
         -- read port B
         reg_b : in std_logic_vector(REG_ADDR_BUS - 1 downto 0);
         data_b : out std_logic_vector(DDATA_BUS - 1 downto 0);
         -- write port
         reg_d : in std_logic_vector(REG_ADDR_BUS - 1 downto 0);
         d_enable : in std_logic;
         data_d   : in std_logic_vector(DDATA_BUS - 1 downto 0);
         -- array with all current register values
         reg_values : out regfile_type;
         --
         rst      : in std_logic;
         core_clk : in std_logic);
   end component;

   component mem is
      port (
         -- read port
         address   : in  std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
         data      : out std_logic_vector(MEM_DATA_BUS - 1 downto 0);
         -- write port
         w_address : in std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
         w_data    : in std_logic_vector(MEM_DATA_BUS - 1 downto 0);
         w_enable  : in std_logic;
         core_clk  : in std_logic);
   end component;

   component alu is
      port (
         alu_funct : in std_logic_vector(FUNCT_BUS - 1 downto 0);
         alu_in_a  : in std_logic_vector(DDATA_BUS - 1 downto 0);
         alu_in_b  : in std_logic_vector(DDATA_BUS - 1 downto 0);

         alu_out    : out std_logic_vector(DDATA_BUS - 1 downto 0);
         alu_status : out std_logic_vector(STATUS_BUS - 1 downto 0));
   end component;    
	
	component ctrl is  
      port (
         -- control unit input
         opcode : in std_logic_vector(OPCODE_BUS - 1 downto 0);
         sr     : in std_logic_vector(STATUS_BUS - 1 downto 0);

         -- register values in regfile
         pc_mux_select : out std_logic;
         pc_write_enable : out std_logic;

         regfile_mux_select : out std_logic;
   		regfile_write_enable : out std_logic;
	   	sr_write_enable : out std_logic;

         -- clock used for cpu core
         core_clk : in std_logic;
         -- reset used for cpu core
         core_rst : in std_logic);
   end component;
	
	component pc is
      port (
			-- pc input
			pc_in           	: in std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
			pc_write_enable 	: in std_logic;
			pc_mux_sel 			: in std_logic;
			-- pc output
			pc_out          	: out std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
			--
			core_rst      		: in std_logic;
			core_clk        	: in std_logic);
	end component;
	
	component sr is
      port (
			-- sr input
			sr_in           : in std_logic_vector(STATUS_BUS - 1 downto 0);
			sr_write_enable : in std_logic;
			-- sr output
			sr_out          : out std_logic_vector(STATUS_BUS - 1 downto 0);
			--
			core_rst        : in std_logic;
			core_clk        : in std_logic);
   end component;

	component regfile_mux is
		Port ( mux_select : in  STD_LOGIC;
				immediate : in  STD_LOGIC_VECTOR(IADDR_BUS - 1 downto 0);
				alu_out : in  STD_LOGIC_VECTOR(IADDR_BUS - 1 downto 0);
				data_d : out  STD_LOGIC_VECTOR(IADDR_BUS - 1 downto 0));
	end component;
	
	-- additional signals connecting to mem component
   signal data_conn     : std_logic_vector(MEM_DATA_BUS - 1 downto 0);

	-- additional signals connecting to regfile component
   -- read port A
   signal reg_a_conn  : std_logic_vector(REG_ADDR_BUS - 1 downto 0);
   signal data_a_conn : std_logic_vector(DDATA_BUS - 1 downto 0);
   -- read port B
   signal reg_b_conn  :  std_logic_vector(REG_ADDR_BUS - 1 downto 0);
   signal data_b_conn : std_logic_vector(DDATA_BUS - 1 downto 0);
   -- write port
   signal reg_d_conn    : std_logic_vector(REG_ADDR_BUS - 1 downto 0);
   signal d_enable_conn : std_logic;
   signal data_d_conn   : std_logic_vector(DDATA_BUS - 1 downto 0);

	-- additional signals connecting to alu
   signal alu_funct_conn : std_logic_vector(FUNCT_BUS - 1 downto 0);
   signal alu_out_conn    : std_logic_vector(DDATA_BUS - 1 downto 0);
   signal alu_status_conn : std_logic_vector(STATUS_BUS - 1 downto 0);
	
	-- immediate signal
   signal imm_conn   : std_logic_vector(IADDR_BUS - 1 downto 0);

   -- signals connecting to the control unit
   signal opcode_conn : std_logic_vector(OPCODE_BUS - 1 downto 0);
   signal sr_conn     : std_logic_vector(STATUS_BUS - 1 downto 0);
   -- register values in regfile
   signal pc_mux_select_conn : std_logic;
   signal pc_write_enable_conn : std_logic;
   signal regfile_mux_select_conn : std_logic;
	signal sr_write_enable_conn : std_logic;
	
	-- program counter register signals
	signal pc_out : std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
begin

   -- set leds off
	led <= "0000000000000000";

	-- port map memory block
   mem1 : mem port map (
      -- read port
      pc_out,
      data_conn,
      -- write port
      imem_w_address,
      imem_w_data,
      imem_w_enable,
      core_clk);

	-- port map regfile
   regfile1 : regfile port map (
      -- read port A
      reg_a_conn,
      data_a_conn,
      -- read port B
      reg_b_conn,
      data_b_conn,
      -- write port
      reg_d_conn,
      d_enable_conn,
      data_d_conn,
      -- array with all current register values
      reg_values,
      --
      core_rst,
      core_clk);

   -- no need to create a separate instruction register,
	-- just map the appropriate output of memory block to appropriate input of regfile.
	-- done according to instruction word example from assignment text
	reg_a_conn(REG_ADDR_BUS-1 downto 0) <= data_conn(3 downto 0);
	reg_b_conn(REG_ADDR_BUS-1 downto 0) <= data_conn(7 downto 4);
	reg_d_conn(REG_ADDR_BUS-1 downto 0) <= data_conn(11 downto 8);

	-- port map alu to appropriate output of regfile and memory block 
   alu1 : alu port map (
         alu_funct_conn,
         data_a_conn,
         data_b_conn,
         alu_out_conn,
         alu_status_conn);

	-- connect alu_funct to appropriate output of memory block
	alu_funct_conn <= data_conn(21 downto 20);

	-- connect immediate signal to appropriate output of memory block
	imm_conn <= data_conn(19 downto 12);

   -- connect opcode to appropriate output of memory block
	opcode_conn <= data_conn(31 downto 29);

   -- connect control unit
	ctrl1 : ctrl port map (
         -- control unit input
         opcode_conn,
         sr_conn,
			-- control unit output
         pc_mux_select_conn,
         pc_write_enable_conn,
         regfile_mux_select_conn,
   		d_enable_conn,
	   	sr_write_enable_conn,
         -- clock used for cpu core
         core_clk,
         -- reset used for cpu core
         core_rst);

   -- connect pc register
   pc1 : pc port map (
         imm_conn,
         pc_write_enable_conn,
			pc_mux_select_conn,
	      pc_out,
			core_rst,
			core_clk);
			
	-- connect status register
   sr1 : sr port map (
         alu_status_conn,
         sr_write_enable_conn,
	      sr_conn,
			core_rst,
			core_clk);

	-- connect regfile muxer
   regmux1 : regfile_mux port map (
			  regfile_mux_select_conn,
           imm_conn,
           alu_out_conn,
           data_d_conn);


end cpu_arch;
