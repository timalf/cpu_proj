----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:02 04/28/2015 
-- Design Name: 
-- Module Name:    regtestbench - Behavioral 
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.typy.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
ENTITY reg_tb IS
END reg_tb;
 
ARCHITECTURE behavior OF reg_tb IS 
 
-- Component Declaration for the Unit Under Test (UUT)
 
--  component reg
--  port(
--    CLK	    : in  std_logic;
--    RegWrite : in  std_logic;
--    Rx       : in  std_logic_vector(1 downto 0);
--    wData    : in  std_logic_vector(7 downto 0);
--    
--    R0_out   : out std_logic_vector(7 downto 0);
--    R1_out   : out std_logic_vector(7 downto 0);
--    R2_out   : out std_logic_vector(7 downto 0);
--    R3_out   : out std_logic_vector(7 downto 0)
--  );
--  end component;
 
 
  --Inputs
  signal RegWrite : std_logic;
  signal Rx : std_logic_vector(1 downto 0); 
    signal wData : std_logic_vector(7 downto 0); 
 
  --Outputs
    signal R0_out   :  std_logic_vector(7 downto 0);
   signal R1_out   :  std_logic_vector(7 downto 0);
   signal R2_out   :  std_logic_vector(7 downto 0);
   signal R3_out   :  std_logic_vector(7 downto 0);
 
  signal  CLK : std_logic := '0';
  constant CLK_period : time := 1 ns;
 
BEGIN

 
  -- Instantiate the Unit Under Test (UUT)
  uut: entity work.reg PORT MAP (
    CLK => CLK,
    RegWrite => RegWrite,
    Rx => Rx,
	 wData => wData,
	 R0_out => R0_out,
	 R1_out => R1_out,
	 R2_out => R2_out,
	 R3_out => R3_out
  );
 
  -- Clock process definitions
  CLK_process: process
  begin
    CLK <= '0';
    wait for CLK_period/2;
    CLK <= '1';
    wait for CLK_period/2;
  end process;
 
 
  -- Stimulus process
  stim_proc: process
  begin		 
    wait for CLK_period*1;
	
	 Rx <= "00";
	 wData <="00110011";
    RegWrite <= '1';
	 
    wait for 10 ns;
    RegWrite <= '0';
    wait for 10 ns;
    --assert (output(0)=input(0));
 


 
 
 
    -- summary of testbench
   -- assert false
   -- report "Testbench of registerfile completed successfully!"
   -- severity note;
 
    wait;
  end process;
 
 
END;
