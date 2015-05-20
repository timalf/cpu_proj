--------------------------------------------------------
-- alu.vhd
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
use work.all;

entity alu is
port (	
		num_A: 	in std_logic_vector(7 downto 0);
		num_B: 	in std_logic_vector(7 downto 0);
		ALUs:	in std_logic_vector(3 downto 0);
		ALUout:	out std_logic_vector(7 downto 0);
		--ALUout2:	out std_logic_vector(7 downto 0);
		FLAGS: 	out std_logic_vector(3 downto 0) --cf,zf,sf,ovf
		
);
end alu;

architecture behv of alu is

--signal alu_tmp: std_logic_vector(7 downto 0);
	signal cfv, zfv, sfv, ovf: STD_LOGIC;


begin

	process (num_A,num_B,ALUs)
	variable temp: STD_LOGIC_VECTOR (8 downto 0);
	variable temp2: STD_LOGIC_VECTOR (8 downto 0);
	variable resv: STD_LOGIC_VECTOR (7 downto 0);
	variable resv2: STD_LOGIC_VECTOR (15 downto 0);
	--variable cfv, zfv, sfv, ovf: STD_LOGIC;
	
	begin
		zfv <= '0';
		cfv <= '0';
		sfv <= '0';
		ovf <= '0';
		temp := "000000000";
	case ALUs is 
	
	--dodawanie 
	when "0000" =>
	temp := ('0' & num_A) + ('0' & num_B);
	resv := temp(7 downto 0);
	cfv <= temp(8);
	ovf <= resv(7) xor num_A(7) xor num_b(7) xor cfv;
	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	ALUout <= resv;
	zfv <= not zfv;
	
	--dodawanie +1
	when "0001" =>
	temp := ('0' & num_A) + ('0' & num_B) +1;
	resv := temp(7 downto 0);
	cfv <= temp(8);
	ovf <= resv(7) xor num_A(7) xor num_B(7) xor cfv;
	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	ALUout <= resv;
	zfv <= not zfv;
	
	--inkrementacja
	when "0010" =>
	temp := ('0' & num_A) + 1;
	resv := temp(7 downto 0);
	cfv <= temp(8);
	ovf <= resv(7) xor num_A(7) xor cfv;
	
	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	ALUout <= resv;
	zfv <= not zfv;
	
	--dekrementacja
	when "0011" =>
	temp2:= ('1' & num_A);
	temp := temp2 - 1;
	resv := temp (7 downto 0);
	cfv <= not(temp(8));
	ovf <= resv(7) xor num_A(7) xor cfv;

	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	ALUout <= resv;
	zfv <= not zfv;
	
	--odejmowanie
	when "0100" =>
	temp2:= ('1' & num_A);
	temp := temp2 - ('0' & num_B);
	resv := temp (7 downto 0);
	cfv <= not(temp(8));
	ovf <= resv(7) xor num_A(7) xor num_B(7) xor cfv;

	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	ALUout <= resv;
	zfv <= not zfv;
	
	--odejmowanie -1
	when "0101"  =>
	temp2:= ('1' & num_A);
	temp := temp2 - ('0' & num_B) -1;
	resv := temp (7 downto 0);
	cfv <= not(temp(8));
	ovf <= resv(7) xor num_A(7) xor num_B(7) xor cfv;

	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	ALUout <= resv;
	zfv <= not zfv;
	
	--mnozenie
--	when "0110" =>
--	resv2 := num_A*num_B;
--	sfv <= resv2(15);
--	for i in 0 to 15 loop
--	zfv <= zfv or resv2(i);
--	end loop;
--	ALUout <= resv2(15 downto 8);
--	ALUout2 <= resv2(7 downto 0);
	--and
	when "0111" =>
	resv:=num_A and num_B;
	ALUout <= resv;
	--or
	when "1000"  =>
	resv:=num_A or num_B;
	ALUout <= resv;
	--xor
	when "1001"  =>
	resv:= num_A xor num_B;
	ALUout <= resv;
	--not
	when "1010" =>
	resv:= not num_A;
	ALUout <= resv;		
	
	when others =>
	end case;
	FLAGS(3) <= cfv;
	FLAGS(2) <= zfv;
	FLAGS(1) <= sfv;
	FLAGS(0) <= ovf;
	end process;
end behv;



