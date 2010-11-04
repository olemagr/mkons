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
      write_enable  : in std_logic;
      ctrl          : in std_logic;
   	ir            : in std_logic_vector( IDATA_BUS - 1 downto 0 );

   	reg_out       : out if_id
	);

end if_id_reg;

architecture Behavioral of if_id_reg is
   signal reg : if_id;
begin

  process (core_rst, core_clk)
  begin
    
    if core_rst = '0' then
      reg <= (others => (others => '0'));

    elsif rising_edge (core_clk) then
      if write_enable = '1' then
		  
		  reg.opcode <= std_logic_vector( 31 downto 29 );
		  reg.funct  <= std_logic_vector( 23 downto 20 );
		  
		  reg.imm    <= std_logic_vector( 19 downto 12 );
		  
		  reg.rd     <= std_logic_vector( 11 downto 8 );
		  reg.ra     <= std_logic_vector( 7 downto 4 );
		  reg.rb     <= std_logic_vector( 3 downto 0 );
		  
      end if;
    end if;
  end process;
  
  reg_out <= reg;

end Behavioral;

