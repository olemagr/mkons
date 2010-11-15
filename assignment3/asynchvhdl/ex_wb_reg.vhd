-------------------------------------------------------------------------------
--
-- EX/WB pipeline register
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.dmkons_package.all;

entity ex_wb_reg is
   port(
      core_rst      : in std_logic;
      core_clk      : in std_logic;
      reg_in        : in ex_wb;
      reg_out       : out ex_wb
	);
end ex_wb_reg;

architecture Behavioral of ex_wb_reg is
   signal reg : ex_wb;
begin
  reg_out <= reg;
  process (core_rst, core_clk)
  begin
    if core_rst = '0' then
      reg <= (("00",'0'),(others => '0'),(others => '0'), (others => '0'), (others => '0'));
    elsif rising_edge (core_clk) then
      reg <= reg_in;		  
    end if;
  end process;
end Behavioral;
