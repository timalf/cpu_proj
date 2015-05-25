--------------------------------------------------------
-- mux2.vhd
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
port( 	
		imm_in: 	in std_logic_vector(7 downto 0);				
		mem_in: 	in std_logic_vector(7 downto 0);	  
		reg_in:	in std_logic_vector(7 downto 0);
		mux_s :	in std_logic_vector(1 downto 0);
		mux_ou: 	out std_logic_vector(7 downto 0)
	);
end mux2;

architecture behv of mux2 is
begin
	process(imm_in, mem_in, reg_in, mux_s)
    begin
        case mux_s is
            when "00" =>		mux_ou <= imm_in;
            when "01" =>    	mux_ou <= mem_in;
				when "10" =>		mux_ou <= reg_in;
            when others =>  
        end case;
    end process;
end behv;

