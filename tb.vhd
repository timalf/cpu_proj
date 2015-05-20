--------------------------------------------------------
-- 
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;
use work.all;

entity testbench is
end testbench;

architecture behv of testbench is

component CPU is
port( 	
		cpu_clk:	in std_logic;
		cpu_rst:	in std_logic;
		cpu_output:	out std_logic_vector(7 downto 0)
); 
end component;

signal TB_clk: std_logic;
signal TB_rst: std_logic;
signal TB_output: std_logic_vector(7 downto 0);
constant Clk_period : time := 1 ns;
begin  			
	
	uut: CPU port map(TB_clk, TB_rst, TB_output);
	
    Clk_process :process
   begin
        TB_clk <= '0';
        wait for Clk_period/2;
        TB_clk <= '1';
        wait for Clk_period/2;
   end process;
	
	
    process
    begin 
		TB_rst <= '1';
		wait for 50 ns;
		TB_rst <= '0';
		wait for 100000 ns;
	end process;	

end behv;				 

--------------------------------------------------------
configuration CFG_testbench of testbench is
    for behv
    end for;
end CFG_testbench;
--------------------------------------------------------