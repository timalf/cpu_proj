----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:58:10 04/27/2015 
-- Design Name: 
-- Module Name:    reg - Behavioral 
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
use ieee.std_logic_unsigned.all; 
use work.typy.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
  
  port (
    CLK	    : in  std_logic;
    RegWrite : in  std_logic;
    Rx       : in  std_logic_vector(1 downto 0);
    wData    : in  std_logic_vector(7 downto 0);
    
    R0_out   : out std_logic_vector(7 downto 0);
    R1_out   : out std_logic_vector(7 downto 0);
    R2_out   : out std_logic_vector(7 downto 0);
    R3_out   : out std_logic_vector(7 downto 0)
   
    
    );

end reg;
 
architecture reg_Arch of reg is

  signal R0 : std_logic_vector(7 downto 0) := (others => '0');
  signal R1 : std_logic_vector(7 downto 0) := (others => '0');
  signal R2 : std_logic_vector(7 downto 0) := (others => '0');
  signal R3 : std_logic_vector(7 downto 0) := (others => '0');
  
begin  -- reg_Arch

  -- Zapis do rejestru
  process (CLK)
  begin 
    if rising_edge(CLK) then
      if RegWrite = '1' then
        case Rx is
          when "00" => R0 <= wData;
          when "01" => R1 <= wData;
          when "10" => R2 <= wData;
          when "11" => R3 <= wData;
          when others => null;
        end case;
      end if;
    end if;
  end process;


  -- Odczyt
  process (CLK)
  begin 
    if falling_edge(CLK) then
		if RegWrite = '0' then
      case Rx is
        when "00" => R0_out <= R0;
        when "01" => R1_out <= R1;
        when "10" => R2_out <= R2;
        when "11" => R3_out <= R3;
        when others => null;
      end case;
		end if;
    end if;
  end process;


end reg_Arch;
