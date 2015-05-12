----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:27:10 04/11/2015 
-- Design Name: 
-- Module Name:    alutestbench - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY alutestbench IS
END alutestbench;

ARCHITECTURE behavior OF alutestbench IS 

   signal Clk : std_logic := '0';
   signal a,b,res,res2 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal sf,cf,zf,ovf : STD_LOGIC :='0';
	signal oper : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
   constant Clk_period : time := 1 ns;
BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: entity work.alu PORT MAP (
          a => a,
          b => b,
          oper => oper,
          res => res,
			 sf => sf,
			 cf => cf,
			 zf => zf,
			 ovf => ovf,
			 Clk => CLK
        );

   Clk_process :process
   begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
   end process;
	
   stim_proc: process
   begin 
	a<= "00000000";
	b<= "00000000";
	wait for Clk_period*1;
	for I in 0 to 256 loop
			for J in 0 to 256 loop 
    		  wait for Clk_period;
        oper <= "000000";  wait for Clk_period;-- +
        oper <= "000100";  wait for Clk_period;-- +1
        oper <= "001000";  wait for Clk_period;-- inc
        oper <= "001001";  wait for Clk_period;-- dec
        oper <= "001100";  wait for Clk_period;-- -
        oper <= "010000";  wait for Clk_period;-- *
        oper <= "011100";  wait for Clk_period;-- and
        oper <= "100000";  wait for Clk_period; -- or
		  oper <= "100100";  wait for Clk_period;-- xor
		  oper <= "101100";  wait for Clk_period;-- not
		  oper <= "110100";  wait for Clk_period;-- -1
		  oper <= "101000"; 	wait for Clk_period;-- 
		  oper <= "101001"; 	wait for Clk_period;-- 
		  oper <= "101010"; 	wait for Clk_period;-- 
		  oper <= "101011"; 	wait for Clk_period;-- 
		  oper <= "101101"; 	wait for Clk_period;-- 
		  oper <= "101110"; 	wait for Clk_period;-- 
		  oper <= "101111"; 	wait for Clk_period;-- 
		  oper <= "110000"; 	wait for Clk_period;-- 
		  b <= std_logic_vector( unsigned(b) + 1 );
end loop;
a <= std_logic_vector( unsigned(a) + 1 );
end loop;
      wait;
   end process;

end behavior;

