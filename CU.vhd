------------------------------------------------------------------------
-- ctrl_unit.vhd
------------------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;

entity CU is
port(	
	clock_cu		:	in 	std_logic;
	rst_cu		:	in 	std_logic;
	Xmdata_out	: 	in 	std_logic_vector(15 downto 0);
	maddr_in		:	out 	std_logic_vector(7 downto 0);		  
	Xmaddr_in	:	out 	std_logic_vector(7 downto 0);		  
	immdata		:	out 	std_logic_vector(7 downto 0);
	RFs_cu		:	out	std_logic_vector(1 downto 0);
	RFw1a_cu		:	out	std_logic_vector(1 downto 0);
	RFw2a_cu		:	out	std_logic_vector(1 downto 0);
	RFr1a_cu		:	out	std_logic_vector(1 downto 0);
	RFr2a_cu		:	out	std_logic_vector(1 downto 0);
	RFw1e_cu		:	out	std_logic;
	RFw2e_cu		:	out	std_logic;
	RFr1e_cu:		out	std_logic;
	RFr2e_cu:		out	std_logic;
	ALUs_cu:			out	std_logic_vector(3 downto 0);	
	Mre_cu:			out 	std_logic;
	Mwe_cu:			out 	std_logic;
	Mra_cu:			out	std_logic_vector(7 downto 0);	
	XMre_cu:			out 	std_logic;
	XMwe_cu:			out 	std_logic;
	FLwe_cu:			out 	std_logic;
	FLre_cu:			out 	std_logic;
	FLin_cu:			in		std_logic_vector(3 downto 0)

);
end CU;

architecture struct of CU is

component controller is
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
	PCad_ctrl: 	out std_logic_vector(7 downto 0);
	IRld_ctrl:	out std_logic;
	Mre_ctrl:	out std_logic;
	Mwe_ctrl:	out std_logic;
	Mra_ctrl:	out std_logic_vector(7 downto 0);
	XMre_ctrl:	out std_logic;
	XMwe_ctrl:	out std_logic;
	FLwe_ctrl:	out std_logic;
	FLre_ctrl:	out std_logic;
	FLin_ctrl:	in std_logic_vector(3 downto 0)

);
end component;

component IR is
port(	
		IRin: 		in std_logic_vector(15 downto 0);
		IRld:			in std_logic;
		IRout: 		out std_logic_vector(15 downto 0)
);	
end component;

component PC is	  
port(	
	PCld:		in std_logic;
	PCinc:	in std_logic;
	PCclr:	in std_logic;
	PCin:		in std_logic_vector(7 downto 0);
	PCout:	out std_logic_vector(7 downto 0)
);
end component;	 


signal IR_sig: std_logic_vector(15 downto 0);
signal PCinc_sig, PCclr_sig, IRld_sig, PCld_sig: std_logic;
signal XMra_sig: std_logic_vector(7 downto 0); 
signal PCin_memaddr, PCout_memaddr: std_logic_vector (7 downto 0);


begin
	
  
  
  U0: controller port map( 
									clock_cu,
									rst_cu,
									IR_sig,
									RFs_cu,
									RFw1a_cu,
									RFw2a_cu,
									RFr1a_cu,
									RFr2a_cu,
									RFw1e_cu,
									RFw2e_cu,
									RFr1e_cu,
									RFr2e_cu,
									ALUs_cu,
									PCinc_sig,
									PCclr_sig,
									PCld_sig,
									PCin_memaddr,
									IRld_sig,
									Mre_cu,
									Mwe_cu,
									Mra_cu,
									XMre_cu,
									XMwe_cu,
									FLwe_cu,
									FLre_cu,
									FLin_cu
									);
  U1: PC port map(			
									PCld_sig, 
									PCinc_sig, 
									PCclr_sig, 
									PCin_memaddr, 
									Xmaddr_in
									);
  U2: IR port map(			
									Xmdata_out, 
									IRld_sig, 
									IR_sig
									);
									
  immdata <= IR_sig(7 downto 0);

end struct;