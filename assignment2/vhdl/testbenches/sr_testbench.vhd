-------------------------------------------------------------------------------
--
-- Status Register Testbench
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Tests functionality of status register
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sr_testbench IS
END sr_testbench;

ARCHITECTURE behavior OF sr_testbench IS 
  
  COMPONENT sr
    PORT(
      sr_in : IN  std_logic_vector(0 downto 0);
      sr_write_enable : IN  std_logic;
      sr_out : OUT  std_logic_vector(0 downto 0);
      core_rst : IN  std_logic;
      core_clk : IN  std_logic
      );
  END COMPONENT;
  

  --Inputs
  signal sr_in : std_logic_vector(0 downto 0) := (others => '0');
  signal sr_write_enable : std_logic := '0';
  signal core_rst : std_logic := '0';
  signal core_clk : std_logic := '0';
  --Outputs
  signal sr_out : std_logic_vector(0 downto 0);

  -- Clock period definition
  constant core_clk_period : time := 10 ns;
  
BEGIN
  
  sr1: sr PORT MAP (
    sr_in => sr_in,
    sr_write_enable => sr_write_enable,
    sr_out => sr_out,
    core_rst => core_rst,
    core_clk => core_clk
    );

  -- Clock process definition
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
    

    core_rst <= '0';
    wait for core_clk_period*10;
    core_rst <= '1';

    -- Set input and write enable to 1, check that output is set to 1
    sr_in <= "1";
    sr_write_enable <= '1';
    wait for core_clk_period;
    assert sr_out = "1" report "Assert result failed" severity WARNING;
    
    -- Disable write enable and change input to 0, check that output is still 1
    sr_write_enable <= '0';
    wait for core_clk_period;
    sr_in <= "0";
    wait for core_clk_period;
    assert sr_out = "1" report "Assert result failed" severity WARNING;

    -- Enable input and check that output is changed to 0
    wait for core_clk_period;
    sr_write_enable <= '1';
    wait for core_clk_period;
    assert sr_out = "0" report "Assert result failed" severity WARNING;
    
    wait;
  end process;

END;
