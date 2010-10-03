--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:03:58 09/30/2010
-- Design Name:   
-- Module Name:   C:/Users/khs/Documents/school/maskinvare/Oving 2/hardware/testbenches/sr_testbench.vhd
-- Project Name:  assignment2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sr
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
 
ENTITY sr_testbench IS
END sr_testbench;
 
ARCHITECTURE behavior OF sr_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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

   -- Clock period definitions
   constant core_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sr PORT MAP (
          sr_in => sr_in,
          sr_write_enable => sr_write_enable,
          sr_out => sr_out,
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

		core_rst <= '1';

      wait for core_clk_period*10;

		-- write "1" to status register
      sr_in <= "1";
		sr_write_enable <= '1';
		wait for core_clk_period;
		sr_write_enable <= '0';

      wait for core_clk_period*10;

		-- write "0" to status register
      sr_in <= "0";
		sr_write_enable <= '1';
		wait for core_clk_period;
		sr_write_enable <= '0';


      wait;
   end process;

END;
