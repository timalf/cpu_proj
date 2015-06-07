--------------------------------------------------------
-- in_memory.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_textio.all;
use std.textio.all;  
use work.all;

entity in_memory is
port ( 	
		clock		: 	in std_logic;								
		rst		: 	in std_logic;
		XMre		:	in std_logic;									--read enable
		XMwe		:	in std_logic;									--write enable
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
	
							
	write: process(clock, rst, XMre, XMwe, Xaddress, Xdata_in)
	FILE f: TEXT;
	constant filename: string:= "Z:\Users\bobek\pwr\git-repo\cpu_proj\instrukcja.txt";
	variable l : LINE;
	variable b : std_logic_vector(15 downto 0);
	variable i : integer:=0;
	begin
		if rst='1' and i=0 then	
			tmp_inram <= (others => "1111111111111111");
			file_open(f,filename,read_mode);
			while((i<=255) and (not endfile(f))) loop
				readline(f,l);
				read(l,b);		
				tmp_inram(i)<= b; 			
				i:=i+1;
			end loop;
			file_close(f);
		else
			if (clock'event and clock = '1') then
				if (XMwe ='1' and XMre = '0') then
					tmp_inram(conv_integer(Xaddress)) <= Xdata_in;
				end if;
			end if;
		end if;
	end process;

    read: process(clock, rst, XMwe, XMwe, Xaddress)
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