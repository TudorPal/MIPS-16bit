----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2022 03:19:53 PM
-- Design Name: 
-- Module Name: numarator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mips16 is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end mips16;

architecture Behavioral of mips16 is

signal enable : std_logic;
signal digits : STD_LOGIC_VECTOR(15 downto 0);

component MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component SSD is
    Port ( digit : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component SSD;

component IFetch is
  Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        en : in STD_LOGIC;
        JA : in STD_LOGIC_VECTOR(15 downto 0);
        BA : in STD_LOGIC_VECTOR(15 downto 0);
        jmp : in STD_LOGIC;
        PCSrc : in STD_LOGIC;
        PCinc : out STD_LOGIC_VECTOR(15 downto 0);
        Instruction : out STD_LOGIC_VECTOR(15 downto 0)
   );
end component;

component IDecode is
    Port( clk: in STD_LOGIC;
          en: in STD_LOGIC;
          Instr: in STD_LOGIC_VECTOR(12 downto 0);
          WD: in STD_LOGIC_VECTOR(15 downto 0);
          RegWrite: in STD_LOGIC;
          RegDst: in STD_LOGIC;
          ExtOp: in STD_LOGIC;
          RD1: out STD_LOGIC_VECTOR(15 downto 0);
          RD2: out STD_LOGIC_VECTOR(15 downto 0);
          Ext_Imm: out STD_LOGIC_VECTOR(15 downto 0);
          func: out STD_LOGIC_VECTOR(2 downto 0);
          sa: out STD_LOGIC);  
end component;

component MainControl is
    Port ( OpCode : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           Branch : out STD_LOGIC;
           ALUsrc : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUop : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component ExecutionUnit is
  Port ( PCinc : in STD_LOGIC_VECTOR(15 downto 0);
         Rd1 : in STD_LOGIC_VECTOR(15 downto 0);
         Rd2 : in STD_LOGIC_VECTOR(15 downto 0);
         Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
         func : in STD_LOGIC_VECTOR(2 downto 0);
         sa : in STD_LOGIC;
         ALUSrc : in STD_LOGIC;
         ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
         BranchAddress : out STD_LOGIC_VECTOR(15 downto 0);
         ALURes : out STD_LOGIC_VECTOR(15 downto 0);
         Zero : out STD_LOGIC
   );
end component;

component MEM is
  Port ( clk : in STD_LOGIC;
         en : in STD_LOGIC;
         ALUResIn : in STD_LOGIC_VECTOR(15 downto 0);
         RD2 : in STD_LOGIC_VECTOR(15 downto 0);
         MemWrite : in STD_LOGIC;
         MemData : out STD_LOGIC_VECTOR(15 downto 0);
         ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal Instruction, PCinc, RD1, RD2, WD, Ext_Imm : STD_LOGIC_VECTOR(15 downto 0);
signal JumpAddress, BranchAddress, ALURes, ALURes1, MemData : STD_LOGIC_VECTOR(15 downto 0);
signal func : STD_LOGIC_VECTOR(2 downto 0);
signal sa, zero : STD_LOGIC;
signal en, rst, PCSrc : STD_LOGIC;

signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0);

begin

MPG1: MPG port map(clk,btn(0),en);
MPG2: MPG port map(clk,btn(1),rst);
SSD1 : SSD port map(digits, clk, an, cat);

inst_IF : IFetch port map(clk, rst, en, BranchAddress, JumpAddress, Jump, PCSrc, Instruction, PCInc);
inst_ID : IDecode port map(clk, en, Instruction(12 downto 0), WD, RegWrite, RegDst, ExtOp, RD1, RD2, Ext_Imm, func, sa);
inst_MC : MainControl port map(Instruction(15 downto 13), RegDst, ExtOp, Branch, ALUSrc, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
inst_EX : ExecutionUnit port map(PCInc, RD1, RD2, Ext_Imm, func, sa, ALUSrc, ALUOp, BranchAddress, ALURes, zero);
inst_MEM : MEM port map(clk, en, ALURes, RD2, MemWrite, MemData, ALURes1);

--branch control
PCSrc <= Zero and Branch;
--jump address
JumpAddress <= PCInc(15 downto 13) & Instruction(12 downto 0);

-- Write back
with MemtoReg select
    WD <= MemData when '1',
          ALURes when '0',
          (others => 'X') when others;

-- SSD display MUX

with sw(7 downto 5) select
    digits <= Instruction when "000",
              PCInc when "001",
              RD1 when "010",
              RD2 when "011",
              Ext_Imm when "100",
              ALURes when "101",
              MemData when "110",
              WD when "111",
              (others => 'X') when others;
led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;



end Behavioral;
