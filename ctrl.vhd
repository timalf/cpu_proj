----------------------------------------------------------------------------
-- controller.vhd
----------------------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity controller is
port(	
	clock:		in std_logic;
	rst:			in std_logic;
	IR_word:		in std_logic_vector(15 downto 0);
	RFs_ctrl:	out std_logic_vector(1 downto 0);
	RFw1a_ctrl:	out std_logic_vector(1 downto 0);
	RFw2a_ctrl:	out std_logic_vector(1 downto 0);
	RFr1a_ctrl:	out std_logic_vector(1 downto 0);
	RFr2a_ctrl:	out std_logic_vector(1 downto 0);
	RFw1e_ctrl:	out std_logic;
	RFw2e_ctrl:	out std_logic;
	RFr1e_ctrl:	out std_logic;
	RFr2e_ctrl:	out std_logic;						 
	ALUs_ctrl:	out std_logic_vector(3 downto 0);	 
	PCinc_ctrl:	out std_logic;
	PCclr_ctrl:	out std_logic;
	PCld_ctrl:	out std_logic;
	PCad_ctrl:	out std_logic_vector(7 downto 0);
	IRld_ctrl:	out std_logic;
	Mre_ctrl:	out std_logic;
	Mwe_ctrl:	out std_logic;
	Mra_ctrl:	out std_logic_vector(7 downto 0);
	XMre_ctrl:	out std_logic;
	XMwe_ctrl:	out std_logic;
	FLwe_ctrl:	out std_logic;
	FLre_ctrl:	out std_logic;
	FLin_ctrl:	in	std_logic_vector(3 downto 0)
);
end controller;

architecture fsm of controller is

  type state_type is (  
			S0,S1,S1a,S1b,S2,S3,S3a,S3b,S3c,S4,S4a,S4b,S5,S5a,S5b, S5c,
			S6,S6a,S6b,S6c,S6d,S7,S7a,S7b,S7c,S7d,S8,S8a,S8b,S8c,S9,S9a,S9b,S9c,S9d,S10,S10a,S10b,S10c,S10d,
			S11,S11a,S11b,S11c,S11d,S12,S12a,S12b,S12c,S12d,S13,S13a,S13b,S13c,S13d,S14,S14a,S14b,S14c,S14d,
			S15,S15a,S15b,S15c,S15d,S16,S16a,S16b,S16c,S16d,S17,S17a,S17b,S17c,S17d,S18,S18a,S18b,S18c,S18d,
			S19,S19a,S19b,S19c,S19d,S20,S20a,S20b,S20c,S20d,S21,S21a,S21b,S21c,S21d,S22,S22a,S22b,S22c,S22d, 
			S23,S23a,S23b,S23c,S23d,S24,S24a,S24b,S24c,S24d,S25,S25a,S25b,S25c,S25d,S26,S26a,S26b,S26c,S26d,
			S27,S27a,S27b,S27c,S27d,S28,S28a,S28b,S28c,S28d,S29,S29a,S29b,S29c,S29d,S30,S30a,S30b,S30c,S30d);
  signal state: state_type;
	
