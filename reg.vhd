-------------------------------------------------------------
-- reg_file.vhd
-------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;   
use work.all;

entity reg_file is
port ( 	
	clock	: 	in std_logic; 	
	rst	: 	in std_logic;
	RFw1e	: 	in std_logic;
	RFw2e	: 	in std_logic;
	RFr1e	: 	in std_logic;
	RFr2e	: 	in std_logic;	
	RFw1a	: 	in std_logic_vector(1 downto 0);
	RFw2a	: 	in std_logic_vector(1 downto 0); 	
	RFr1a	: 	in std_logic_vector(1 downto 0);
	RFr2a	: 	in std_logic_vector(1 downto 0);
	RFw1	: 	in std_logic_vector(7 downto 0);
	RFw2	: 	in std_logic_vector(7 downto 0);
	RFr1	: 	out std_logic_vector(7 downto 0);
	RFr2	:	out std_logic_vector(7 downto 0)
);
end reg_file;

architecture behv of reg_file is			

  type rf_type is array (0 to 3) of 
        std_logic_vector(7 downto 0);
  signal tmp_rf: rf_type;

begin

  write: process(clock, rst, RFw1a, RFw1e, RFw1, RFw2a, RFw2e,RFw2)
  begin
    if rst='1' then				-- high active
        tmp_rf <= (tmp_rf'range => "00000000");
    else
	if (clock'event and clock = '1') then
	  if RFw1e='1' then
	    tmp_rf(conv_integer(RFw1a)) <= RFw1;
	  end if;
	  if RFw2e='1' then
	    tmp_rf(conv_integer(RFw2a)) <= RFw2;
	  end if;
	end if;
    end if;
  end process;		
 
	
  read1: process(clock, rst, RFr1e, RFr1a)
  begin
    if rst='1' then
	RFr1 <= "00000000";
    else
	if (clock'event and clock = '1') then
	  if RFr1e='1' then								 
	    RFr1 <= tmp_rf(conv_integer(RFr1a));
	  end if;
	end if;
    end if;
  end process;
	
  read2: process(clock, rst, RFr2e, RFr2a)
  begin
    if rst='1' then
	RFr2<= "00000000";
    else
	if (clock'event and clock = '1') then
	  if RFr2e='1' then								 
	    RFr2 <= tmp_rf(conv_integer(RFr2a));
	  end if;
	end if;
    end if;
  end process;
	
end behv;











