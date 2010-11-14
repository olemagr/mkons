-------------------------------------------------------------------------------
-- Title      : ALU
-- Project    : dmkons, vhdl-øving på Nalle
-------------------------------------------------------------------------------
-- File       : alu.vhd
-- Author     : DM
-- Company    : 
-- Last update: 2008-06-18
-- Platform   : BenERA, Virtex 1000E
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2003/08/07  1.0      djupdal	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;

entity alu is

  port (
    alu_funct : in std_logic_vector(FUNCT_BUS - 1 downto 0);
    alu_in_a  : in std_logic_vector(DDATA_BUS - 1 downto 0);
    alu_in_b  : in std_logic_vector(DDATA_BUS - 1 downto 0);

    alu_out    : out std_logic_vector(DDATA_BUS - 1 downto 0);
    alu_status : out std_logic_vector(STATUS_BUS - 1 downto 0));

end alu;    

-------------------------------------------------------------------------------

architecture alu_arch of alu is

  signal alu_out_i : std_logic_vector(DDATA_BUS - 1 downto 0);

begin

  -- alu
  process (alu_funct, alu_in_a, alu_in_b)
  begin
    case alu_funct is

      -- move
      when "0000" =>
        alu_out_i <= alu_in_a;

      -- and
      when "0001" =>
        alu_out_i <= alu_in_a and alu_in_b;

      -- add
      when "0111" =>
        alu_out_i <= std_logic_vector (signed (alu_in_a) + signed (alu_in_b));

      when others =>
        alu_out_i <= (others => '0');

    end case;
  end process;

  alu_out <= alu_out_i(DDATA_BUS - 1 downto 0);

  -- set zero flag
  alu_status(0) <= '1' when alu_out_i = "00000000" else '0';

end alu_arch;
