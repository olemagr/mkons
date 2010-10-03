
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:47:03 09/30/2010
-- Design Name:   ctrl
-- Module Name:   C:/Xilinx/olemagrex2/controltest.vhd
-- Project Name:  olemagrex2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ctrl
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.control_const.all;

ENTITY controltest_vhd IS
END controltest_vhd;

ARCHITECTURE behavior OF controltest_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
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

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ctrl PORT MAP(
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
	
	extclk : process
	begin
		core_clk <= '1';
		wait for 5 ns;
		core_clk <= '0';
		wait for 5 ns;
	end process;
	
	tb : PROCESS
	BEGIN
		wait for 10 ns;
		sr <= "0";
		opcode <= ALU_INST;
		wait for 10 ns;
		core_rst <= '0';
		wait for 10 ns;
		core_rst <= '1';
		wait for 20 ns;
		sr <= "1";
		opcode <= BNZ;
		wait for 20 ns;
		sr <= "0";
		wait for 20 ns;
		opcode <= LDI;
		wait for 20 ns;
		
		-- Place stimulus here
		wait; -- will wait forever
	END PROCESS;

END;
