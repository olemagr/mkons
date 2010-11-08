-------------------------------------------------------------------------------
--
-- CPU Testbench
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Writes a simple program to memory, simulates execution and
-- verifies by asserting correct answers.
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.dmkons_package.all;

ENTITY cpu_testbench IS
END cpu_testbench;

ARCHITECTURE behavior OF cpu_testbench IS 
  
  COMPONENT cpu
    PORT(
      imem_w_address : IN  std_logic_vector(7 downto 0);
      imem_w_data : IN  std_logic_vector(31 downto 0);
      imem_w_enable : IN  std_logic;
      reg_values : OUT  regfile_type;
      core_clk : IN  std_logic;
      core_rst : IN  std_logic;
      led : OUT  std_logic_vector(15 downto 0)
      );
  END COMPONENT;
  

  --Inputs
  signal imem_w_address : std_logic_vector(7 downto 0) := (others => '0');
  signal imem_w_data : std_logic_vector(31 downto 0) := (others => '0');
  signal imem_w_enable : std_logic := '0';
  signal core_clk : std_logic := '0';
  signal core_rst : std_logic := '0';

  --Outputs
  signal reg_values : regfile_type;
  signal led : std_logic_vector(15 downto 0);

  -- Clock period definitions
  constant core_clk_period : time := 10 ns;


  -- procedure to abstract loading of instructions
  procedure load_instruction (
    -- input signals, used to set instruction and 
    address : in integer;
    opcode : in std_logic_vector(2 downto 0);
    funct : in std_logic_vector(3 downto 0);
    imm : in integer;
    rd : in integer;
    rb : in integer;
    ra : in integer;
    -- signals to be set
    signal w_address : out std_logic_vector(7 downto 0);
    signal w_data : out std_logic_vector(31 downto 0);
    signal w_enable : out std_logic
    )
  is
  begin
    -- prepare to write
    w_enable <= '1';
    
    -- convert address from integer to std_logic_vector
    w_address <= std_logic_vector(to_unsigned(address, 8));

    -- create instruction to be loaded from meaningful parameters
    w_data <= 
      opcode & 
      "00000" &
      funct &
      std_logic_vector(to_unsigned(imm, 8)) &
      std_logic_vector(to_unsigned(rd, 4)) &
      std_logic_vector(to_unsigned(rb, 4)) &
      std_logic_vector(to_unsigned(ra, 4));
    
    wait for core_clk_period;
    
    -- Do not write
    w_enable <= '0';
  end load_instruction;


  procedure assert_result (
    -- Compares register value with expected result
    -- and produces a warning if not equal 
    reg_value : in std_logic_vector(7 downto 0);
    expected : in integer
    ) is
  begin
    assert to_integer(unsigned(reg_value)) = expected
      report "Assert result failed" severity WARNING;
  end assert_result;

BEGIN
  
  -- Instantiate the CPU
  CPU_INST: cpu PORT MAP (
    imem_w_address => imem_w_address,
    imem_w_data => imem_w_data,
    imem_w_enable => imem_w_enable,
    reg_values => reg_values,
    core_clk => core_clk,
    core_rst => core_rst,
    led => led
    );


  -- Clock process definitions
  core_clk_process :process
  begin
    core_clk <= '0';
    wait for core_clk_period/2;
    core_clk <= '1';
    wait for core_clk_period/2;
  end process;
  
  -- Stimulus process
  stim_proc: process
  begin		

    wait for core_clk_period*10;

    -----------------------------
    -- Load program memory
    -----------------------------

    load_instruction (0, LDI,      ALU_MOVE, 1, 1, 0, 0,
                      imem_w_address, imem_w_data, imem_w_enable);
    load_instruction (1, LDI,      ALU_MOVE, 1, 2, 0, 0,
                      imem_w_address, imem_w_data, imem_w_enable);
    load_instruction (2, ALU_INST, ALU_ADD,  0, 3, 1, 2,
                      imem_w_address, imem_w_data, imem_w_enable);
    load_instruction (3, ALU_INST, ALU_ADD,  0, 4, 2, 3,
                      imem_w_address, imem_w_data, imem_w_enable);
    load_instruction (4, ALU_INST, ALU_MOVE, 0, 1, 3, 0,
                      imem_w_address, imem_w_data, imem_w_enable);
    load_instruction (5, ALU_INST, ALU_MOVE, 0, 2, 4, 0,
                      imem_w_address, imem_w_data, imem_w_enable);
    load_instruction (6, BNZ, 	   ALU_MOVE, 2, 0, 0, 0,
                      imem_w_address, imem_w_data, imem_w_enable);
    
    -----------------------------
    -- Run program
    -----------------------------
    
    -- this should run the fibonacci program, setting
    -- the move operations are not necessary, but we use them to test it.
    
    core_rst <= '1';

    -----------------------------
    -- Assert the result
    -----------------------------

    wait for core_clk_period;

    -- It takes 2 clock periods for result to appear (fetch -> execute)

--    wait for 2*core_clk_period;		assert_result(reg_values(1), 1);
--    wait for 2*core_clk_period;		assert_result(reg_values(2), 1);
--    wait for 2*core_clk_period;		assert_result(reg_values(3), 2);
--    wait for 2*core_clk_period;		assert_result(reg_values(4), 3);
--    wait for 2*core_clk_period;		assert_result(reg_values(1), 2);
--    wait for 2*core_clk_period;		assert_result(reg_values(2), 3);
--    wait for 2*core_clk_period; 		-- Wait for jump instruction
--    wait for 2*core_clk_period;		assert_result(reg_values(3), 5);
--    wait for 2*core_clk_period;		assert_result(reg_values(4), 8);
--    wait for 2*core_clk_period;		assert_result(reg_values(1), 5);
--    wait for 2*core_clk_period;		assert_result(reg_values(2), 8);
--    wait for 2*core_clk_period; 		-- Wait for jump instruction
--    wait for 2*core_clk_period;		assert_result(reg_values(3), 13);		
--    wait for 2*core_clk_period;		assert_result(reg_values(4), 21);
--    wait for 2*core_clk_period;		assert_result(reg_values(1), 13);
--    wait for 2*core_clk_period;		assert_result(reg_values(2), 21);
    
    wait;
  end process;

END;
