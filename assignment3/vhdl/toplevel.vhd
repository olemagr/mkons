-------------------------------------------------------------------------------
-- Title      : Toplevel, cpu core
-- Project    : dmkons multicycle
-------------------------------------------------------------------------------
-- File       : toplevel.vhd
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

entity toplevel is
  
  port (

    -- PCI FPGA signals
    pciBusy   : in    std_logic;
    pciEmpty  : in    std_logic;
    pciRW     : out   std_logic;
    pciEnable : out   std_logic;
    pciData   : inout std_logic_vector(31 downto 0);

    -- BenERA LEDS
    led : out std_logic_vector(15 downto 0);

    rst : in std_logic;
    clk : in std_logic);

end toplevel;

architecture toplevel_arch of toplevel is

begin

end toplevel_arch;
