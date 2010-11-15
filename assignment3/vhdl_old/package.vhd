-------------------------------------------------------------------------------
-- Title      : package
-- Project    : dmkons cpu
-------------------------------------------------------------------------------
-- File       : package.vhd
-- Author     : DM
-- Company    : 
-- Last update: 2010-11-06
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
  
  -- number of bits in data memory address bus
  constant DADDR_BUS : integer := 8;                  -- do not change this
  -- number of bits in databus and registers
  constant DDATA_BUS : integer := 8;                  -- max 32
  
  -- total number of bits in funct field
  constant FUNCT_BUS : integer := 4 ;
  -- total number of bits in status field
  constant STATUS_BUS : integer := 1 ;
  -- total number of bits in opcode field
  constant OPCODE_BUS : integer := 3 ;

  -- number of words in instruction memory
  constant IMEM_SIZE : integer := 2 ** IADDR_BUS;     -- do not change this
  -- number of words in data memory
  constant DMEM_SIZE : integer := 2 ** IADDR_BUS;     -- do not change this
  
  -- number of bits used for selecting registers from regfile
  constant REG_ADDR_BUS   : integer := 4;             -- do not change this
  -- total number of registers in register file
  constant REGISTERS : integer := 2 ** REG_ADDR_BUS;  -- do not change this
  
  -- Instructions
  subtype op_type is std_logic_vector(OPCODE_BUS-1 downto 0);
  constant ALU_INST 		: op_type := "001";
  constant BNZ				: op_type := "011";
  constant LDI				: op_type := "010";
  constant LOAD			: op_type := "110";
  constant STORE 			: op_type := "100";
  -- Alu functions
  subtype alu_funct is std_logic_vector(funct_bus -1 downto 0);
  constant ALU_MOVE		: alu_funct := "0000";
  constant ALU_AND		: alu_funct := "0001";
  constant ALU_ADD		: alu_funct := "0111";

  -----------------------------------------------------------------------------
  -- types

  type if_id is
    record
		valid	 : std_logic;
		opcode : op_type;
		rd     : std_logic_vector( REG_ADDR_BUS - 1 downto 0 );
		imm    : std_logic_vector( DDATA_BUS - 1 downto 0 );
		ra     : std_logic_vector( REG_ADDR_BUS - 1 downto 0 );
		rb     : std_logic_vector( REG_ADDR_BUS - 1 downto 0 );
		funct  : std_logic_vector( FUNCT_BUS - 1 downto 0 );
    end record;

  type ex_control is
  record
    mem_write   :	std_logic;
    alu_a_mux   :       std_logic;
    alu_b_mux 	:	std_logic;
    --status_mux  :       std_logic;
    status_write:	std_logic;
  end record;

  subtype wb_mux_type is std_logic_vector(1 downto 0);

  constant WB_IMMEDIATE : wb_mux_type := "00" ;
  constant WB_ALU       : wb_mux_type := "01" ;
  constant WB_MEMORY    : wb_mux_type := "11" ;

  type wb_control is
  record
    wb_source   :	wb_mux_type;
    reg_write 	:	std_logic;
  end record;

  
  type id_ex is
  record
    wb          :	wb_control;
    ex	       	:	ex_control;
    rd		:	std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    imm	        :	std_logic_vector(DDATA_BUS - 1 downto 0);
    a		:	std_logic_vector(DDATA_BUS - 1 downto 0);
    b	        :	std_logic_vector(DDATA_BUS - 1 downto 0);
    funct       : 	std_logic_vector(FUNCT_BUS - 1 downto 0);
  end record;

  type ex_wb is
  record
    wb          :	wb_control;
    rd		:	std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    imm	        :	std_logic_vector(DDATA_BUS - 1 downto 0);
    alu		:	std_logic_vector(DDATA_BUS - 1 downto 0);
    mem	        :	std_logic_vector(DDATA_BUS - 1 downto 0);
  end record;



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
  
  component alu

  port (
    alu_funct : in std_logic_vector(FUNCT_BUS - 1 downto 0);
    alu_in_a  : in std_logic_vector(DDATA_BUS - 1 downto 0);
    alu_in_b  : in std_logic_vector(DDATA_BUS - 1 downto 0);

    alu_out    : out std_logic_vector(DDATA_BUS - 1 downto 0);
    alu_status : out std_logic_vector(STATUS_BUS - 1 downto 0));

