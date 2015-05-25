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
	RFwa_ctrl:	out std_logic_vector(1 downto 0);
	RFr1a_ctrl:	out std_logic_vector(1 downto 0);
	RFr2a_ctrl:	out std_logic_vector(1 downto 0);
	RFwe_ctrl:	out std_logic;
	RFr1e_ctrl:	out std_logic;
	RFr2e_ctrl:	out std_logic;						 
	ALUs_ctrl:	out std_logic_vector(3 downto 0);	 
	PCinc_ctrl:	out std_logic;
	PCclr_ctrl:	out std_logic;
	PCld_ctrl:	out std_logic;
	IRld_ctrl:	out std_logic;
	Mre_ctrl:	out std_logic;
	Mwe_ctrl:	out std_logic;
	Mra_ctrl:	out std_logic_vector(7 downto 0);
	XMre_ctrl:	out std_logic;
	XMwe_ctrl:	out std_logic
);
end controller;

architecture fsm of controller is

  type state_type is (  S0,S1,S1a,S1b,S2,S3,S3a,S3b,S3c,S4,S4a,S4b,S5,S5a,S5b, S5c,
			S6,S6a,S6b,S6c,S6d,S7,S7a,S7b,S7c,S8,S8a,S8b,S9,S9a,S9b,S10,S11,S11a);
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
	RFwe_ctrl <= '0';
	RFr1e_ctrl <= '0';
	RFr2e_ctrl <= '0';
	Mre_ctrl <= '0';
	Mwe_ctrl <= '0';					
	state <= S0;

    elsif (clock'event and clock='1') then
	
	case state is
	    
	  when S0 =>	
			PCclr_ctrl <= '0';			-- rst 	
			state <= S1;	

	  when S1 =>	
			PCinc_ctrl <= '0';		-- pobieranie instrukcji	
			PCld_ctrl <= '0';
			RFwe_ctrl <= '0';
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
			    when "000100" => 	state <= S6;
			    when "000011" =>  	state <= S7;
			    when "010100" =>		state <= S8;
			    when "011000" =>		state <= S9;
			    when "011100" =>		state <= S10; 
			    when "100000" => 	state <= S11;
			    when others 	=> 	state <= S1;
			    end case;
					
	  when S3 =>	
			RFwa_ctrl <= IR_word(9 downto 8);	-- RF[rn] <= mem[direct]
			Mra_ctrl <= IR_word(7 downto 0);
			Mre_ctrl <= '1';
			Mwe_ctrl <= '0';	
			state <= S3a;
	  when S3a => 
	  		RFs_ctrl <= "01";		 
			state <= S3b;
	  when S3b => 
			ALUs_ctrl <= "0001";
			state <= S3c;
		when S3c => 
			RFwe_ctrl <= '1';
			state <= S1;
	    
	  when S4 =>	
			RFwa_ctrl <= IR_word(9 downto 8);	-- RF[rn] <= RF[rm]
			RFr1a_ctrl <= IR_word(1 downto 0);	
			RFwe_ctrl <= '0';
			RFr1e_ctrl <= '1';
			state <= S4a;				
	  when S4a => 
			ALUs_ctrl <= "0000";
			state <= S4b;
	  when S4b =>   
			RFwe_ctrl <= '1';
			state <= S1;
		
		when S5 => 
			RFwa_ctrl <= IR_word(9 downto 8);	-- RF[rn] <= stala
			state <= S5a;
		when S5a =>
			RFs_ctrl <= "00";		 
			state <= S5b;
		when S5b =>
		ALUs_ctrl <= "0001";
			state <= S5c;
		when S5c => 
			RFwe_ctrl <= '1';
			state <= S1;
		------------------------	
		when S6 => --dodawanie RF + dir
			RFr1a_ctrl <= IR_word(9 downto 8);	
			RFwa_ctrl <= IR_word(9 downto 8);	
			state <= S6a;
		when S6a =>
			RFwe_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFs_ctrl <= "00";		 
			state <= S6b;
		when S6b =>
		ALUs_ctrl <= "1011";
			state <= S6c;
		when S6c => 
			RFwe_ctrl <= '1';
			state <= S6d;	
			when S6d =>
			RFwe_ctrl <= '0';
			state <= S1;
		when S7 => 
			RFr1a_ctrl <= IR_word(9 downto 8);	-- mem <= RF[rn]
			Mra_ctrl <= IR_word(7 downto 0);
			state <= S7a;
		when S7a =>
			RFr1e_ctrl <= '1';
			state <= S7b;
		when S7b =>
		ALUs_ctrl <= "0000";
			state <= S7c;
		when S7c => 
			Mre_ctrl <= '0';
			Mwe_ctrl <= '1';
			state <= S1;
	  when others =>

	end case;

    end if;

  end process;

end fsm;