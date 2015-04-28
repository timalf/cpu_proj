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
 
  component reg
  port(
    IO: in rejIO;
    input: in rejdane;
   -- Clock: in std_logic;
    output: out rejdane
  );
  end component;
 
 
  --Inputs
  signal IO : rejIO := (others => '0');
  signal input: rejdane := (others => "00000000");
 
  --Outputs
  signal output: rejdane := (others => "00000000");
 
  signal Clock: std_logic := '0';
  constant clock_period : time := 1 ns;
 
BEGIN

 
  -- Instantiate the Unit Under Test (UUT)
  uut: reg PORT MAP (
    IO => IO,
    input => input,
    --Clock => Clock,
    output => output
  );
 
  -- Clock process definitions
  clock_process :process
  begin
    Clock <= '0';
    wait for clock_period/2;
    Clock <= '1';
    wait for clock_period/2;
  end process;
 
 
  -- Stimulus process
  stim_proc: process
  begin		 
    wait for clock_period*10;
 
    IO(0) <= '1';
    input(0) <= "11110000";
    wait for 10 ns;
    IO(0) <= '0';
    wait for 10 ns;
    --assert (output(0)=input(0));
 
    -- case 2 
    IO(3) <= '1';
    input(3) <= input(0); 
    wait for 10 ns;
    IO(3) <= '0';
    wait for 10 ns;
    assert (output(3)=input(3));
 
    -- case 3;
    wait for 10 ns;
    assert (output(2)="11110000");
 
    --case 4
	 wait for 10 ns;
    IO(0) <= '0';
    input(0) <= "11111111";
	 wait for 10 ns;
    IO(0) <= '1';
    assert (output(0)= input(0));
 
 
 
 
    -- summary of testbench
   -- assert false
   -- report "Testbench of registerfile completed successfully!"
   -- severity note;
 
    wait;
  end process;
 
 
END;
