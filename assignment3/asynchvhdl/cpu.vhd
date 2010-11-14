library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.dmkons_package.all;

entity cpu is
  port (
    -- imem write port
    imem_w_address : in std_logic_vector(IADDR_BUS - 1 downto 0);
    imem_w_data    : in std_logic_vector(IDATA_BUS - 1 downto 0);
    imem_w_enable  : in std_logic;

    -- register values in regfile
    reg_values : out regfile_type;

    -- clock used for cpu core
    core_clk : in  std_logic;
    -- reset used for cpu core
    core_rst : in  std_logic;
    -- BenERA LEDS
    led      : out std_logic_vector(15 downto 0)
    );
end cpu;

architecture Behavioral of cpu is
  -- Pc connections
  -----------------------------------------------------------------------------
  -- Input address for branches
  signal branch_address     : std_logic_vector(DDATA_BUS - 1 downto 0);
  signal program_pointer    : std_logic_vector(IADDR_BUS - 1 downto 0);
  signal pc_write           : std_logic;
  signal pc_mux_signal      : std_logic;
  -- IMEM connections
  signal instruction_data   : std_logic_vector(IDATA_BUS - 1 downto 0);
  -- IF/ID register connections
  signal set_ifid_valid     : std_logic;
  signal ifid               : if_id;
  -- Register connections
  signal reg_out_a          : std_logic_vector(DDATA_BUS - 1 downto 0);
  signal reg_out_b          : std_logic_vector(DDATA_BUS - 1 downto 0);
  -- ID operand mux connections
  signal id_op_a_mux_signal : std_logic;
  signal id_op_b_mux_signal : std_logic;
  -- ID/EX register connections
  signal idex_input         : id_ex;
  signal idex               : id_ex;
  -- ALU connections
  signal alu_a              : std_logic_vector(DDATA_BUS - 1 downto 0);
  signal alu_b              : std_logic_vector(DDATA_BUS - 1 downto 0);
  signal alu_status_out     : std_logic_vector(STATUS_BUS - 1 downto 0);
  -- Status connection
  signal status             : std_logic_vector(STATUS_BUS - 1 downto 0);
  -- EX/WB register connections
  signal exwb_input         : ex_wb;
  signal exwb               : ex_wb;
  -- Register mux connection
  signal regmux_out         : std_logic_vector(DDATA_BUS - 1 downto 0);
begin
  -- set leds off
  led <= "0000000000000000";

  -------------------------
  -- Direct connections
  -------------------------
  idex_input.rd    <= ifid.rd;
  idex_input.imm   <= ifid.imm;
  idex_input.funct <= ifid.funct;
  exwb_input.rd    <= idex.rd;
  exwb_input.imm   <= idex.imm;
  exwb_input.wb    <= idex.wb;
  branch_address   <= ifid.imm;

  ---------------------------------
  -- Component instantiations
  ---------------------------------
  control_unit : control
    port map (
      -- Inputs
      IF_ID_valid     => ifid.valid,
      IF_ID_opcode    => ifid.opcode,
      IF_ID_Ra        => ifid.ra,
      IF_ID_Rb        => ifid.rb,
      ID_EX_Rd        => idex.rd,
      ID_EX_write_reg => idex.wb.reg_write,
      EX_WB_Rd        => exwb.rd,
      EX_WB_write_reg => exwb.wb.reg_write,
      zf_post_mux     => status(0),

      -- Outputs
      pc_mux          => pc_mux_signal,
      pc_enable       => pc_write,
      set_IF_ID_valid => set_ifid_valid,
      id_op_a_mux     => id_op_a_mux_signal,
      id_op_b_mux     => id_op_b_mux_signal,
      EX              => idex_input.ex,
      WB              => idex_input.wb
      );

  -- Program Counter
  progcounter : pc
    port map (
      pc_in           => branch_address,
      pc_write_enable => pc_write,
      pc_mux_sel      => pc_mux_signal,
      pc_out          => program_pointer,
      core_rst        => core_rst,
      core_clk        => core_clk
      );

  imem : mem
    generic map (
      MEM_ADDR_BUS => IADDR_BUS,
      MEM_DATA_BUS => IDATA_BUS
      )
    port map (
      -- read port
      address   => program_pointer,
      data      => instruction_data,
      w_address => imem_w_address,
      w_data    => imem_w_data,
      w_enable  => imem_w_enable,
      core_clk  => core_clk
      );

  ifidreg : if_id_reg
    port map (
      core_rst  => core_rst,
      core_clk  => core_clk,
      valid     => set_ifid_valid,
      ir        => instruction_data,
      if_id_out => ifid
      );

  registers : regfile port map (
    -- read port A
    reg_a      => ifid.ra,
    data_a     => reg_out_a,
    -- read port B
    reg_b      => ifid.rb,
    data_b     => reg_out_b,
    -- write port
    reg_d      => exwb.rd,
    d_enable   => exwb.wb.reg_write,
    data_d     => regmux_out,
    -- array with all current register values
    reg_values => reg_values,
    rst        => core_rst,
    core_clk   => core_clk
    );

  idopmux : id_operand_mux
    port map (
      op_a_mux   => id_op_a_mux_signal,
      op_b_mux   => id_op_b_mux_signal,
      wb_data    => regmux_out,
      reg_data_a => reg_out_a,
      reg_data_b => reg_out_b,
      op_a       => idex_input.a,
      op_b       => idex_input.b
      );

  idexreg : id_ex_reg
    port map (
      core_rst => core_rst,
      core_clk => core_clk,
      reg_in   => idex_input,
      reg_out  => idex
      );

  exmux : ex_operand_mux
    port map(
      op_a_mux    => idex.ex.alu_a_mux,
      op_b_mux    => idex.ex.alu_b_mux,
      wb_data     => regmux_out,
      idex_data_a => idex.a,
      idex_data_b => idex.b,
      op_a        => alu_a,
      op_b        => alu_b
      );

  alu1 : alu
    port map (
      alu_funct  => idex.funct,
      alu_in_a   => alu_a,
      alu_in_b   => alu_b,
      alu_out    => exwb_input.alu,
      alu_status => alu_status_out
      );

  statusreg : sr
    port map (
      sr_in           => alu_status_out,
      sr_write_enable => idex.ex.status_write,
      sr_out          => status,
      core_rst        => core_rst,
      core_clk        => core_clk
      );

  dmem : mem
    generic map (
      MEM_ADDR_BUS => DADDR_BUS,
      MEM_DATA_BUS => DDATA_BUS
      )
    port map (
      -- Because of read address synchronized, we need imm from ifid.
      address   => ifid.imm,
      data      => exwb_input.mem,
      w_address => idex.imm,
      w_data    => alu_a,
      w_enable  => idex.ex.mem_write,
      core_clk  => core_clk
      );

  exwbreg : ex_wb_reg
    port map(
      core_rst => core_rst,
      core_clk => core_clk,
      reg_in   => exwb_input,
      reg_out  => exwb
      );

  regmux1 : regfile_mux port map (
    selector  => exwb.wb.wb_source,
    immediate => exwb.imm,
    alu_out   => exwb.alu,
    mem_out   => exwb.mem,
    data_d    => regmux_out
    );


end Behavioral;

