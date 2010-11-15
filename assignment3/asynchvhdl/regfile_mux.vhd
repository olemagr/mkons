-------------------------------------------------------------------------------
--
-- Regfile multiplexer
-- 
-- TDT4255 - Assignment 3 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Selects register input between ALU output, memory output and immediate value from 
-- instruction
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.dmkons_package.all;

entity regfile_mux is
  port (selector   : in  wb_mux_type;
         immediate : in  std_logic_vector(DDATA_BUS - 1 downto 0);
         alu_out   : in  std_logic_vector(DDATA_BUS - 1 downto 0);
         mem_out   : in  std_logic_vector(DDATA_BUS - 1 downto 0);
         data_d    : out std_logic_vector(DDATA_BUS - 1 downto 0));
end regfile_mux;

architecture Behavioral of regfile_mux is

begin

  with selector select
    data_d <= immediate when WB_IMMEDIATE,
    alu_out             when WB_ALU,
    mem_out             when WB_MEMORY,
    (others => '0')     when others;
  
end Behavioral;

