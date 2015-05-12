----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:44:12 05/09/2015 
-- Design Name: 
-- Module Name:    ram - Behavioral 
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

entity ram is
port (Clk : in std_logic;
        address : in integer;
        MemWrite : in std_logic;
        DataIn : in std_logic_vector(7 downto 0);
        DataOut : out std_logic_vector(7 downto 0)
     );
end ram;

architecture Behavioral of ram is

type rammodule is array (0 to 255) of std_logic_vector(7 downto 0);
signal ram : rammodule := (others => (others => '0'));

begin

--odczyt i zapis
PROCESS(Clk)
BEGIN
    if(rising_edge(Clk)) then
        if(MemWrite='1') then
            ram(address) <= DataIn;
        end if;
        DataOut <= ram(address);
    end if; 
END PROCESS;

end Behavioral;

