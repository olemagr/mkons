-------------------------------------------------------------------------------
--
-- Control Unit
-- 
-- TDT4255 - Assignment 3 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.dmkons_package.all;

entity control is
  
  port (
    -- Inputs
    IF_ID_valid         : in    std_logic;
    IF_ID_opcode        : in    std_logic_vector(OPCODE_BUS - 1 downto 0) ;
    IF_ID_Ra            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    IF_ID_Rb            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    ID_EX_Rd            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    ID_EX_write_reg     : in    std_logic;
    EX_WB_Rd            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    EX_WB_write_reg     : in    std_logic;
    zf_post_mux         : in    std_logic;

    -- Outputs
    pc_mux              : out   std_logic;
    pc_write_enable     : out   std_logic;
    set_IF_ID_valid     : out   std_logic;
    id_op_a_mux         : out   std_logic;
    id_op_b_mux         : out   std_logic;
    EX                  : out   EX_control;
    WB                  : out   WB_control
    
    
);

end control;

architecture cont of control is
  
begin

end cont;
