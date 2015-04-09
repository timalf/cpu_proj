----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:39:33 04/09/2015 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
port (
oper : in STD_LOGIC_VECTOR (5 downto 0);
a : in STD_LOGIC_VECTOR (7 downto 0);
b : in STD_LOGIC_VECTOR (7 downto 0);
res: out STD_LOGIC_VECTOR (7 downto 0);
res2: out STD_LOGIC_VECTOR (15 downto 0);
sf : out STD_LOGIC;
zf : out STD_LOGIC;
cf : out STD_LOGIC;
ovf: out STD_LOGIC
);
end alu;

architecture Behavioral of alu is
begin
process (a,b,oper)
variable temp: STD_LOGIC_VECTOR (8 downto 0);
variable resv: STD_LOGIC_VECTOR (7 downto 0);
variable resv2: STD_LOGIC_VECTOR (15 downto 0);

variable cfv, zfv: STD_LOGIC;
begin
cf <= '0';
ovf <= '0';
zfv := '0';
temp := "000000000";
case oper is
--dodawanie
when "000000" | "000001" | "000010" =>
temp := ('0' & a) + ('0' & b);
resv := temp(7 downto 0);
cfv := temp(8);
ovf <= resv(7) xor a(7) xor b(7) xor cfv;
cf<=cfv;
--dodawanie +1
when "000100" | "000101" | "000110" =>
temp := ('0' & a) + ('0' & b);
resv := temp(7 downto 0);
cfv := temp(8);
ovf <= resv(7) xor a(7) xor b(7) xor cfv;
cf<=cfv;
--inkrementacja
when "001000" =>
temp := ('0' & a) + 1;
resv := temp(7 downto 0);
cfv := temp(8);
ovf <= resv(7) xor a(7) xor b(7) xor cfv;
cf<=cfv;
--dekrementacja
when "001001" =>
temp := ('0' & a) - 1;
resv := temp (7 downto 0);
cfv := temp(8);
ovf <= resv(7) xor a(7) xor b(7) xor cfv;
--odejmowanie
when "001100" | "001101" | "001110"  =>
temp := ('0' & a) - ('0' & b);
resv := temp (7 downto 0);
cfv := temp(8);
ovf <= resv(7) xor a(7) xor b(7) xor cfv;
--mnozenie
when "010000" =>
resv2 := a*b;
when others =>
resv := a;
resv2:= ("00000000" & a);
end case;

for i in 0 to 7 loop
zfv := zfv or resv(i);
end loop;
res <= resv;
zf <= not zfv;
sf <= resv(7);
res2 <= resv2;
end process;

end Behavioral;

