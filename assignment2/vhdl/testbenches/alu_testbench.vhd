-------------------------------------------------------------------------------
--
-- ALU Testbench
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Tests ALU for correct output.
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu_testbench IS
END alu_testbench;

ARCHITECTURE behavior OF alu_testbench IS 
  
  COMPONENT alu
    PORT(
      alu_funct : IN  std_logic_vector(1 downto 0);
      alu_in_a : IN  std_logic_vector(7 downto 0);
      alu_in_b : IN  std_logic_vector(7 downto 0);
      alu_out : OUT  std_logic_vector(7 downto 0);
      alu_status : OUT  std_logic_vector(0 downto 0)
      );
  END COMPONENT;
  

  --Inputs
  signal alu_funct : std_logic_vector(1 downto 0) := (others => '0');
  signal alu_in_a : std_logic_vector(7 downto 0) := (others => '0');
  signal alu_in_b : std_logic_vector(7 downto 0) := (others => '0');

  --Outputs
  signal alu_out : std_logic_vector(7 downto 0);
  signal alu_status : std_logic_vector(0 downto 0);
  

  procedure assert_result (
    -- Compares alu out with expected result
    -- and produces a warning if not equal 
    alu_res : in std_logic_vector(7 downto 0);
    expected : in integer
    ) is
  begin
    assert to_integer(unsigned(alu_res)) = expected
      report "Assert result failed" severity WARNING;
  end assert_result;

  procedure assert_status (
    -- Compares status with expected result
    -- and produces a warning if not equal 
    status : in std_logic_vector(0 downto 0);
    exp_status : in std_logic_vector(0 downto 0)
    ) is
  begin
    assert status = exp_status
      report "Assert result failed" severity WARNING;
  end assert_status;
  
  procedure set_input (
    -- Sets std_logic_vector input from ints
    a : in integer;
    b : in integer;
	 signal alu_a : out std_logic_vector(7 downto 0);
	 signal alu_b : out std_logic_vector(7 downto 0)
    ) is
  begin
    alu_a <= std_logic_vector(to_unsigned(a, 8));
    alu_b <= std_logic_vector(to_unsigned(b, 8));
  end set_input;


BEGIN
  alu_inst: alu PORT MAP (
    alu_funct => alu_funct,
    alu_in_a => alu_in_a,
    alu_in_b => alu_in_b,
    alu_out => alu_out,
    alu_status => alu_status
    );


  -- Stimulus process
  STIMULUS: process
  begin		
    -- Test addition
    alu_funct <= "11";
    set_input(14,62, alu_in_a, alu_in_b);
    wait for 10 ns;
    assert_result(alu_out, 76);
	 assert_status(alu_status, "0");
    
    wait for 10 ns;
    -- Test addition and zero flag
    set_input(0,0, alu_in_a, alu_in_b);
    wait for 10 ns;
    assert_result(alu_out, 0); 
	 assert_status(alu_status, "1");
	 
	 wait for 10 ns;
    -- Test addition and zero flag
    set_input(255,1, alu_in_a, alu_in_b);
    wait for 10 ns;
    assert_result(alu_out, 0); 
	 assert_status(alu_status, "1");
    
    wait for 10 ns;
    -- Test and
    alu_funct <= "01";
    alu_in_a <= "00000101";
    alu_in_b <= "11011100";
    wait for 10 ns;
    -- Should set alu_out to 00000100 - 4
    assert_result(alu_out, 4); 
    -- And alu_status to 0
    assert_status(alu_status, "0");
    
    wait for 10 ns;
    -- test and and zero flag
    alu_funct <= "01";
    alu_in_a <= "00010001";
    alu_in_b <= "11001100";
    wait for 10 ns;
    -- should set alu_out to 00000000
    assert_result(alu_out, 0); 
    -- and alu_status to 1
    assert_status(alu_status, "1");
    
    wait for 10 ns;
    -- test move
    alu_funct <= "00";
    set_input(42,56, alu_in_a, alu_in_b);
    wait for 10 ns;
    -- should set alu_out to 42
    assert_result(alu_out, 42);
    -- and alu_status to 0
    assert_status(alu_status, "0");
    

    wait for 10 ns;
    -- test move and zero flag
    alu_funct <= "00";
    set_input(0,12, alu_in_a, alu_in_b);
    wait for 10 ns;
    -- should set alu_out to 0
    assert_result(alu_out, 0);
    -- and alu_status to 1
    assert_status(alu_status, "1");
    
    wait;
  end process;

END;
