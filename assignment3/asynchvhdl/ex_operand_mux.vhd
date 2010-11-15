-------------------------------------------------------------------------------
--
-- Ex operand mux
--
-- Muxes the operands in the execute stage based on output from control unit
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.dmkons_package.all;

entity ex_operand_mux is
   port(
      op_a_mux      : in std_logic;
      op_b_mux      : in std_logic;
      wb_data       : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      idex_data_a    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      idex_data_b    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_a          : out std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_b          : out std_logic_vector(DDATA_BUS - 1 downto 0)
	);
end ex_operand_mux;

architecture Behavioral of ex_operand_mux is
begin
  -- Send the standard value through when 0, else send
  -- writeback value.
  op_a <= idex_data_a WHEN op_a_mux = '0' ELSE
          wb_data;
  op_b <= idex_data_b WHEN op_b_mux = '0' ELSE
          wb_data;
end Behavioral;
