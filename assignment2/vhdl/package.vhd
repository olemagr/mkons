-------------------------------------------------------------------------------
-- Title      : package
-- Project    : dmkons cpu
-------------------------------------------------------------------------------
-- File       : package.vhd
-- Author     : DM
-- Company    : 
-- Last update: 2008-06-18
-- Platform   : BenERA, Virtex 1000E
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2003/08/05  1.0      djupdal	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package dmkons_package is

  -----------------------------------------------------------------------------
  -- constants

  -- number of bits in instruction memory address bus
  constant IADDR_BUS : integer := 8;                  -- do not change this
  -- number of bits in instruction memory data bus (= instr. word size)
  constant IDATA_BUS : integer := 32;                 -- do not change this
  -- number of bits in databus and registers
  constant DDATA_BUS : integer := 8;                  -- max 32
  -- number of bits in function bus
  constant FUNCT_BUS : integer :=2;

  -- number of bits in status register
  constant STATUS_BUS : integer := 1;

  -- number of words in instruction memory
  constant IMEM_SIZE : integer := 2 ** IADDR_BUS;     -- do not change this
  -- number of bits used for selecting registers from regfile
  constant REG_ADDR_BUS   : integer := 4;             -- do not change this
  -- total number of registers in register file
  constant REGISTERS : integer := 2 ** REG_ADDR_BUS;  -- do not change this

  -- "generic" constants moved here from mem.vhd
  constant MEM_ADDR_BUS : integer := 8;
  constant MEM_DATA_BUS : integer := 32;
  
  -- size of opcode
  constant OPCODE_BUS : integer := 3;
	 
  -----------------------------------------------------------------------------
  -- types

  -- datatype used for an array containing all register values
  type regfile_type is
    array (REGISTERS - 1 downto 0) of std_logic_vector(DDATA_BUS - 1 downto 0);

  -----------------------------------------------------------------------------
  -- components

  -- contains logic to communicate with software over the PCI bus
  -- also generates clock that should be used for cpu core
  component cpucom
    port (
      -- I/O pins on FPGA
      pciBusy        : in    std_logic;
      pciEmpty       : in    std_logic;
      pciRW          : out   std_logic;
      pciEnable      : out   std_logic;
      pciData        : inout std_logic_vector(31 downto 0);
      -- write port on imem
      imem_w_address : out   std_logic_vector(IADDR_BUS - 1 downto 0);
      imem_w_data    : out   std_logic_vector(IDATA_BUS - 1 downto 0);
      imem_w_enable  : out   std_logic;
      -- array of all registers in regfile
      reg_values     : in    regfile_type;
      -- clock source for cpu core
      core_clk       : out   std_logic;
      core_rst       : out   std_logic;
      rst            : in    std_logic;
      clk            : in    std_logic); 
  end component;

  -- memory
  component mem
    generic (
      MEM_ADDR_BUS : integer;
      MEM_DATA_BUS : integer); 
    port (
      address   : in  std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
      data      : out std_logic_vector(MEM_DATA_BUS - 1 downto 0);
      w_address : in  std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
      w_data    : in  std_logic_vector(MEM_DATA_BUS - 1 downto 0);
      w_enable  : in  std_logic;
      core_clk  : in  std_logic);
  end component;

  -- register file
  component regfile
    port (
      -- read port A
      reg_a      : in  std_logic_vector(REG_ADDR_BUS - 1 downto 0);
      data_a     : out std_logic_vector(DDATA_BUS - 1 downto 0);
      -- read port B
      reg_b      : in  std_logic_vector(REG_ADDR_BUS - 1 downto 0);
      data_b     : out std_logic_vector(DDATA_BUS - 1 downto 0);
      -- write port
      reg_d      : in  std_logic_vector(REG_ADDR_BUS - 1 downto 0);
      d_enable   : in  std_logic;
      data_d     : in  std_logic_vector(DDATA_BUS - 1 downto 0);
      -- array with all current register values
      reg_values : out regfile_type;
      --
      rst        : in  std_logic;
      core_clk   : in  std_logic);
  end component;

  -- alu
  component alu
    port (
      alu_funct  : in  std_logic_vector(FUNCT_BUS - 1 downto 0);
      alu_in_a   : in  std_logic_vector(DDATA_BUS - 1 downto 0);
      alu_in_b   : in  std_logic_vector(DDATA_BUS - 1 downto 0);
      alu_out    : out std_logic_vector(DDATA_BUS - 1 downto 0);
      alu_status : out std_logic_vector(STATUS_BUS - 1 downto 0));
  end component;

  -----------------------------------------------------------------------------
  -- global signals for testbench

  signal debug_dll_locked : std_logic;

end dmkons_package;
