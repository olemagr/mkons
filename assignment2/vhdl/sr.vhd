----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:18:51 09/28/2010 
-- Design Name: 
-- Module Name:    rs - Behavioral 
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

entity sr is
    Port ( 
      -- sr input
      sr_in           : in std_logic_vector(STATUS_BUS - 1 downto 0);
      sr_write_enable : in std_logic;
		-- sr output
		sr_out          : out std_logic_vector(STATUS_BUS - 1 downto 0);
		--
      core_rst        : in std_logic;
		core_clk			 : in std_logic);
end sr;

architecture Behavioral of sr is

   signal sr : std_logic_vector(STATUS_BUS - 1 downto 0);

begin

	process (core_rst, core_clk)
	begin
	
	   if core_rst = '0' then
         sr <= (others => '0');

      elsif rising_edge (core_clk) then
			if sr_write_enable = '1' then
				sr <= sr_in;
			end if;
	   end if;
	end process;
	
	sr_out <= sr;

end Behavioral;