begin

  process(clock, rst, IR_word)
    variable OPCODE: std_logic_vector(15 downto 10);
	
  begin
   if rst='1' then			   
  	PCclr_ctrl <= '1';		  			-- stan poczatkowy cpu
	PCinc_ctrl <= '0';
	PCld_ctrl <= '0';
	IRld_ctrl <= '0';
	RFw1e_ctrl <= '0';
	RFw2e_ctrl <= '0';
	RFr1e_ctrl <= '0';
	RFr2e_ctrl <= '0';
	Mre_ctrl <= '0';
	Mwe_ctrl <= '0';
	FLwe_ctrl <= '0';
	FLre_ctrl <= '0';
	state <= S0;

    elsif (clock'event and clock='1') then
	
	case state is
	    
	  when S0 =>	
			PCclr_ctrl <= '0';			-- rst 	
			state <= S1;	

	  when S1 =>
			FLwe_ctrl <= '0';
			FLre_ctrl <= '0';
			PCinc_ctrl <= '0';		-- pobieranie instrukcji	
			PCld_ctrl <= '0';
			RFw1e_ctrl <= '0';
			RFw2e_ctrl <= '0';
			XMwe_ctrl <= '0';
			XMre_ctrl <= '1';
			IRld_ctrl <= '1';			
			state <= S1a;
	  when S1a => 	
			PCld_ctrl <= '0';
			PCinc_ctrl <= '1';
			state <= S1b;				-- pobrana
	  when S1b => 	
			PCinc_ctrl <= '0';
			XMre_ctrl <= '0';
			IRld_ctrl <= '0';			

			state <= S2;
	  				
	  when S2 =>	
				OPCODE := IR_word(15 downto 10);
				case OPCODE is
			    when "000010" => 	state <= S3;		-- RF[rn] <= mem
			    when "000001" => 	state <= S4;		-- RF[rn] <= RF[rm]
			    when "000000" => 	state <= S5;		-- RF[rn] <= stala
			    when "000100" => 	state <= S6;		-- Rf[rn] <= Rf[rn] + stala
			    when "000011" =>  	state <= S7;		-- mem <= Rf[rn]
			    when "000101" =>		state <= S8;		-- jmp
			    when "000110" =>		state <= S9;		-- Rf[rn] <= Rf[rn] + Rf[rm]
			    when "000111" =>		state <= S10; 		-- adc rf + dir
			    when "001000" => 	state <= S11;		-- adc rf + rf
			    when "001001" => 	state <= S12;		-- sub rf - const				 
				 when "001010" => 	state <= S13;		-- sub rf - rf
				 when "001011" => 	state <= S14;		-- sub rf - const -1
				 when "001100" => 	state <= S15;		-- sub rf - rf -1
				 when "001101" => 	state <= S16;		-- inc
				 when "001110" => 	state <= S17;		-- dec
				 when "001111" => 	state <= S18;		-- mul rf * rf
				 when "010000" => 	state <= S19;		-- anl rf & const
				 when "010001" => 	state <= S20;		-- anl rf & rf
				 when "010010" => 	state <= S21;		-- orl rf | const
				 when "010011" => 	state <= S22;		-- orl rf | rf
				 when "010100" => 	state <= S23;		-- xrl rf xor const
				 when "010101" => 	state <= S24;		-- xrl rf xor rf
				 when "010110" => 	state <= S25;		-- cmp rf const
				 when "010111" => 	state <= S26;		-- cmp rf rf
				 when "011000" => 	state <= S27;		-- je
				 when "011001" => 	state <= S28;		-- jg
				 when "011010" => 	state <= S29;		-- jl
				 when "011011" => 	state <= S30;		-- CPL rf
				 when others 	=> 	state <= S1;
			    end case;
				 
	--------------- RF[rn] <= mem[direct]-------------
	  when S3 =>	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			Mra_ctrl <= IR_word(7 downto 0);
			Mre_ctrl <= '1';
			Mwe_ctrl <= '0';	
			state <= S3a;
	  when S3a => 
	  		RFs_ctrl <= "01";		 
			state <= S3b;
	  when S3b => 
	  		FLwe_ctrl <= '1';
			ALUs_ctrl <= "0001";
			state <= S3c;
		when S3c => 
			RFw1e_ctrl <= '1';
			state <= S1;
	---------- RF[rn] <= RF[rm]--------------------    
	  when S4 =>	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			RFr1a_ctrl <= IR_word(1 downto 0);	
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			state <= S4a;				
	  when S4a => 
			ALUs_ctrl <= "0000";
			state <= S4b;
	  when S4b =>  
			RFw1e_ctrl <= '1';
			state <= S1;
	----------- RF[rn] <= stala----------------	
		when S5 => 
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S5a;
		when S5a =>
			RFs_ctrl <= "00";		 
			state <= S5b;
		when S5b =>
			ALUs_ctrl <= "0001";
			state <= S5c;
		when S5c => 
			RFw1e_ctrl <= '1';
			state <= S1;
		-------------dodawanie RF + const----------------
		when S6 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S6a;
		when S6a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S6b;
		when S6b =>
			ALUs_ctrl <= "1011";
			state <= S6c;
		when S6c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S6d;	
			when S6d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
	------------------- mem <= RF[rn]--------------------		
		when S7 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			Mra_ctrl <= IR_word(7 downto 0);
			state <= S7a;
		when S7a =>
			RFr1e_ctrl <= '1';
			state <= S7b;
		when S7b =>
			ALUs_ctrl <= "0000";
			state <= S7c;
		when S7c => 
			FLwe_ctrl <= '1';
			Mre_ctrl <= '0';
			Mwe_ctrl <= '1';
			state <= S7d;
		when S7d => 
			FLwe_ctrl <= '0';
			Mwe_ctrl <= '0';
			state <= S1;
	------------- to jest skok bez warunkow------------------
		when S8 => 
			PCad_ctrl <= IR_word (7 downto 0);
			state <= S8a;
		when S8a =>
			PCinc_ctrl <= '0';
			PCld_ctrl <= '1';
			state <= S8b;
		when S8b =>
			PCld_ctrl <= '0';	
			state <= S8c;
		when S8c => 
			state <= S1;
	-------------dodawanie RF + RF----------------------		
		when S9 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S9a;
		when S9a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S9b;
		when S9b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "1011";
			state <= S9c;
		when S9c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S9d;	
		when S9d =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
------------dodawanie RF + dir + 1-----------------------			
		when S10 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S10a;
		when S10a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			FLre_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S10b;
		when S10b =>
			ALUs_ctrl <= "1100";
			state <= S10c;
		when S10c => 
			FLre_ctrl <= '0';
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S10d;	
			when S10d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
		----------------dodawanie RF + RF +1------------------
		when S11 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S11a;
		when S11a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';
			RFs_ctrl <= "10";	
			FLre_ctrl <= '1';			
			state <= S11b;
		when S11b =>
			ALUs_ctrl <= "1100";
			state <= S11c;
		when S11c => 
			FLre_ctrl <= '0';
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S11d;	
		when S11d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
			
			-------------odejmowanie RF - const----------------
		when S12 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S12a;
		when S12a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S12b;
		when S12b =>
			ALUs_ctrl <= "0100";
			state <= S12c;
		when S12c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S12d;	
			when S12d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
			
			-------------odejmowanie RF - RF----------------------		
		when S13 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S13a;
		when S13a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S13b;
		when S13b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "0100";
			state <= S13c;
		when S13c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S13d;	
		when S13d =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
			
	------------odejmowanie RF - dir - 1-----------------------			
		when S14 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S14a;
		when S14a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			FLre_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S14b;
		when S14b =>
			ALUs_ctrl <= "0101";
			state <= S14c;
		when S14c => 
			FLre_ctrl <= '0';
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S14d;	
			when S14d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
		----------------odejmowanie RF - RF - 1------------------
		when S15 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S15a;
		when S15a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';
			RFs_ctrl <= "10";	
			FLre_ctrl <= '1';			
			state <= S15b;
		when S15b =>
			ALUs_ctrl <= "0101";
			state <= S15c;
		when S15c => 
			FLre_ctrl <= '0';
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S15d;	
		when S15d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
------------------inkrementacja------------------
		when S16 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S16a;
		when S16a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			state <= S16b;
		when S16b =>
			ALUs_ctrl <= "0010";
			state <= S16c;
		when S16c => 
			RFw1e_ctrl <= '1';
			state <= S16d;	
		when S16d =>
			RFw1e_ctrl <= '0';
			state <= S1;
------------------dekrementacja------------------
		when S17 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S17a;
		when S17a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			state <= S17b;
		when S17b =>
			ALUs_ctrl <= "0011";
			state <= S17c;
		when S17c => 
			RFw1e_ctrl <= '1';
			state <= S17d;	
		when S17d =>
			RFw1e_ctrl <= '0';
			state <= S1;
			
----------------mnozenie rf*rf---------------------
when S18 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			RFw2a_ctrl <= IR_word(1 downto 0);
			state <= S18a;
		when S18a =>
			RFw1e_ctrl <= '0';
			RFw2e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S18b;
		when S18b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "0110";
			state <= S18c;
		when S18c => 
			RFw1e_ctrl <= '1';
			RFw2e_ctrl <= '1';
			state <= S18d;	
		when S18d =>
			RFw1e_ctrl <= '0';
			RFw2e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
-----------------ANL RF, CONST---------------
	when S19 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S19a;
		when S19a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S19b;
		when S19b =>
			ALUs_ctrl <= "0111";
			state <= S19c;
		when S19c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S19d;	
			when S19d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
-----------------ANL RF, RF---------------
		when S20 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S20a;
		when S20a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S20b;
		when S20b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "0111";
			state <= S20c;
		when S20c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S20d;	
		when S20d =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
-----------------ORL RF, CONST---------------
	when S21 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S21a;
		when S21a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S21b;
		when S21b =>
			ALUs_ctrl <= "1000";
			state <= S21c;
		when S21c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S21d;	
			when S21d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
-----------------ORL RF, RF---------------
		when S22 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S22a;
		when S22a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S22b;
		when S22b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "0111";
			state <= S22c;
		when S22c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S22d;	
		when S22d =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
			
-----------------XRL RF, CONST---------------
	when S23 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S23a;
		when S23a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S23b;
		when S23b =>
			ALUs_ctrl <= "1001";
			state <= S23c;
		when S23c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S23d;	
			when S23d =>
			RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
-----------------XRL RF, RF---------------
		when S24 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S24a;
		when S24a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S24b;
		when S24b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "1001";
			state <= S24c;
		when S24c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S24d;	
		when S24d =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
-----------------CMP RF, CONST---------------
	when S25 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	
		--	RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S25a;
		when S25a =>
		--	RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S25b;
		when S25b =>
			ALUs_ctrl <= "1101";
			state <= S25c;
		when S25c => 
			FLwe_ctrl <= '1';
		--	RFw1e_ctrl <= '1';
			state <= S25d;	
			when S25d =>
		--	RFw1e_ctrl <= '0';
			FLwe_ctrl <= '0';
			state <= S1;
-----------------cmp RF, RF---------------
		when S26 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
		--	RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S26a;
		when S26a =>
		--	RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S26b;
		when S26b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "1101";
			state <= S26c;
		when S26c => 
		--	FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S26d;	
		when S26d =>
		--	RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;

------------- to jest skok JE------------------
		when S27 => 
			PCad_ctrl <= IR_word (7 downto 0);
			FLre_ctrl <= '1';
			state <= S27a;
		when S27a =>
		if (FLin_ctrl = "1111") then
			PCinc_ctrl <= '0';
			PCld_ctrl <= '1';
			state <= S27b;
			else
			FLre_ctrl <= '0';
			state <= S1;
			end if;
		when S27b =>
			PCld_ctrl <= '0';	
			state <= S27c;
		when S27c => 
			FLre_ctrl <= '0';
			state <= S1;

------------- to jest skok JG------------------
		when S28 => 
			PCad_ctrl <= IR_word (7 downto 0);
			FLre_ctrl <= '1';
			state <= S28a;
		when S28a =>
		if (FLin_ctrl = "1000") then
			PCinc_ctrl <= '0';
			PCld_ctrl <= '1';
			state <= S28b;
			else
			FLre_ctrl <= '0';
			state <= S1;
			end if;
		when S28b =>
			PCld_ctrl <= '0';	
			state <= S28c;
		when S28c => 
			FLre_ctrl <= '0';
			state <= S1;
			
------------- to jest skok JL------------------
		when S29 => 
			PCad_ctrl <= IR_word (7 downto 0);
			FLre_ctrl <= '1';
			state <= S29a;
		when S29a =>
		if (FLin_ctrl = "0001") then
			PCinc_ctrl <= '0';
			PCld_ctrl <= '1';
			state <= S29b;
			else
			FLre_ctrl <= '0';
			state <= S1;
			end if;
		when S29b =>
			PCld_ctrl <= '0';	
			state <= S29c;
		when S29c => 
			FLre_ctrl <= '0';
			state <= S1;

-----------------CPL RF---------------
		when S30 => 
			RFr1a_ctrl <= IR_word(9 downto 8);
			RFr2a_ctrl <= IR_word(1 downto 0);	
			RFw1a_ctrl <= IR_word(9 downto 8);	
			state <= S30a;
		when S30a =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '1';	
			state <= S30b;
		when S30b =>
			RFs_ctrl <= "10";			
			ALUs_ctrl <= "1010";
			state <= S30c;
		when S30c => 
			FLwe_ctrl <= '1';
			RFw1e_ctrl <= '1';
			state <= S30d;	
		when S30d =>
			RFw1e_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			state <= S1;
	  when others =>

	end case;

    end if;

  end process;

end fsm;