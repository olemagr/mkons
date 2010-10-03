--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:44:55 09/30/2010
-- Design Name:   
-- Module Name:   C:/Users/khs/Documents/school/maskinvare/Oving 2/hardware/testbenches/pc_testbench.vhd
-- Project Name:  assignment2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pc
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pc_testbench IS
END pc_testbench;
 
ARCHITECTURE behavior OF pc_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pc PORT MAP (
          pc_in => pc_in,
          pc_write_enable => pc_write_enable,
          pc_mux_sel => pc_mux_sel,
          pc_out => pc_out,
          core_rst => core_rst,
          core_clk => core_clk
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for core_clk_period*10;
		core_rst <= '1';
		
      -- set register to +1 5 times 
		pc_mux_sel <= '0';
		pc_write_enable <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;
		pc_write_enable <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;
		pc_write_enable <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;
		pc_write_enable <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;
		pc_write_enable <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;
		
		-- load register with info with "01000000"
		pc_in <= "01000000";
		pc_write_enable <= '1';
		pc_mux_sel <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;

		-- set register to +1 2 times
		pc_mux_sel <= '0';
		pc_write_enable <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;
		pc_write_enable <= '1';
      wait for core_clk_period;
		pc_write_enable <= '0';
      wait for core_clk_period;

      wait;
   end process;

END;
