-------------------------------------------------------------------------------
--
-- Status Register
-- 
-- TDT4255 - Assignment 3 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Status register. Written on rising edge to value given by ALU, if write 
-- enable set by control unit. Writeback mux built in.
-- 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.dmkons_package.all;

entity sr is
  port (
    -- SR input
    sr_in           : in  std_logic_vector(STATUS_BUS - 1 downto 0);
    sr_write_enable : in  std_logic;
    -- SR output
    sr_out          : out std_logic_vector(STATUS_BUS - 1 downto 0);
    -- Global clock and reset
    core_rst        : in  std_logic;
    core_clk        : in  std_logic);
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
  -- BNZ requires newest status. This will be sr_in in case of an active arithmetic operation
  -- or the stored value if the current executing is something else.
  sr_out <= sr when sr_write_enable = '0' else
            sr_in;

end Behavioral;

