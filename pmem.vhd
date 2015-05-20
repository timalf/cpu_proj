--------------------------------------------------------
-- in_memory.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;   
use work.all;

entity in_memory is
port ( 	clock	: 	in std_logic;
		rst		: 	in std_logic;
		XMre		:	in std_logic;
		XMwe		:	in std_logic;
		Xaddress	:	in std_logic_vector(7 downto 0);
		Xdata_in	:	in std_logic_vector(15 downto 0);
		Xdata_out:	out std_logic_vector(15 downto 0)
);
end in_memory;

architecture behv of in_memory is			

  type inram_type is array (0 to 255) of 
        		std_logic_vector(15 downto 0);
  signal tmp_inram: inram_type;

begin
	

							
	write: process(clock, rst, XMre, Xaddress, Xdata_in)
	begin
		if rst='1' then		
			tmp_inram <= 		
					(			
						0 => "0000000000000000",	   	-- mov R0, $0
						1 => "0000000100000001",			-- mov R1, $1
						2 => "0000001000000010",			-- mov R2, $2
						3 => "0000001000000011",			-- mov R3, $3
					
						others => "1111111111111111");
		else
			if (clock'event and clock = '1') then
				if (XMwe ='1' and XMre = '0') then
					tmp_inram(conv_integer(Xaddress)) <= Xdata_in;
				end if;
			end if;
		end if;
	end process;

    read: process(clock, rst, XMwe, Xaddress)
	begin
		if rst='1' then
			Xdata_out <= "1111111111111111";
		else
			if (clock'event and clock = '1') then
				if (XMre ='1' and XMwe ='0') then								 
					Xdata_out <= tmp_inram(conv_integer(Xaddress));
				end if;
			end if;
		end if;
	end process;
end behv;