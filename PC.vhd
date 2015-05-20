--------------------------------------------------------
-- PC.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
use work.all;

entity PC is
port(	
		--clock:	in std_logic;
		PCld:		in std_logic;
		PCinc:	in std_logic;
		PCclr:	in std_logic;
		PCin:		in std_logic_vector(7 downto 0);
		PCout:	out std_logic_vector(7 downto 0)
);
end PC;

architecture behv of PC is

signal tmp_PC: std_logic_vector(7 downto 0);

begin				
	process(PCclr, PCinc, PCld, PCin)
	begin
	--if (rising_edge(clock)) then
			if PCclr='1' then
				tmp_PC <= "00000000";
			--elsif (PCld'event and PCld = '1') then
			elsif PCld = '1' and PCinc='0' then	
				tmp_PC <= PCin;
			--elsif (PCinc'event and PCinc = '1') then
			elsif PCinc = '1' and PCld = '0' then
				tmp_PC <= tmp_PC + 1;
			end if;
	--		end if;
	end process;

	PCout <= tmp_PC;

end behv;

