--------------------------------------------------------
-- memory.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;   
use work.all;

entity memory is
port ( 	
		clock	: 	in std_logic;
		rst		: 	in std_logic;
		Mre		:	in std_logic;	--read enable
		Mwe		:	in std_logic;	--write enable
		address	:	in std_logic_vector(7 downto 0);
		data_in	:	in std_logic_vector(7 downto 0);
		data_out:	out std_logic_vector(7 downto 0)
);
end memory;

architecture behv of memory is			

  type ram_type is array (0 to 255) of 
        		std_logic_vector(7 downto 0);
  signal tmp_ram: ram_type;

begin					
	write: process(clock, rst, Mre, Mwe, address, data_in)
	begin
		if rst='1' then		
			tmp_ram <= 
						(			
						others => "00000000");
		else
			if (clock'event and clock = '1') then
				if (Mwe ='1' and Mre = '0') then
					tmp_ram(conv_integer(address)) <= data_in;
				end if;
			end if;
		end if;
	end process;

    read: process(clock, rst, Mwe, Mre, address)
	begin
		if rst='1' then
			data_out <= "00000000";
		else
			if (clock'event and clock = '1') then
				if (Mre ='1' and Mwe ='0') then								 
					data_out <= tmp_ram(conv_integer(address));
				end if;
			end if;
		end if;
	end process;
end behv;