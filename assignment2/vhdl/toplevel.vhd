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

   component cpucom is
      port (
         -- signals for communicating with PCI-FPGA
         -- see BenERA users guide
         pciBusy   : in    std_logic;
         pciEmpty  : in    std_logic;
         pciRW     : out   std_logic;
         pciEnable : out   std_logic;
         pciData   : inout std_logic_vector(31 downto 0);

         -- imem write port
         imem_w_address : out std_logic_vector(IADDR_BUS - 1 downto 0);
         imem_w_data    : out std_logic_vector(IDATA_BUS - 1 downto 0);
         imem_w_enable  : out std_logic;

         -- register values in regfile
         reg_values : in regfile_type;

         -- clock used for cpu core
         core_clk : out std_logic;
         -- reset used for cpu core
         core_rst : out std_logic;

         rst : in std_logic;
         clk : in std_logic);
   end component;

   component cpu is
      port (
         -- imem write port
         imem_w_address : in std_logic_vector(IADDR_BUS - 1 downto 0);
         imem_w_data    : in std_logic_vector(IDATA_BUS - 1 downto 0);
         imem_w_enable  : in std_logic;

         -- register values in regfile
         reg_values : out regfile_type;

         -- clock used for cpu core
         core_clk : in std_logic;
         -- reset used for cpu core
         core_rst : in std_logic;
   		-- BenERA LEDS
	   	led : out std_logic_vector(15 downto 0));	 
   end component;

	-- signals connecting cpu and cpucom
	-- imem write port
   signal imem_w_address_conn : std_logic_vector(IADDR_BUS - 1 downto 0);
   signal imem_w_data_conn    : std_logic_vector(IDATA_BUS - 1 downto 0);
   signal imem_w_enable_conn  : std_logic;

   -- register values in regfile
   signal reg_values_conn : regfile_type;

   -- clock used for cpu core
   signal core_clk_conn : std_logic;
   -- reset used for cpu core
   signal core_rst_conn : std_logic;
	
begin

	cpu1 : cpu port map (
	   -- imem write port
      imem_w_address_conn,
      imem_w_data_conn,
      imem_w_enable_conn,

      -- register values in regfile
      reg_values_conn,

      -- clock used for cpu core
      core_clk_conn,
      -- reset used for cpu core
      core_rst_conn,
		-- BenERA LEDS
		led);
		
   cpucom1 : cpucom port map (
      -- signals for communicating with PCI-FPGA
      -- see BenERA users guide
      pciBusy,
      pciEmpty,
      pciRW,
      pciEnable,
      pciData,

      -- imem write port
      imem_w_address_conn,
      imem_w_data_conn,
      imem_w_enable_conn,

      -- register values in regfile
      reg_values_conn,

      -- clock used for cpu core
      core_clk_conn,
      -- reset used for cpu core
      core_rst_conn,

      rst,
      clk);

end toplevel_arch;
