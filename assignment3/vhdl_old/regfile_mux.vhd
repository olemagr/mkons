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
use IEEE.STD_LOGIC_1164.ALL;
use work.dmkons_package.all;

entity regfile_mux is
  Port ( selector : in  wb_mux_type;
         immediate : in  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0);
         alu_out : in  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0);
			mem_out : in  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0);
         data_d : out  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0));
end regfile_mux;

architecture Behavioral of regfile_mux is

begin

  -- Muxer to select data_d_conn between Load immediate and alu_out
  with selector select
    data_d <= 	immediate 			when WB_IMMEDIATE,
					alu_out 				when WB_ALU,
					mem_out 				when WB_MEMORY,
					(others => '0') 	when others;
	 
end Behavioral;

