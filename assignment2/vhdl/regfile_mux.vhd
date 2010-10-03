----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:28:27 09/29/2010 
-- Design Name: 
-- Module Name:    regfile_mux - Behavioral 
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

entity regfile_mux is
    Port ( mux_select : in  STD_LOGIC;
           immediate : in  STD_LOGIC_VECTOR(IADDR_BUS - 1 downto 0);
           alu_out : in  STD_LOGIC_VECTOR(IADDR_BUS - 1 downto 0);
           data_d : out  STD_LOGIC_VECTOR(IADDR_BUS - 1 downto 0));
end regfile_mux;

architecture Behavioral of regfile_mux is

begin

   -- Muxer to select data_d_conn between Load immediate and alu_out
	with mux_select select
      data_d <= immediate when '1',
		          alu_out when others;


end Behavioral;

