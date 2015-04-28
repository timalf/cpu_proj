----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:58:10 04/27/2015 
-- Design Name: 
-- Module Name:    reg - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; 
use work.typy.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
port(
  IO: in rejIO; 
  --regnumb: in std_logic_vector (3 downto 0);
  input: in rejdane;
  output: out rejdane
  );
end reg;
 
architecture Behavioral of reg is
  type regmod is array(0 to 3) of std_logic_vector(7 downto 0);
  signal rejestry: regmod;

begin
   regs: for i in 0 to 3 generate
    process(IO, input)
    begin
        if(IO(i) = '1') then
          rejestry(i) <= input(i);
			 else
			 output(i) <= rejestry(i);
        end if;
    end process;
   -- output(i) <= rejestry(i) when IO(i)='0' else input(i);
  end generate regs;
end Behavioral;
