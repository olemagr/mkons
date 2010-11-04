-------------------------------------------------------------------------------
-- Title      : memory block
-- Project    : dmkons, vhdl-øving på Nalle
-------------------------------------------------------------------------------
-- File       : mem.vhd
-- Author     : Asbjørn Djupdal  <asbjoern@djupdal.org>
-- Company    : 
-- Last update: 2008/06/18
-- Platform   : BenERA, Virtex 1000E
-------------------------------------------------------------------------------
-- Description: Generic memory block
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2003/08/05  1.0      djupdal	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;

-------------------------------------------------------------------------------

entity mem is

  generic (
    MEM_ADDR_BUS : integer := 8;
    MEM_DATA_BUS : integer := 32);

  port (
    -- read port
    address  : in  std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
    data     : out std_logic_vector(MEM_DATA_BUS - 1 downto 0);

    -- write port
    w_address : in std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
    w_data    : in std_logic_vector(MEM_DATA_BUS - 1 downto 0);
    w_enable  : in std_logic;

    core_clk : in std_logic);

end mem;

-------------------------------------------------------------------------------

architecture mem_arch of mem is

  -- number of words in memory
  constant MEM_SIZE : integer := 2 ** MEM_ADDR_BUS;

  type mem_type is array (0 to MEM_SIZE - 1)
    of std_logic_vector(MEM_DATA_BUS - 1 downto 0);

  signal mem_storage : mem_type := (others => (others => '0'));
  signal address_reg : std_logic_vector(MEM_ADDR_BUS - 1 downto 0);

begin

  process (core_clk)
  begin
    if rising_edge (core_clk) then
      if w_enable = '1' then
        mem_storage (to_integer (unsigned (w_address))) <= w_data;
      end if;
      address_reg <= address;
    end if;
    data <= mem_storage (to_integer(unsigned (address_reg)));
  end process;

end mem_arch;
