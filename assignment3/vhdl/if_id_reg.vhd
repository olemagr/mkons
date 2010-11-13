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
      core_rst      : in std_logic;
      core_clk      : in std_logic;
      valid			  : in std_logic;
		ir            : in std_logic_vector( IDATA_BUS - 1 downto 0 );
		if_id_out     : out if_id
	);

end if_id_reg;

architecture Behavioral of if_id_reg is
   signal valid_reg : std_logic;
begin

	process (core_rst, core_clk)
	begin
		if core_rst = '0' then
			valid_reg <= '0';
		elsif rising_edge (core_clk) then
			valid_reg <= valid;
		end if;
	end process;
	if_id_out.valid		<= valid_reg;
	if_id_out.opcode 		<= ir( 31 downto 29 );
	if_id_out.funct  		<= ir( 23 downto 20 );
	if_id_out.imm    		<= ir( 19 downto 12 );
	if_id_out.rd     		<= ir( 11 downto 8 );
	if_id_out.ra     		<= ir( 7 downto 4 );
	if_id_out.rb     		<= ir( 3 downto 0 );
   
end Behavioral;

