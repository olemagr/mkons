--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:12:30 09/30/2010
-- Design Name:   
-- Module Name:   C:/Users/khs/Documents/school/maskinvare/Oving 2/hardware/testbenches/regmux_testbench.vhd
-- Project Name:  assignment2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: regfile_mux
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
 
ENTITY regmux_testbench IS
END regmux_testbench;
 
ARCHITECTURE behavior OF regmux_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: regfile_mux PORT MAP (
          mux_select => mux_select,
          immediate => immediate,
          alu_out => alu_out,
          data_d => data_d
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for 100 ns;

		alu_out <= "00110011";
		immediate <= "11001100";
		
		-- select immediate
		-- should set data_d to "11001100"
		mux_select <= '0';
		wait for 100 ns;
		
		
		-- select alu_out
		-- should set data_d to "00110011"
		mux_select <= '1';
		wait for 100 ns;

      wait;
   end process;

END;
