--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:30:45 09/30/2010
-- Design Name:   
-- Module Name:   C:/Users/khs/Documents/school/maskinvare/Oving 2/hardware/testbenches/alu_testbench.vhd
-- Project Name:  assignment2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY alu_testbench IS
END alu_testbench;
 
ARCHITECTURE behavior OF alu_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          alu_funct => alu_funct,
          alu_in_a => alu_in_a,
          alu_in_b => alu_in_b,
          alu_out => alu_out,
          alu_status => alu_status
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for 100 ns;
		-- test addition
		alu_funct <= "11";
		alu_in_a <= "00001000";
		alu_in_b <= "00001100";
		-- should set alu_out to 00010100
		-- and alu_status to 0


      wait for 100 ns;
		-- test addition and zero flag
		alu_funct <= "11";
		alu_in_a <= "00000001";
		alu_in_b <= "11111111";
		-- should set alu_out to 00000000
		-- and alu_status to 1
		

      wait for 100 ns;
		-- test and
		alu_funct <= "01";
		alu_in_a <= "00010001";
		alu_in_b <= "11011100";
		-- should set alu_out to 00010000
		-- and alu_status to 0
		
		
      wait for 100 ns;
		-- test and and zero flag
		alu_funct <= "01";
		alu_in_a <= "00010001";
		alu_in_b <= "11001100";
		-- should set alu_out to 00000000
		-- and alu_status to 1


      wait for 100 ns;
		-- test move
		alu_funct <= "00";
		alu_in_a <= "00010001";
		alu_in_b <= "11001100";
		-- should set alu_out to 00010001
		-- and alu_status to 0
		

      wait for 100 ns;
		-- test move and zero flag
		alu_funct <= "00";
		alu_in_a <= "00000000";
		alu_in_b <= "11001100";
		-- should set alu_out to 00000000
		-- and alu_status to 1


      wait;
   end process;

END;
