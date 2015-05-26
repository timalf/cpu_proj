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
		ALUs:		in std_logic_vector(3 downto 0);
		ALUout:	out std_logic_vector(15 downto 0);
		FLAGS: 	out std_logic_vector(3 downto 0) --cf,zf,sf,ovf
		
);
end alu;

architecture behv of alu is
signal cfv, zfv, sfv, ovf: STD_LOGIC;

begin

	process (num_A,num_B,ALUs)
	variable temp: STD_LOGIC_VECTOR (8 downto 0);
	variable opA, opB : std_logic_vector (7 downto 0);
	variable temp2: STD_LOGIC_VECTOR (8 downto 0);
	variable resv: STD_LOGIC_VECTOR (7 downto 0);
	variable resv2: STD_LOGIC_VECTOR (15 downto 0);
	
	begin
		zfv <= '0';
		cfv <= '0';
		sfv <= '0';
		ovf <= '0';
		temp := "000000000";
		opA := num_A;
		opB := num_B;
	case ALUs is 
	
	
	when "0000" =>
	resv:= num_A;
	ALUout <= "0000000000000000" + resv;
	when "0001" =>
	resv:= num_B;
	ALUout <= "0000000000000000" + resv;
	--dodawanie	
	when "1011" =>
	temp := ('0' & opA) + ('0' & opB);
	resv := temp(7 downto 0);
	ALUout <= "00000000" & resv;

	cfv <= temp(8);
	ovf <= resv(7) xor num_A(7) xor num_B(7) xor cfv;
	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	zfv <= not zfv;
	
	--dodawanie +1
	when "1100" =>
	temp := ('0' & num_A) + ('0' & num_B) +1;
	resv := temp(7 downto 0);
	cfv <= temp(8);
	ovf <= resv(7) xor num_A(7) xor num_B(7) xor cfv;
	for i in 0 to 7 loop
	zfv <= zfv or resv(i);
	end loop;
	ALUout <= '0' & resv;
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
	ALUout <= '0' & resv;
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
	ALUout <= '0' & resv;
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
	ALUout <= '0' & resv;
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
	ALUout <= '0' & resv;
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
	ALUout <= '0' & resv;
	--or
	when "1000"  =>
	resv:=num_A or num_B;
	ALUout <= '0' & resv;
	--xor
	when "1001"  =>
	resv:= num_A xor num_B;
	ALUout <= '0' & resv;
	--not
	when "1010" =>
	resv:= not num_A;
	ALUout <='0' &  resv;		
	
	when others =>
	end case;
	FLAGS(3) <= cfv;
	FLAGS(2) <= zfv;
	FLAGS(1) <= sfv;
	FLAGS(0) <= ovf;
	end process;
end behv;




