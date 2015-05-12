----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:20:18 05/12/2015 
-- Design Name: 
-- Module Name:    core - Behavioral 
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
use work.typy.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity core is 
  port(
    --memory interface 
    MemAddr: out std_logic_vector(15 downto 0); --memory address (in bytes)
    --MemWW: out std_logic; --memory writeword
    MemWE: out std_logic; --memory writeenable
    MemIn: in std_logic_vector(7 downto 0);
    MemOut: out std_logic_vector(7 downto 0);
    --general interface
    CLK: in std_logic;
    RST: in std_logic; --When this is high, CPU will reset within 1 clock cycles. 
    --Enable: in std_logic; --When this is high, the CPU executes as normal, when low the CPU stops at the next clock cycle(maintaining all state)
   -- Hold: in std_logic; --when high, CPU pauses execution and places Memory interfaces into high impendance state so the memory can be used by other components
   -- HoldAck: out std_logic; --when high, CPU acknowledged hold and buses are in high Z
    --todo: port interface
 
    --debug ports:
--    DebugIR: out std_logic_vector(15 downto 0); --current instruction
--    DebugIP: out std_logic_vector(7 downto 0); --current IP
--    DebugCS: out std_logic_vector(7 downto 0); --current code segment
--    DebugTR: out std_logic; --current value of TR
--    DebugR0: out std_logic_vector(7 downto 0)
   );
end core;
 
architecture Behavioral of core is
  component ControlUnit is 
    port(
		CLK: in std_logic;
      instr: in std_logic_vector(15 downto 0);
      AddressIn: in std_logic_vector(15 downto 0);
      Clock: in std_logic;
      DataIn: in std_logic_vector(15 downto 0); --interface from memory
      IROut: out std_logic_vector(15 downto 0);
      AddressOut: out std_logic_vector(15 downto 0) --interface to memory
    );
  end component;
  component alu is
    port(
	 
			CLK  : in  std_logic;
			oper : in STD_LOGIC_VECTOR (5 downto 0);
			a : in STD_LOGIC_VECTOR (7 downto 0);
			b : in STD_LOGIC_VECTOR (7 downto 0);
			res: out STD_LOGIC_VECTOR (7 downto 0);
			res2: out STD_LOGIC_VECTOR (15 downto 0);
			sf : out STD_LOGIC;
			zf : out STD_LOGIC;
			cf : out STD_LOGIC;
			ovf : out STD_LOGIC
    );
  end component;
  component reg is 
    port(
         CLK	    : in  std_logic;
    RegWrite : in  std_logic;
    Rx       : in  std_logic_vector(1 downto 0);
    wData    : in  std_logic_vector(7 downto 0);
    
    R0_out   : out std_logic_vector(7 downto 0);
    R1_out   : out std_logic_vector(7 downto 0);
    R2_out   : out std_logic_vector(7 downto 0);
    R3_out   : out std_logic_vector(7 downto 0)
    );
  end component;
  

  type ProcessorState is (
    ResetProcessor,
    FirstFetch1, --the fetcher needs two clock cycles to catch up
    FirstFetch2,
    Firstfetch3,
    Execute,
    WaitForMemory,
    HoldMemory,
    WaitForAlu -- wait for settling is needed when using the ALU
  );
  signal state: ProcessorState;
  signal HeldState: ProcessorState; --state the processor was in when HOLD was activated
 

 
  --register signals
   signal R0 : std_logic_vector(7 downto 0);
  signal R1 : std_logic_vector(7 downto 0); 
  signal R2 : std_logic_vector(7 downto 0); 
  signal R3 : std_logic_vector(7 downto 0);
  --fetch signals
  signal fetchEN: std_logic;
  signal IR: std_logic_vector(15 downto 0);
  --alu signals
  signal AluOp: std_logic_vector(4 downto 0);
  signal AluIn1: std_logic_vector(7 downto 0);
  signal AluIn2: std_logic_vector(7 downto 0);
  signal AluOut: std_logic_vector(7 downto 0);
  signal AluTR: std_logic;
  signal TR: std_logic;
  signal TRData: std_logic;
  signal UseAluTR: std_logic;
 
  --control signals
  signal InReset: std_logic;
  signal OpAddress: std_logic_vector(15 downto 0); --memory address to use for operation of an instruction
  signal OpDataIn: std_logic_vector(15 downto 0); 
  signal OpDataOut: std_logic_vector(15 downto 0);
  signal OpWW: std_logic;
  signal OpWE: std_logic;
  signal OpDestReg1: std_logic_vector(3 downto 0);
  signal OpUseReg2: std_logic;
  signal OpDestReg2: std_logic_vector(3 downto 0);
 
  --opcode shortcut signals
  signal opmain: std_logic_vector(3 downto 0);
  signal opimmd: std_logic_vector(7 downto 0);
  signal opcond1: std_logic; --first conditional bit
  signal opcond2: std_logic; --second conditional bit
  signal opreg1: std_logic_vector(2 downto 0);
  signal opreg2: std_logic_vector(2 downto 0);
  signal opreg3: std_logic_vector(2 downto 0);
  signal opseges: std_logic; --use ES segment
 
  signal regbank: std_logic;
 
  signal fetcheraddress: std_logic_vector(15 downto 0);
 
 
  signal bankreg1: std_logic_vector(3 downto 0); --these signals have register bank stuff baked in
  signal bankreg2: std_logic_vector(3 downto 0);
  signal bankreg3: std_logic_vector(3 downto 0);
  signal FetchMemAddr: std_logic_vector(15 downto 0);
 
  signal UsuallySS: std_logic_vector(3 downto 0);
  signal UsuallyDS: std_logic_vector(3 downto 0);
  signal AluRegOut: std_logic_vector(3 downto 0);
begin
  rejestry: reg port map(
    WriteEnable => regWE,
    DataIn => regIn,
    Clock => Clock,
    DataOut => regOut
  );
  cpualu: alu port map(
    Op => AluOp,
    DataIn1 => AluIn1,
    DataIn2 => AluIn2,
    DataOut => AluOut,
    TR => AluTR
  );
 

 
 
 
  end process;
 
 
 
 
 
 
 
 
 
end Behavioral;
