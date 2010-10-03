--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:27:08 09/30/2010
-- Design Name:   
-- Module Name:   C:/Users/khs/Documents/school/maskinvare/Oving 2/hardware/testbenches/cpu_testbench.vhd
-- Project Name:  assignment2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cpu
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
use work.dmkons_package.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cpu_testbench IS
END cpu_testbench;
 
ARCHITECTURE behavior OF cpu_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for core_clk_period*10;

		-----------------------------
      -- Load program memory

		imem_w_enable <= '1';
		
		imem_w_address <= "00000000";
		imem_w_data <= "01000000000000000001000100000000";

		wait for core_clk_period;

		imem_w_address <= "00000001";
		imem_w_data <= "01000000000000000001001000000000";
		
		wait for core_clk_period;

		imem_w_address <= "00000010";
		imem_w_data <= "00000000001100000000000100010010";
		
		wait for core_clk_period;

		imem_w_address <= "00000011";
		imem_w_data <= "00000000001100000000001000010010";
		
		wait for core_clk_period;

		imem_w_address <= "00000100";
		imem_w_data <= "00100000000000000010000000000000";
		
		wait for core_clk_period;

		imem_w_enable <= '0';
		
		wait for core_clk_period;
		
		-----------------------------
      -- Run program
		
		-- this should run the fibonacci program, setting
		-- registers 1 and 2 to the fibonacci values.
		
		core_rst <= '1';

      wait;
   end process;

END;
