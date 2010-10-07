-------------------------------------------------------------------------------
--
-- Regfile multiplexer
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Selects register input between ALU output and immediate value from 
-- instruction
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.dmkons_package.all;

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

