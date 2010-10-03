
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.dmkons_package.all;

--------------------------------
-- Register/counter for pc
--------------------------------

entity pc is
  
  port (
      -- pc input
      pc_in           	: in std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
      pc_write_enable 	: in std_logic;
		pc_mux_sel 			: in std_logic;
		-- pc output
		pc_out          	: out std_logic_vector(MEM_ADDR_BUS - 1 downto 0);
		--
      core_rst      		: in std_logic;
      core_clk        	: in std_logic);

end pc;

architecture pc_arch of pc is

   signal pc : std_logic_vector(MEM_ADDR_BUS - 1 downto 0);

begin

	process (core_rst, core_clk)
	begin
	
	   if core_rst = '0' then
         pc <= (others => '0');

      elsif rising_edge (core_clk) then
			if pc_write_enable = '1' then
				if pc_mux_sel = '1' then
					pc <= pc_in;
				else
					pc <= std_logic_vector(unsigned(pc)+1);
				end if;
			end if;
		end if;
	end process;
	
	pc_out <= pc;

end pc_arch;
