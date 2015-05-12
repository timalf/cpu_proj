----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:27 05/12/2015 
-- Design Name: 
-- Module Name:    controlunit - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity ControlUnit is
  
  port (
    CLK    		: in  std_logic;
    instr      : in  std_logic_vector(15 downto 0);
    --ForceZero  : in  std_logic;
    RegWrite   : out std_logic;
	 Reg1Write   : out std_logic;

    RegDataSrc : out std_logic_vector(7 downto 0);
	 Reg1DataSrc : out std_logic_vector(7 downto 0);
    CmpCode    : out std_logic_vector(1 downto 0);
    MemDataSrc : out std_logic_vector(7 downto 0);
    MemWrite   : out std_logic;
    BranchCtrl : out std_logic_vector(2 downto 0);
    ALU_Op     : out std_logic_vector(2 downto 0);
    ALU_Src1   : out std_logic_vector(2 downto 0);
    ALU_Src2   : out std_logic_vector(1 downto 0);
    RegDst     : out std_logic_vector(2 downto 0)
    );

end ControlUnit;

architecture ControlUnit_Arch of ControlUnit is

  signal output : std_logic_vector(20 downto 0) := (others => '0');  -- all signals
  
begin  -- ControlUnit_Arch

--  RegWrite <= output(20);
--  RegDataSrc <= output(19);
--  CmpCode <= output(18 downto 17);
--  MemDataSrc <= output(8);
--  MemWrite <= output(15) when falling_edge(CPU_CLK);
--  MemRead <= output(14) when falling_edge(CPU_CLK);
--  BranchCtrl <= output(13 downto 11);
--  ALU_Op <= output(10 downto 8);
--  ALU_Src1 <= output(7 downto 5);
--  ALU_Src2 <= output(4 downto 3);
--  RegDst <= output(2 downto 0);

  process (CLK)
  begin  -- process
    if rising_edge(CLK) then
        output <= (others => '0');
      else
        case instr(15 downto 10) is
          when "000000" =>			 -- dodawanie mem + reg
				MemWrite <= '0';
				MemDataSrc <= instr(9 downto 2);
				RegWrite <= '0';
				RegDataSrc <= instr(1 downto 0);
			when "000001" =>			 -- dodawanie reg + reg
				RegWrite <= '0';
				RegDataSrc <= instr(3 downto 2);
				Reg1Write <= '0';
				Reg1DataSrc <= instr(1 downto 0);
			
          when others =>
            output <= (others => '0');
        end case;
    end if;
  end process;
  
end ControlUnit_Arch;

