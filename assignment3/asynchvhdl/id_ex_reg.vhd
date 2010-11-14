library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.dmkons_package.all;

entity id_ex_reg is
  port(
    core_rst : in  std_logic;
    core_clk : in  std_logic;
    reg_in   : in  id_ex;
    reg_out  : out id_ex
    );
end id_ex_reg;

architecture Behavioral of id_ex_reg is
  signal reg : id_ex;
begin
  reg_out <= reg;
  process (core_rst, core_clk)
  begin
    if core_rst = '0' then
      reg <= (("00", '0'), (others => '0'), (others => '0'), (others => '0'),
              (others              => '0'), (others => '0'), (others => '0'));
    elsif rising_edge (core_clk) then
      reg <= reg_in;
    end if;
  end process;
end Behavioral;

