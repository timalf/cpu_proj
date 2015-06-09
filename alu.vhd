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
		FLAGS_out: 	out std_logic_vector(3 downto 0); --cf,zf,sf,ovf
		FLAGS_in: 	in std_logic_vector(3 downto 0) --cf,zf,sf,ovf

		
);
end alu;

architecture behv of alu is
begin

	process (num_A,num_B,ALUs)
	variable temp: STD_LOGIC_VECTOR (8 downto 0);
	variable opA, opB : std_logic_vector (7 downto 0);
	variable temp2: STD_LOGIC_VECTOR (8 downto 0);
	variable resv,resv3: STD_LOGIC_VECTOR (7 downto 0);
	variable resv2: STD_LOGIC_VECTOR (15 downto 0);
	variable do_cmp: STD_LOGIC_VECTOR (7 downto 0);
	variable cfv, zfv, sfv, ovf: STD_LOGIC;

	begin
		zfv := '0';
		cfv := '0';
		sfv := '0';
		ovf := '0';
		temp := "000000000";
		resv3 := "00000000";
		opA := num_A;
		opB := num_B;
	case ALUs is 
	
	
	when "0000" =>
	resv:= opA;
	ALUout <= "0000000000000000" + resv;
	when "0001" =>
	resv:= opB;
	ALUout <= "0000000000000000" + resv;
	--dodawanie	
	when "1011" =>
	temp := ('0' & opA) + ('0' & opB);
	resv := temp(7 downto 0);

	cfv := temp(8);
	ovf := resv(7) xor opA(7) xor opB(7) xor cfv;
	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	zfv := not zfv;
	
	--dodawanie +1
	when "1100" =>
	if FLAGS_in(3) = '1' then
	temp := ('0' & opA) + ('0' & opB) + 1;
	else
	temp := ('0' & opA) + ('0' & opB);
	end if;
	resv := temp(7 downto 0);
	cfv := temp(8);
	ovf := resv(7) xor opA(7) xor opB(7) xor cfv;
	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	zfv := not zfv;
	
	--inkrementacja
	when "0010" =>
	temp := ('0' & opA) + 1;
	resv := temp(7 downto 0);
	cfv := temp(8);
	ovf := resv(7) xor opA(7) xor cfv;
	
	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop; 
	zfv := not zfv;
	
	--dekrementacja
	when "0011" =>
	temp2:= ('1' & opA);
	temp := temp2 - 1;
	resv := temp (7 downto 0);
	cfv := not(temp(8));
	ovf := resv(7) xor opA(7) xor cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	zfv := not zfv;
	
	--odejmowanie
	when "0100" =>
	temp2:= ('1' & opA);
	temp := temp2 - ('0' & opB);
	resv := temp (7 downto 0);
	cfv := not(temp(8));
	ovf := resv(7) xor opA(7) xor opB(7) xor cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	zfv := not zfv;
	
	--odejmowanie -1
	when "0101"  =>
	temp2:= ('1' & opA);
	if FLAGS_in(3) = '1' then
	temp := temp2 - ('0' & opB) -1;
	else 
	temp := temp2 - ('0' & opB);
	end if;

	resv := temp (7 downto 0);
	cfv := not(temp(8));
	ovf := resv(7) xor opA(7) xor opB(7) xor cfv;

	for i in 0 to 7 loop
	zfv := zfv or resv(i);
	end loop;
	zfv := not zfv;
	
--	mnozenie
	when "0110" =>
	resv2 := opA*opB;
	resv := resv2(7 downto 0);
	resv3 := resv2(15 downto 8);
	sfv := resv2(15);
	for i in 0 to 15 loop
	zfv := zfv or resv2(i);
	end loop;

	--and
	when "0111" =>
	resv:=opA and opB;
	--or
	when "1000"  =>
	resv:=opA or opB;
	--xor
	when "1001"  =>
	resv:= opA xor opB;
	--not
	when "1010" =>
	resv:= not opA;
	
	--cmp
	when "1101" =>
	resv:= opA;
	do_cmp:=opA - opB;
	if (opA=opB) then --czy rowne
	cfv:='1';
	zfv:='1';
	sfv:='1';
	ovf:='1';
	elsif (opA /= opB and do_cmp(7)='0') then --czywieksze
	cfv:='1';
	zfv:='0';
	sfv:='0';
	ovf:='0';
	elsif (opA /= opB and do_cmp(7)='1') then --czymniejsze
	cfv:='0';
	zfv:='0';
	sfv:='0';
	ovf:='1';
	end if;	
	when others =>
	end case;
	FLAGS_out(3) <= cfv;
	FLAGS_out(2) <= zfv;
	FLAGS_out(1) <= sfv;
	FLAGS_out(0) <= ovf;
	ALUout <= resv3 & resv;

	end process;
end behv;




