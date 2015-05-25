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
--	PCld_cu		:	in 	std_logic;
--	mdata_out	: 	in 	std_logic_vector(7 downto 0);
	Xmdata_out	: 	in 	std_logic_vector(15 downto 0);
-- dpdata_out	:	in 	std_logic_vector(7 downto 0);
--	Xdpdata_out	:	in 	std_logic_vector(15 downto 0);
	maddr_in		:	out 	std_logic_vector(7 downto 0);		  
	Xmaddr_in	:	out 	std_logic_vector(7 downto 0);		  
	immdata		:	out 	std_logic_vector(7 downto 0);
	RFs_cu		:	out	std_logic_vector(1 downto 0);
	RFwa_cu		:	out	std_logic_vector(1 downto 0);
	RFr1a_cu:		out	std_logic_vector(1 downto 0);
	RFr2a_cu:		out	std_logic_vector(1 downto 0);
	RFwe_cu:			out	std_logic;
	RFr1e_cu:		out	std_logic;
	RFr2e_cu:		out	std_logic;
	ALUs_cu:			out	std_logic_vector(3 downto 0);	
	Mre_cu:			out 	std_logic;
	Mwe_cu:			out 	std_logic;
	Mra_cu:			out	std_logic_vector(7 downto 0);	
	XMre_cu:			out 	std_logic;
	XMwe_cu:			out 	std_logic
--	XMra_cu:			out	std_logic_vector(7 downto 0)	
);
end CU;

architecture struct of CU is

component controller is
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
signal Ms_sig: std_logic_vector(1 downto 0);
signal PC2mux: std_logic_vector(7 downto 0);
signal XMra_sig,IR2mux_a, IR2mux_b: std_logic_vector(7 downto 0); 
signal PCin_memaddr, PCout_memaddr: std_logic_vector (7 downto 0);


begin
	
  
  
  U0: controller port map( 
									clock_cu,
									rst_cu,
									IR_sig,
									RFs_cu,
									RFwa_cu,
									RFr1a_cu,
									RFr2a_cu,
									RFwe_cu,
									RFr1e_cu,
									RFr2e_cu,
									ALUs_cu,
									PCinc_sig,
									PCclr_sig,
									PCld_sig,
									IRld_sig,
									--Ms_sig,
									Mre_cu,
									Mwe_cu,
									Mra_cu,
									XMre_cu,
									XMwe_cu
								--	PCout_memaddr
					--				oe_cu
									);
  U1: PC port map(			PCld_sig, 
									PCinc_sig, 
									PCclr_sig, 
									PCin_memaddr, 
									Xmaddr_in);
  U2: IR port map(			
									Xmdata_out, 
									IRld_sig, 
								--	IR2mux_a, 
									IR_sig);
									---multiplekser do ogarniecia
--  U3: mux1 port map(		dpdata_out,
--									IR2mux_a,
--									PC2mux,
--									IR2mux_b,
--									Ms_sig,
--									maddr_in
--									);

IR2mux_a <= IR_sig(7 downto 0);
  IR2mux_b <= "000000" & IR_sig(7 downto 6);	
  immdata <= IR_sig(7 downto 0);
 -- XMra_cu <= PCout_memaddr;

end struct;