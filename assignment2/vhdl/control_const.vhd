--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.dmkons_package.all;

package control_const is

   -- constants describing instructions

	-- alu instruction:
	-- writes result of Ra "funct" Rb to Rd
   constant ALU_INST		: std_logic_vector(OPCODE_BUS - 1 downto 0) := "000";
	
	-- branch if not zero:
	-- jumps to instruction located at immediate if zero flag in status register is set to 1 
   constant BNZ		: std_logic_vector(OPCODE_BUS - 1 downto 0) := "001";
	
	-- load immediate:
	-- loads the value specified by immediate into register Rd
   constant LDI		: std_logic_vector(OPCODE_BUS - 1 downto 0) := "010";
 

end control_const;