=======
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
	CLK  : in  std_logic;
	oper : in STD_LOGIC_VECTOR (5 downto 0);
	a : in STD_LOGIC_VECTOR (7 downto 0);
	b : in STD_LOGIC_VECTOR (7 downto 0);
	res: out STD_LOGIC_VECTOR (7 downto 0);
	res2: out STD_LOGIC_VECTOR (15 downto 0);
	sf : out STD_LOGIC;
	zf : out STD_LOGIC;
	cf : out STD_LOGIC;
	ovf : out STD_LOGIC
	);
	end alu;

	architecture Behavioral of alu is
	begin
	process (a,b,oper,CLK)
	variable temp: STD_LOGIC_VECTOR (8 downto 0);
	variable temp2: STD_LOGIC_VECTOR (8 downto 0);
	variable resv: STD_LOGIC_VECTOR (7 downto 0);
	variable resv2: STD_LOGIC_VECTOR (15 downto 0);

	variable cfv, zfv: STD_LOGIC;
	begin
	cf <= '0';
	zfv := '0';
	cfv := '0';
	zf <='0';
	sf <= '0';
	ovf <= '0';
	temp := "000000000";
	if rising_edge(CLK) then
	case oper is 
	--dodawanie 
	when "000000" | "000001" | "000010" =>
	temp := ('0' & a) + ('0' & b);
	resv := temp(7 downto 0);
	cfv := temp(8);
	ovf <= resv(7) xor a(7) xor b(7) xor cfv;
	cf<=cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	res <= resv;
	zf <= not zfv;
	sf <= resv(7);
	--dodawanie +1
	when "000100" | "000101" | "000110" =>
	temp := ('0' & a) + ('0' & b) +1;
	resv := temp(7 downto 0);
	cfv := temp(8);
	ovf <= resv(7) xor a(7) xor b(7) xor cfv;
	cf<=cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	res <= resv;
	zf <= not zfv;
	sf <= resv(7);
	--inkrementacja
	when "001000" =>
	temp := ('0' & a) + 1;
	resv := temp(7 downto 0);
	cfv := temp(8);
	ovf <= resv(7) xor a(7) xor cfv;
	cf<=cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	res <= resv;
	zf <= not zfv;
	sf <= resv(7);
	--dekrementacja
	when "001001" =>
	temp2:= ('1' & a);
	temp := temp2 - 1;
	resv := temp (7 downto 0);
	cfv := not(temp(8));
	ovf <= resv(7) xor a(7) xor cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	res <= resv;
	zf <= not zfv;
	sf <= resv(7);
	--odejmowanie
	when "001100" | "001101" | "001110"  =>
	temp2:= ('1' & a);
	temp := temp2 - ('0' & b);
	resv := temp (7 downto 0);
	cfv := not(temp(8));
	ovf <= resv(7) xor a(7) xor b(7) xor cfv;


	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	res <= resv;
	zf <= not zfv;
	sf <= resv(7);
	--odejmowanie -1
	when "110100" | "110101" | "110110"  =>
	temp2:= ('1' & a);
	temp := temp2 - ('0' & b) -1;
	resv := temp (7 downto 0);
	cfv := not(temp(8));
	ovf <= resv(7) xor a(7) xor b(7) xor cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	res <= resv;
	zf <= not zfv;
	sf <= resv(7);
	--mnozenie
	when "010000" =>
	resv2 := a*b;
	sf <= resv2(15);
	res2<= resv2;
	for i in 0 to 15 loop
	zfv := zfv or resv2(i);
	end loop;
	res2 <= resv2;
	--and
	when "011100" | "011101" | "011110" =>
	resv:=a and b;
	res <= resv;
	--or
	when "100000" | "100001" | "100010" =>
	resv:=a or b;
	res <= resv;
	--xor
	when "100100" | "100101" | "100110" =>
	resv:= a xor b;
	res <= resv;
	--not
	when "101100" =>
	resv:= not a;
	res <= resv;

	when "101000" => --JL
	if (a<b) then
	resv:= "00000001";
	else resv:="00000000";
	end if;
	when "101001" => --JLE
	if (a<=b) then
	resv:= "00000001";
	else resv:="00000000";
	end if;

	when "101010" => --JE
	if (a=b) then
	resv:= "00000001";
	else resv:="00000000";
	end if;

	when "101011" => --JNE
	if (a/=b) then
	resv:= "00000001";
	else resv:="00000000";
	end if;

	when "101101" => --JG
	if (a>b) then
	resv:= "00000001";
	else resv:="00000000";
	end if;

	when "101110" => --JGE
	if (a>=b) then
	resv:= "00000001";
	else resv:="00000000";
	end if;

	when "101111" => --JZ
	if (a="00000000") then
	resv:= "00000001";
	else resv:="00000000";
	end if;

	when "110000" => --JNZ
	if (a/="00000000") then
	resv:= "00000001";
	else resv:="00000000";
	end if;

	when others =>
	resv := a;
	resv2:= ("00000000" & a);
	end case;

	--for i in 0 to 7 loop
	--zfv := zfv or resv(i);
	--end loop;
	res <= resv;

	--zf <= not zfv;
	--cf <= cfv;
	--sf <= resv(7);
	--res2 <= resv2;
	end if;
	end process;

	end Behavioral;
>>>>>>> origin/master

