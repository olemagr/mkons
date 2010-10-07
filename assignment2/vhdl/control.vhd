library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;
use work.control_const.all;

entity ctrl is
  
  port (
      -- Control unit input
      opcode : in std_logic_vector(OPCODE_BUS - 1 downto 0);
      sr     : in std_logic_vector(STATUS_BUS - 1 downto 0);

      -- Reggister control signals
      pc_mux_select : out std_logic;
      pc_write_enable : out std_logic;

      regfile_mux_select : out std_logic;
      regfile_write_enable : out std_logic;
      sr_write_enable : out std_logic;

      -- Clock used for cpu core
      core_clk : in std_logic;	
      -- Reset used for cpu core
      core_rst : in std_logic);
end ctrl;

architecture ctrl_arch of ctrl is

	type state_type is (FETCH_STATE, EXECUTE_STATE);
	-- Keep state in register
	signal state : state_type; 
   
begin
        -- Change state on rising edge
	STATE_SELECT : process(core_clk, core_rst) is	
	begin
		if core_rst='0' then
			state <= FETCH_STATE;
		elsif rising_edge (core_clk) then
			-- Change state
			if state = FETCH_STATE then
				state <= EXECUTE_STATE;
			else	
				state <= FETCH_STATE;
			end if;
		end if;
	end process;

	-- Output is combinatorial
	OUTPUT_SELECT : process(opcode, sr, state) is	
	begin
		if state = execute_state then
			case opcode is
			
				-- ALU instruction
				when ALU_INST =>
					-- Write alu_out to register
					regfile_mux_select <= '0';
					regfile_write_enable <= '1';
					-- Set status register
					sr_write_enable <= '1';
							
					-- Set pc to increment
					pc_mux_select <= '0';
				
				-- Branch if not zero
				when BNZ =>
					-- If zero flag is 0 
					if sr = "0" then
						-- Select and write immediate signal to pc
						pc_mux_select <= '1';
					else
						-- Else set pc to increment to next instruction
						pc_mux_select <= '0';
					end if;
                                        -- Reg is not written, so set mux to
                                        -- don't care
					regfile_mux_select <= '-';
					regfile_write_enable <= '0';
					sr_write_enable <= '0';
					-- Load immediate
					when LDI =>
					-- Select and write the immediate signal to regfile
					regfile_mux_select <= '1';
					regfile_write_enable <= '1';
					sr_write_enable <= '0';
					pc_mux_select <= '0';
						
				when others =>
                                        -- Set to don't care for other inputs
                                        regfile_mux_select <= '-';
					regfile_write_enable <= '-';
					sr_write_enable <= '-';
					pc_mux_select <= '-';
					
			end case;
		
			-- Write to pc register in all cases
			pc_write_enable <= '1';
			
		else -- State = FETCH_STATE
		
			pc_write_enable <= '0';
			pc_mux_select <= '0';
			regfile_write_enable <= '0';
			sr_write_enable <= '0';
			regfile_mux_select <= '0';
			
		end if;
	end process;
end ctrl_arch;