end component alu;

component control
  
  port (
    -- Inputs
    IF_ID_valid         : in    std_logic;
    IF_ID_opcode        : in    op_type;
    IF_ID_Ra            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    IF_ID_Rb            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    ID_EX_Rd            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    ID_EX_write_reg     : in    std_logic;
    EX_WB_Rd            : in    std_logic_vector(REG_ADDR_BUS - 1 downto 0);
    EX_WB_write_reg     : in    std_logic;
    zf_post_mux         : in    std_logic;

    -- Outputs
    pc_mux              : out   std_logic;
	 pc_enable				: out   std_logic;
    set_IF_ID_valid     : out   std_logic;
    id_op_a_mux         : out   std_logic;
    id_op_b_mux         : out   std_logic;
    EX                  : out   EX_control;
    WB                  : out   WB_control
    
    
);

end component control;

component ex_operand_mux
   port(
      op_a_mux      : in std_logic;
      op_b_mux      : in std_logic;
      wb_data       : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      idex_data_a    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      idex_data_b    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_a          : out std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_b          : out std_logic_vector(DDATA_BUS - 1 downto 0)
	);
end component ex_operand_mux;

component ex_wb_reg
   port(
      core_rst      : in std_logic;
      core_clk      : in std_logic;
      reg_in        : in ex_wb;
      reg_out       : out ex_wb
	);
end component ex_wb_reg;

component id_ex_reg 
   port(
      core_rst      : in std_logic;
      core_clk      : in std_logic;
      reg_in        : in id_ex;
      reg_out       : out id_ex
	);
end component id_ex_reg;

component id_operand_mux 
   port(
      op_a_mux      : in std_logic;
      op_b_mux      : in std_logic;
      wb_data       : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      reg_data_a    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      reg_data_b    : in std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_a          : out std_logic_vector(DDATA_BUS - 1 downto 0); 
      op_b          : out std_logic_vector(DDATA_BUS - 1 downto 0)
	);
end component id_operand_mux;

component if_id_reg 

   port(
      core_rst      : in std_logic;
      core_clk      : in std_logic;
      valid			  : in std_logic;
		ir            : in std_logic_vector( IDATA_BUS - 1 downto 0 );
		if_id_out     : out if_id
	);

end component if_id_reg;

component pc 
  
  port (
    -- PC input
    pc_in           	: in std_logic_vector(IADDR_BUS - 1 downto 0);
    pc_write_enable 	: in std_logic;
    pc_mux_sel 	        : in std_logic;
    -- PC output to memory
    pc_out          	: out std_logic_vector(IADDR_BUS - 1 downto 0);
    -- Global clock and reset
    core_rst      		: in std_logic;
    core_clk        	: in std_logic);

end component pc;

component regfile_mux 
  Port ( selector : in  wb_mux_type;
         immediate : in  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0);
         alu_out : in  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0);
			mem_out : in  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0);
         data_d : out  STD_LOGIC_VECTOR(DDATA_BUS - 1 downto 0));
end component regfile_mux;

component sr 
  Port ( 
    -- SR input
    sr_in           : in std_logic_vector(STATUS_BUS - 1 downto 0);
    sr_write_enable : in std_logic;
    -- SR output
    sr_out          : out std_logic_vector(STATUS_BUS - 1 downto 0);
    -- Global clock and reset
    core_rst        : in std_logic;
    core_clk			 : in std_logic);
end component sr;

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

  -----------------------------------------------------------------------------
  -- global signals for testbench

  signal debug_dll_locked : std_logic;

end dmkons_package;
