----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:33:55 11/04/2010 
-- Design Name: 
-- Module Name:    if_id_reg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.dmkons_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity if_id_reg is

   port(
	   ctrl   : in std_logic;
		ir     : in std_logic_vector( IDATA_BUS - 1 downto 0 );
		
		opcode : out std_logic_vector( OPCODE_BUS - 1 downto 0 );
		rd     : out std_logic_vector( REG_ADDR_BUS - 1 downto 0 );
		imm    : out std_logic_vector( DDATA_BUS - 1 downto 0 );
		ra     : out std_logic_vector( REG_ADDR_BUS - 1 downto 0 );
		rb     : out std_logic_vector( REG_ADDR_BUS - 1 downto 0 );
		funct  : out std_logic_vector( FUNCT_BUS - 1 downto 0 );
	);

end if_id_reg;

architecture Behavioral of if_id_reg is

begin


end Behavioral;

