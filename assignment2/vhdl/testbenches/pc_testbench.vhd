-------------------------------------------------------------------------------
--
-- Program Counter Testbench
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Tests Program counter component. Produces warning if unexpected results.
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pc_testbench IS
END pc_testbench;

ARCHITECTURE behavior OF pc_testbench IS 
  
  COMPONENT pc
    PORT(
      pc_in : IN  std_logic_vector(7 downto 0);
      pc_write_enable : IN  std_logic;
      pc_mux_sel : IN  std_logic;
      pc_out : OUT  std_logic_vector(7 downto 0);
      core_rst : IN  std_logic;
      core_clk : IN  std_logic
      );
  END COMPONENT;
  

  --Inputs
  signal pc_in : std_logic_vector(7 downto 0) := (others => '0');
  signal pc_write_enable : std_logic := '0';
  signal pc_mux_sel : std_logic := '0';
  signal core_rst : std_logic := '0';
  signal core_clk : std_logic := '0';

  --Outputs
  signal pc_out : std_logic_vector(7 downto 0);

  -- Clock period definitions
  constant core_clk_period : time := 10 ns;
  
  procedure assert_result (
    -- Compares pc output with expected result
    -- and produces a warning if not equal 
    pc_output : in std_logic_vector(7 downto 0);
    expected : in std_logic_vector(7 downto 0)
    ) is
  begin
    assert pc_output = expected
      report "Assert result failed" severity WARNING;
  end assert_result;
  
BEGIN
  
  pc1: pc PORT MAP (
    pc_in => pc_in,
    pc_write_enable => pc_write_enable,
    pc_mux_sel => pc_mux_sel,
    pc_out => pc_out,
    core_rst => core_rst,
    core_clk => core_clk
    );

  -- Clock process
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
    
    wait for core_clk_period;
    assert_result(pc_out, "00000000");
    -- set register to +1 5 times 
    pc_mux_sel <= '0';
    pc_write_enable <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "00000001");
    pc_write_enable <= '0';
    wait for core_clk_period;
    pc_write_enable <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "00000010");
    pc_write_enable <= '0';
    wait for core_clk_period;
    pc_write_enable <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "00000011");
    pc_write_enable <= '0';
    wait for core_clk_period;
    pc_write_enable <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "00000100");
    pc_write_enable <= '0';
    wait for core_clk_period;
    pc_write_enable <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "00000101");
    pc_write_enable <= '0';
    wait for core_clk_period;
    
    -- Load register with immediate value "01000000"
    pc_in <= "01000000";
    pc_write_enable <= '1';
    pc_mux_sel <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "01000000");
    pc_write_enable <= '0';
    wait for core_clk_period;

    -- Set register to +1 2 times
    pc_mux_sel <= '0';
    pc_write_enable <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "01000001");
    pc_write_enable <= '0';
    wait for core_clk_period;
    pc_write_enable <= '1';
    wait for core_clk_period;
    assert_result(pc_out, "01000010");
    pc_write_enable <= '0';
    wait for core_clk_period;

    wait;
  end process;

END;
