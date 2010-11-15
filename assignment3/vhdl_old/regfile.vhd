-------------------------------------------------------------------------------
-- Title      : regfile
-- Project    : dmkons cpu
-------------------------------------------------------------------------------
-- File       : regfile.vhd
-- Author     : DM
-- Company    : 
-- Last update: 2008-06-13
-- Platform   : BenERA, Virtex 1000E
-------------------------------------------------------------------------------
-- Description: Generic register file
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2003/08/05  1.0      djupdal	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.dmkons_package.all;

-------------------------------------------------------------------------------

entity regfile is

  port (
    -- read port A
    reg_a : in std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    data_a : out std_logic_vector(DDATA_BUS - 1 downto 0);
    -- read port B
    reg_b : in std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    data_b : out std_logic_vector(DDATA_BUS - 1 downto 0);
    -- write port
    reg_d : in std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    d_enable : in std_logic;
    data_d   : in std_logic_vector(DDATA_BUS - 1 downto 0);
    -- array with all current register values
    reg_values : out regfile_type;
    --
    rst      : in std_logic;
    core_clk : in std_logic);

end regfile;

-------------------------------------------------------------------------------

architecture regfile_arch of regfile is

  signal regs : regfile_type;

begin

  reg_values <= regs;

  -- read register a
  with reg_a select data_a <=
    regs(0) when "0000",
    regs(1) when "0001",
    regs(2) when "0010",
    regs(3) when "0011",
    regs(4) when "0100",
    regs(5) when "0101",
    regs(6) when "0110",
    regs(7) when "0111",
    regs(8) when "1000",
    regs(9) when "1001",
    regs(10) when "1010",
    regs(11) when "1011",
    regs(12) when "1100",
    regs(13) when "1101",
    regs(14) when "1110",
    regs(15) when "1111",
    (others => '0') when others;

  -- read register b
  with reg_b select data_b <=
    regs(0) when "0000",
    regs(1) when "0001",
    regs(2) when "0010",
    regs(3) when "0011",
    regs(4) when "0100",
    regs(5) when "0101",
    regs(6) when "0110",
    regs(7) when "0111",
    regs(8) when "1000",
    regs(9) when "1001",
    regs(10) when "1010",
    regs(11) when "1011",
    regs(12) when "1100",
    regs(13) when "1101",
    regs(14) when "1110",
    regs(15) when "1111",
    (others => '0') when others;

  -- write destination register
  process (rst, core_clk)
  begin

    if rst = '0' then
      regs <= (others => (others => '0'));

    elsif rising_edge (core_clk) then
      if d_enable = '1' then

        case reg_d is
          when "0000" =>
            null;   -- reg 0 is constant
          when "0001" =>
            regs(1) <= data_d;
          when "0010" =>
            regs(2) <= data_d;
          when "0011" =>
            regs(3) <= data_d;
          when "0100" =>
            regs(4) <= data_d;
          when "0101" =>
            regs(5) <= data_d;
          when "0110" =>
            regs(6) <= data_d;
          when "0111" =>
            regs(7) <= data_d;
          when "1000" =>
            regs(8) <= data_d;
          when "1001" =>
            regs(9) <= data_d;
          when "1010" =>
            regs(10) <= data_d;
          when "1011" =>
            regs(11) <= data_d;
          when "1100" =>
            regs(12) <= data_d;
          when "1101" =>
            regs(13) <= data_d;
          when "1110" =>
            regs(14) <= data_d;
          when "1111" =>
            regs(15) <= data_d;
          when others =>
            null;
            
        end case;

      end if;
    end if;
  end process;

end regfile_arch;
