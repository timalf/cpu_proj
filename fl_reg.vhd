----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:04:13 05/26/2015 
-- Design Name: 
-- Module Name:    fl_reg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity fl_reg is
port (
	clock	: 	in std_logic; 	
	rst	: 	in std_logic;
	FLwe	: 	in std_logic;
	FLre	: 	in std_logic;
	FLwd	: 	in std_logic_vector(3 downto 0);
	FLrd	: 	out std_logic_vector(3 downto 0)
	);
end fl_reg;

architecture behv of fl_reg is
signal FL_temp: std_logic_vector(3 downto 0);
begin


write: process(clock, rst, FLwe, FLwd)
  begin
    if rst='1' then				-- high active
        FL_temp <= "0000";
    else
	if (clock'event and clock = '1') then
	  if FLwe='1' then
	    FL_temp <= FLwd;
	  end if;
	end if;
    end if;
  end process;						   
	
  read: process(clock, rst, FLre)
  begin
    if rst='1' then
	FL_temp <= "0000";
    else
	if (clock'event and clock = '1') then
	  if FLre='1' then								 
	    Flrd <= FL_temp;
	  end if;
	end if;
    end if;
  end process;

end behv;

