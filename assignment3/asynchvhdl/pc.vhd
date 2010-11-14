-------------------------------------------------------------------------------
--
-- Program Counter
-- 
-- TDT4255 - Assignment 3 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Counter keeping track of instruction address. Either increments or sets to  
-- provided absolute address based on input from control unit and current 
-- instruction.
-- 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;

entity pc is
  
  port (
    -- PC input
    pc_in           : in  std_logic_vector(IADDR_BUS - 1 downto 0);
    pc_write_enable : in  std_logic;
    pc_mux_sel      : in  std_logic;
    -- PC output to memory
    pc_out          : out std_logic_vector(IADDR_BUS - 1 downto 0);
    -- Global clock and reset
    core_rst        : in  std_logic;
    core_clk        : in  std_logic);

end pc;

architecture pc_arch of pc is

  -- Registered signal
  signal pc : std_logic_vector(IADDR_BUS - 1 downto 0);

begin

  process (core_rst, core_clk)
  begin
    
    if core_rst = '0' then
      pc <= (others => '0');

      -- Update on rising edge to value based on control input
    elsif rising_edge (core_clk) then
      
      
      if pc_write_enable = '1' then
        if pc_mux_sel = '1' then
          -- Set program counter to given immediate value
          pc <= pc_in;
        else
          -- Or increment to next sequential instrucion
          pc <= std_logic_vector(unsigned(pc)+1);
        end if;
      end if;
      
    end if;
  end process;

  pc_out <= pc;

end pc_arch;
