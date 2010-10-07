-------------------------------------------------------------------------------
--
-- Control Unit Testbench
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Tests functionality of the Control unit
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.control_const.all;

ENTITY controltest_vhd IS
END controltest_vhd;

ARCHITECTURE behavior OF controltest_vhd IS 

  COMPONENT ctrl
    PORT(
      opcode : IN std_logic_vector(2 downto 0);
      sr : IN std_logic_vector(0 to 0);
      core_clk : IN std_logic;
      core_rst : IN std_logic;          
      pc_mux_select : OUT std_logic;
      pc_write_enable : OUT std_logic;
      regfile_mux_select : OUT std_logic;
      regfile_write_enable : OUT std_logic;
      sr_write_enable : OUT std_logic
      );
  END COMPONENT;

  --Inputs
  SIGNAL core_clk :  std_logic := '0';
  SIGNAL core_rst :  std_logic := '0';
  SIGNAL opcode :  std_logic_vector(2 downto 0) := (others=>'0');
  SIGNAL sr :  std_logic_vector(0 to 0) := (others=>'0');

  --Outputs
  SIGNAL pc_mux_select :  std_logic;
  SIGNAL pc_write_enable :  std_logic;
  SIGNAL regfile_mux_select :  std_logic;
  SIGNAL regfile_write_enable :  std_logic;
  SIGNAL sr_write_enable :  std_logic;
  
  signal combined_output : std_logic_vector(4 downto 0);
  
  procedure assert_output (
    -- Compares status with expected result
    -- and produces a warning if not equal 
    expected : in std_logic_vector(4 downto 0);
    comb_out : in std_logic_vector(4 downto 0)
    
    ) is
  begin
    assert expected = comb_out
      report "Assert result failed" severity WARNING;
  end assert_output;

BEGIN

  cu1 : ctrl PORT MAP(
    opcode => opcode,
    sr => sr,
    pc_mux_select => pc_mux_select,
    pc_write_enable => pc_write_enable,
    regfile_mux_select => regfile_mux_select,
    regfile_write_enable => regfile_write_enable,
    sr_write_enable => sr_write_enable,
    core_clk => core_clk,
    core_rst => core_rst
    );
  
  -- Simplifies output assertions
  combined_output <= pc_mux_select & pc_write_enable & regfile_mux_select 
                     & regfile_write_enable&sr_write_enable;
  
  extclk : process
  begin
    core_clk <= '1';
    wait for 5 ns;
    core_clk <= '0';
    wait for 5 ns;
  end process;
  
  tb : PROCESS
  BEGIN
    sr <= "0";
    opcode <= ALU_INST;
    core_rst <= '0';
    wait for 5 ns;
    core_rst <= '1';
    wait for 5 ns;
    wait for 5 ns;
    
    -- Check outputs for executestate and ALU instruction
    assert_output("01011", combined_output);
    wait for 10 ns;
    
    -- Check outputs for fetch state
    assert_output("-0-00", combined_output);
    
    -- Branch not zero with zero flag set
    sr <= "1";
    opcode <= BNZ;
    wait for 10 ns;
    assert_output("01-00", combined_output);
    
    -- Branch not zero with zero flag cleared
    wait for 10 ns;
    sr <= "0";
    wait for 10 ns;
    assert_output("11-00", combined_output);
    
    -- Check outputs for Load immediate
    wait for 10 ns;
    opcode <= LDI;
    wait for 10 ns;
    assert_output("01110", combined_output);
    
    wait; -- will wait forever
  END PROCESS;

END;
