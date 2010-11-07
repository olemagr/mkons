library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.dmkons_package.all;

entity id_operand_mux is
   port(
      op_a_mux      : in std_logic;
      op_b_mux      : in std_logic;
      wb_data       : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      reg_data_a    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      reg_data_b    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_a          : out std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_b          : out std_logic_vector(DDATA_BUS - 1 downto 0)
	);
end id_operand_mux;

architecture Behavioral of id_operand_mux is
begin
  op_a <= reg_data_a WHEN op_a_mux = '0' ELSE
          wb_data;
  op_b <= reg_data_b WHEN op_b_mux = '0' ELSE
          wb_data;
end Behavioral;
