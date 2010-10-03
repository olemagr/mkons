library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;
use work.control_const.all;

entity ctrl is
  
  port (
      -- control unit input
      opcode : in std_logic_vector(OPCODE_BUS - 1 downto 0);
      sr     : in std_logic_vector(STATUS_BUS - 1 downto 0);

      -- register values in regfile
      pc_mux_select : out std_logic;
      pc_write_enable : out std_logic;

      regfile_mux_select : out std_logic;
		regfile_write_enable : out std_logic;
		sr_write_enable : out std_logic;

      -- clock used for cpu core
      core_clk : in std_logic;	
      -- reset used for cpu core
      core_rst : in std_logic);
end ctrl;

architecture ctrl_arch of ctrl is

	-- current state: 0 for fetch, 1 for execute
	-- start with fetching first instruction
	signal state : std_logic := '0';

begin

	process(core_clk, core_rst, opcode, sr, state) is	
	begin
		if core_rst='0' then
			state <= '0';
		elsif rising_edge (core_clk) then
			-- change state
			state <= not state;
		end if;
		
		
		
		
		
		if state = '1' then
			case opcode is
			
				-- alu instruction
				when ALU_INST =>
					-- write alu_out to register
					regfile_mux_select <= '0';
					regfile_write_enable <= '1';
					-- set status register
					sr_write_enable <= '1';
							
					-- set next instruction
					pc_mux_select <= '0';
				
				-- branch if not zero
				when BNZ =>
					-- if zero flag is 0 then branch to instruction specified by immediate signal
					if sr = "0" then
						-- select and write immediate signal to pc
						pc_mux_select <= '1';
					else
						-- go to next instruction
						pc_mux_select <= '0';
					end if;
					regfile_mux_select <= '0';
					regfile_write_enable <= '0';
					sr_write_enable <= '0';
					-- load immediate
					when LDI =>
					-- select and write the immediate signal to regfile
					regfile_mux_select <= '1';
					regfile_write_enable <= '1';
					sr_write_enable <= '0';
					pc_mux_select <= '0';
						
				when others =>
					regfile_mux_select <= '0';
					regfile_write_enable <= '0';
					sr_write_enable <= '0';
					pc_mux_select <= '0';
					
			end case;
		
			-- write to pc register
			pc_write_enable <= '1';
			
			-- fetch next instruction
		else
			
			-- do nothing
			pc_write_enable <= '0';
			pc_mux_select <= '0';
			regfile_write_enable <= '0';
			sr_write_enable <= '0';
			regfile_mux_select <= '0';
			
				
		end if;
			
	
--	pc_mux_select <= var_pc_mux_select;
--	pc_write_enable <= var_pc_write_enable;
--	regfile_mux_select <= var_regfile_mux_select;
--	regfile_write_enable <= var_regfile_write_enable;
--	sr_write_enable <= var_sr_write_enable;
		
	end process;

end ctrl_arch;
