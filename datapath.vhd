----------------------------------------------------------------
-- datapath.vhd
----------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;

entity datapath is				
port(	
	clock_dp:	in 	std_logic;	
	rst_dp:		in 	std_logic;
	imm_data:	in 	std_logic_vector(7 downto 0);			--stala
	mem_data: 	in 	std_logic_vector(7 downto 0);			--dane z ram
	RFs_dp:		in 	std_logic_vector(1 downto 0);			--wybor mux
	RFwa_dp:		in 	std_logic_vector(1 downto 0);			--reg write adress
	RFr1a_dp:	in 	std_logic_vector(1 downto 0);			--reg read1 adress
	RFr2a_dp:	in 	std_logic_vector(1 downto 0);			--reg read2 adress
	RFwe_dp:		in 	std_logic;									--reg write enable
	RFr1e_dp:	in 	std_logic;									--reg read1 enable
	RFr2e_dp:	in 	std_logic;									--reg read2 enable
	ALUs_dp:		in 	std_logic_vector(3 downto 0);			--alu oper
	FLwe_dp:		in 	std_logic;	
	FLre_dp:		in 	std_logic;	
	FLout_dp:	out 	std_logic_vector(3 downto 0);			--alu flag out	
	ALUout_dp:	out 	std_logic_vector(15 downto 0)			--alu result out
);
end datapath;

architecture struct of datapath is

component mux2 is
port( 	
			imm_in: 	in std_logic_vector(7 downto 0);			--immediate input	
			mem_in: 	in std_logic_vector(7 downto 0);	  		--memory input
			reg_in:	in std_logic_vector(7 downto 0);			--alu res/reg input
			mux_s :	in std_logic_vector(1 downto 0);			--select
			mux_ou: 	out std_logic_vector(7 downto 0)			
);
end component;

component reg_file is
port ( 	
			clock	: 	in std_logic;									
			rst	: 	in std_logic;
			RFwe	: 	in std_logic;									--write enable
			RFr1e	: 	in std_logic;									--read1 enable
			RFr2e	: 	in std_logic;									--read2 enable
			RFwa	: 	in std_logic_vector(1 downto 0);			--write address
			RFr1a	: 	in std_logic_vector(1 downto 0);			--read1 address
			RFr2a	: 	in std_logic_vector(1 downto 0);			--read2 address
			RFw	: 	in std_logic_vector(7 downto 0);			--write data
			RFr1	: 	out std_logic_vector(7 downto 0);		--read1 data
			RFr2	:	out std_logic_vector(7 downto 0)			--read2 data
);
end component;

component alu is
port (	
			num_A	: 	in std_logic_vector(7 downto 0);			--1op data
			num_B	: 	in std_logic_vector(7 downto 0);			--2op data
			ALUs	:	in std_logic_vector(3 downto 0);			--op select
			ALUout:	out std_logic_vector(15 downto 0);		--output
			FLAGS	: 	out std_logic_vector(3 downto 0)			--cf,zf,sf,ovf
);
end component;

component fl_reg is
port (	
			clock	: 	in std_logic; 	
			rst	: 	in std_logic;
			FLwe	: 	in std_logic;
			FLre	: 	in std_logic;
			FLwd	: 	in std_logic_vector(3 downto 0);
			FLrd	: 	out std_logic_vector(3 downto 0)			
);
end component;

signal rf2alu1, rf2alu2, muxout_s: std_logic_vector(7 downto 0); 
signal FLAGS_s: std_logic_vector(3 downto 0);
signal ALU_out_s: std_logic_vector (15 downto 0);


begin		

  U1: mux2 port map(
						imm_data, 
						mem_data, 
						rf2alu2, 
						RFs_dp, 
						muxout_s
						);

  U2: reg_file port map(
						clock_dp, 
						rst_dp, 
						RFwe_dp, 
						RFr1e_dp,
						RFr2e_dp, 
						RFwa_dp, 
						RFr1a_dp, 
						RFr2a_dp, 
						ALU_out_s(7 downto 0), 
						rf2alu1, 
						rf2alu2
						);
			
  U3: alu port map(
						rf2alu1, 	
						muxout_s, 
						ALUs_dp,
						ALU_out_s, 
						FLAGS_s
						);
	U4: fl_reg port map(
						clock_dp, 	
						rst_dp, 
						FLwe_dp,
						FLre_dp,
						FLAGS_s, 
						FLout_dp
						);
			 	
  ALUout_dp <= ALU_out_s;
	
end struct;






