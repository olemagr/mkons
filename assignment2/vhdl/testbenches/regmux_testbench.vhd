-------------------------------------------------------------------------------
--
-- Register Multiplexer Testbench
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Tests functionality of regfile multiplexer
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regmux_testbench IS
END regmux_testbench;

ARCHITECTURE behavior OF regmux_testbench IS 
  
  COMPONENT regfile_mux
    PORT(
      mux_select : IN  std_logic;
      immediate : IN  std_logic_vector(7 downto 0);
      alu_out : IN  std_logic_vector(7 downto 0);
      data_d : OUT  std_logic_vector(7 downto 0)
      );
  END COMPONENT;

  --Inputs
  signal mux_select : std_logic := '0';
  signal immediate : std_logic_vector(7 downto 0) := (others => '0');
  signal alu_out : std_logic_vector(7 downto 0) := (others => '0');

  --Outputs
  signal data_d : std_logic_vector(7 downto 0);
  
BEGIN
  
  rm: regfile_mux PORT MAP (
    mux_select => mux_select,
    immediate => immediate,
    alu_out => alu_out,
    data_d => data_d
    );


  -- Stimulus process
  stim_proc: process
  begin		
    wait for 10 ns;

    alu_out <= 		"00110011";
    immediate <= 	"11001100";
    
    -- Should set data_d to immediate
    mux_select <= '0';
    wait for 10 ns;
    assert data_d = alu_out
      report "Assert result failed" severity WARNING;
    wait for 10 ns;
    
    -- Should set data_d to alu_out
    mux_select <= '1';
    wait for 10 ns;
    assert data_d = immediate
      report "Assert result failed" severity WARNING;
    
    wait;
  end process;

END;
