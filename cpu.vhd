--------------------------------------------------------
-- cpu.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;
use work.all;

entity CPU is
port( 	
		cpu_clk:	in std_logic;
		cpu_rst:	in std_logic;
		cpu_output:	out std_logic_vector(7 downto 0)
);
end CPU;

architecture structure of CPU is

component datapath is
port(	
		clock_dp:	in std_logic;									--zegar
		rst_dp:		in std_logic;									--reset
		imm_data:	in std_logic_vector(7 downto 0);			--stala
		mem_data: 	in std_logic_vector(7 downto 0);			--dane z pamieci
		RFs_dp:		in std_logic_vector(1 downto 0);			--wybor multiplexera
		RFw1a_dp:	in std_logic_vector(1 downto 0);			
		RFw2a_dp:	in std_logic_vector(1 downto 0);				
		RFr1a_dp:	in std_logic_vector(1 downto 0);
		RFr2a_dp:	in std_logic_vector(1 downto 0);
		RFw1e_dp:	in std_logic;
		RFw2e_dp:	in std_logic;
		RFr1e_dp:	in std_logic;
		RFr2e_dp:	in std_logic;
		ALUs_dp:		in std_logic_vector(3 downto 0);
		FLwe_dp:		in std_logic;	
		FLre_dp:		in std_logic;	
		FLout_dp:	out std_logic_vector(3 downto 0);
		ALUout_dp:	out std_logic_vector(15 downto 0)
);
end component;

component CU is		
port(	
		clock_cu:	in std_logic;
		rst_cu:		in std_logic;
		Xmdata_out: in std_logic_vector(15 downto 0);		--dane z pamieci rozkazow
		maddr_in:	out std_logic_vector(7 downto 0);
		Xmaddr_in:	out std_logic_vector(7 downto 0);		  
		immdata:		out std_logic_vector(7 downto 0);
		RFs_cu:		out	std_logic_vector(1 downto 0);
		RFw1a_cu:	out	std_logic_vector(1 downto 0);
		RFw2a_cu:	out	std_logic_vector(1 downto 0);
		RFr1a_cu:	out	std_logic_vector(1 downto 0);
		RFr2a_cu:	out	std_logic_vector(1 downto 0);
		RFw1e_cu:	out	std_logic;
		RFw2e_cu:	out	std_logic;
		RFr1e_cu:	out	std_logic;
		RFr2e_cu:	out	std_logic;
		ALUs_cu:		out 	std_logic_vector(3 downto 0);	
		Mre_cu:		out	std_logic;
		Mwe_cu:		out 	std_logic;
		Mra_cu:		out 	std_logic_vector(7 downto 0);
		XMre_cu:		out 	std_logic;
		XMwe_cu:		out 	std_logic;
		FLwe_cu:		out	std_logic;	
		FLre_cu:		out 	std_logic;
		FLin_cu:		in		std_logic_vector(3 downto 0)
);
end component;

component memory is
port ( 	
		clock		: 	in std_logic;
		rst		: 	in std_logic;
		Mre		:	in std_logic;
		Mwe		:	in std_logic;
		address	:	in std_logic_vector(7 downto 0);
		data_in	:	in std_logic_vector(7 downto 0);
		data_out:	out std_logic_vector(7 downto 0)
);
end component;

component in_memory is
port ( 	
		clock		: 	in std_logic;
		rst		: 	in std_logic;
		XMre		:	in std_logic;
		XMwe		:	in std_logic;
		Xaddress	:	in std_logic_vector(7 downto 0);
		Xdata_in	:	in std_logic_vector(15 downto 0);
		Xdata_out:	out std_logic_vector(15 downto 0)
);
end component;

signal Xmdin_bus, Xmdout_bus : std_logic_vector (15 downto 0);
signal mdin_bus, mdout_bus, addr_bus, Xaddr_bus, immd_bus, mem_addr, Xmem_addr: std_logic_vector(7 downto 0);
signal RFw1a_s,RFw2a_s, RFr1a_s, RFr2a_s: std_logic_vector(1 downto 0);
signal RFw1e_s,RFw2e_s, RFr1e_s, RFr2e_s: std_logic;
signal ALUs_s : std_logic_vector(3 downto 0);
signal FLout_bus : std_logic_vector (3 downto 0);
signal RFs_s: std_logic_vector(1 downto 0);
signal IRld_s, PCld_s, PCinc_s, PCclr_s: std_logic;
signal Mre_s, Mwe_s: std_logic;
signal XMre_s, XMwe_s, FLwe_s, FLre_s: std_logic;
signal mdin_bus_t :std_logic_vector (15 downto 0);
begin
	
	mdin_bus <= mdin_bus_t(7 downto 0);
	Xmem_addr <= Xaddr_bus(7 downto 0);
	cpu_output <= mdin_bus_t(7 downto 0);
	
	Unit0: CU port map(			
										cpu_clk,
										cpu_rst,
										Xmdout_bus,
										addr_bus, 
										Xaddr_bus,
										immd_bus, 
										RFs_s,
										RFw1a_s,
										RFw2a_s,
										RFr1a_s,
										RFr2a_s,
										RFw1e_s,
										RFw2e_s,
										RFr1e_s,
										RFr2e_s,
										ALUs_s,
										Mre_s,
										Mwe_s,
										mem_addr,
										XMre_s,
										XMwe_s,
										FLwe_s,
										FLre_s,
										FLout_bus
										);
	Unit1: datapath port map( 
										cpu_clk,
										cpu_rst,
										immd_bus,
										mdout_bus,
										RFs_s,
										RFw1a_s,
										RFw2a_s,
										RFr1a_s,
										RFr2a_s,
										RFw1e_s,
										RFw2e_s,
										RFr1e_s,
										RFr2e_s,
										ALUs_s,
										FLwe_s,
										FLre_s,
										FLout_bus,
										mdin_bus_t
									--	cpu_output
									);
	Unit2: memory port map(	
										cpu_clk,
										cpu_rst,
										Mre_s,
										Mwe_s,
										mem_addr,
										mdin_bus,
										mdout_bus
										);
	Unit3: in_memory port map(	
										cpu_clk,
										cpu_rst,
										XMre_s,
										XMwe_s,
										Xaddr_bus,
										Xmdin_bus,
										Xmdout_bus
										);

end structure;
