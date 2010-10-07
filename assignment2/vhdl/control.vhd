-------------------------------------------------------------------------------
--
-- Control Unit
-- 
-- TDT4255 - Assignment 2 
--
-- Knut Halvor Skrede
-- Ole Magnus Ruud
--
-- Simple state machine controlling the cpu. State is kept in register and 
-- switched each cycle, while all other logic is combinatorial.
--
-------------------------------------------------------------------------------

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

      -- Program counter control signals
      pc_mux_select : out std_logic;
      pc_write_enable : out std_logic;
		
		-- Register control signals
      regfile_mux_select : out std_logic;
		regfile_write_enable : out std_logic;
		
		-- Status register enable signal
		sr_write_enable : out std_logic;

      -- clock used for cpu core
      core_clk : in std_logic;	
      -- reset used for cpu core
      core_rst : in std_logic);
end ctrl;

architecture ctrl_arch of ctrl is

	type state_type is (FETCH_STATE, EXECUTE_STATE);
	-- Keep state in register
	signal state : state_type; 
   
begin
	
	STATE_SELECT : process(core_clk, core_rst) is	
	begin
		-- Start in fetch state after reset.
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
			
			-- Pc register altered in all execute cases
			pc_write_enable <= '1';
			
			-- Set control signals based on opcode and status register
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
					-- if zero flag is 0 
					if sr = "0" then
						-- select and write immediate signal to pc
						pc_mux_select <= '1';
					else
						-- else set pc to increment to next instruction
						pc_mux_select <= '0';
					end if;
					-- Registers not written, so mux is don't care
					regfile_mux_select <= '-';
					regfile_write_enable <= '0';
					sr_write_enable <= '0';
					
				-- Load immediate
				when LDI =>
					-- select and write the immediate signal to regfile
					regfile_mux_select <= '1';
					regfile_write_enable <= '1';
					sr_write_enable <= '0';
					pc_mux_select <= '0';
						
				when others =>
					-- Set control signals to don't care when invalid input
					regfile_mux_select <= '-';
					regfile_write_enable <= '-';
					sr_write_enable <= '-';
					pc_mux_select <= '-';
					
			end case;
		
			
			
		else -- State = fetch_state
		
			-- Disable all writes in fetch state. Muxers set to don't care
			pc_mux_select <= '-';		
			pc_write_enable <= '0';		
			regfile_mux_select <= '-';	
			regfile_write_enable <= '0';
			sr_write_enable <= '0';
			
		end if;
	end process;
end ctrl_arch;
