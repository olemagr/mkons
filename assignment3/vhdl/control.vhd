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

end control;

architecture cont of control is
  
begin
-- Set default outputs. Change when applicable
process (IF_ID_valid)
	variable pc_mux_var 				: std_logic;
   variable pc_enable_var			: std_logic;
   variable set_IF_ID_valid_var	: std_logic;
   variable id_op_a_mux_var		: std_logic;
   variable id_op_b_mux_var 		: std_logic;
   variable EX_var 					: EX_control;
   variable WB_var					: WB_control;
begin
	-- Variable default values
   pc_mux_var := '0';
   pc_enable_var := '1';
   set_IF_ID_valid_var := '1';
   id_op_a_mux_var := '0';
   id_op_b_mux_var := '0';
   EX_var := (others =>'0');
   WB_var := ("00",'0');
	
	-- Start logic.
	if IF_ID_valid = '1' then
		
		if IF_ID_opcode = BNZ and zf_post_mux = '0' then
			set_IF_ID_valid_var := '0';
			pc_mux_var := '1';
		end if;
		
		if IF_ID_opcode = ALU_INST then
			WB_var.wb_source := WB_ALU;
			WB_var.reg_write := '1';
			--EX_var.status_mux := '1';
			EX_var.status_write := '1';
		end if;
		
		if IF_ID_opcode = LDI then
			WB_var.wb_source := WB_IMMEDIATE;
			WB_var.reg_write := '1';
		end if;
		
		if IF_ID_opcode = LOAD then
			WB_var.wb_source := WB_MEMORY;
			WB_var.reg_write := '1';
		end if;
		
		if IF_ID_opcode = STORE then
			EX_var.mem_write := '1';
		end if;
		
		-- Check for data hazards, enable writeback if necessary.
		-- Common, as we only have one instruction format.
		if ID_EX_write_reg = '1' then
			if IF_ID_Ra = ID_EX_Rd then
				EX_var.alu_a_mux := '1';
			end if;
			if IF_ID_Rb = ID_EX_Rd then
				EX_var.alu_b_mux := '1';
			end if;
		end if;
		
		if EX_WB_write_reg = '1' then
			if IF_ID_Ra = EX_WB_Rd then
				id_op_a_mux_var := '1';
			end if;
			if IF_ID_Rb = EX_WB_Rd then
				id_op_b_mux_var := '1';
			end if;
		end if;
			
			
	
	
	
	end if;
	-- End logic
	
	-- Assign variables to outputs 
	pc_mux <= pc_mux_var;
	pc_enable <= pc_enable_var;
   set_IF_ID_valid <= set_IF_ID_valid_var;
   id_op_a_mux <= id_op_a_mux_var;
   id_op_b_mux <= id_op_b_mux_var;
   EX <= EX_var;
   WB <= WB_var;
end process;
			
end cont;
