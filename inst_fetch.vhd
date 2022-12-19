----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2022 01:26:42 PM
-- Design Name: 
-- Module Name: inst_fetch - Behavioral
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

entity IFetch is
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
end IFetch;

architecture Behavioral of IFetch is
type tROM is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal ROM : tROM := (
    B"101_111_000_0000000",     -- LW n,0	          - 0
    B"101_111_001_0000110",     -- LW adresa, 6       - 1
    B"101_111_010_0000110",     -- LW count, 6        - 2
    B"101_111_011_0000101",     -- LW maxim,5         - 3
    B"101_111_100_0000101",     -- LW minim,5         - 4
    B"000_001_010_001_0_000",   -- add adresa,count,adresa   - 5
    B"101_001_101_0000000",     -- LW a, adresa       - 6
    B"011_101_011_0000001",     -- BGTZ (a, maxim, 1) - 7
    B"111_0000000001110",       -- JUMP 12	          - 8
    B"110_111_101_0000101",     -- SW a,5	          - 9
    B"101_111_011_0000101",     -- LW maxim,5         - 10
    B"111_0000000000101",       -- JUMP 5	          - 11
    B"101_101_100_0000001",     -- BLTZ (a,minim,1)   - 12
    B"111_0000000000101",       -- JUMP 5             - 13
    B"110_111_101_0000101",     -- SW a,5             - 14
    B"101_111_100_0000101",     -- LW minim,5         - 15
    B"111_0000000000101",       -- JUMP 5	          - 16
    B"000_100_111_110_0_100",   -- AND aux,minim, 0   - 17
    B"010_100_110_0000001",     -- BEQ (aux,minim,1)  - 18
    B"111_0000000011000",       -- JUMP 24	          - 19
    B"101_111_101_0000110",     -- LW a,6             - 20
    B"000_011_111_110_0_100",   -- AND aux,maxim, 0   - 21
    B"101_111_101_0000110",     -- BEQ (aux,maxim,1)  - 22
    B"101_111_101_0000111",     -- LW a,7             - 23
    B"110_111_101_0000101",     -- SW a,5             - 24
    others => X"0000"
);

signal RA : STD_LOGIC_VECTOR(15 downto 0);
signal count : STD_LOGIC_VECTOR(15 downto 0);
signal NI : STD_LOGIC_VECTOR(15 downto 0);
signal mux1 : STD_LOGIC_VECTOR(15 downto 0);
begin

PCinc <= count;

process(clk)       
begin
if reset = '1' then NI <=X"0000";
elsif en = '1' then
    if clk'event and clk = '1' then
    NI <= RA;
    end if;
end if;
end process;

process(RA)
begin
count <= RA + '1';
end process;

process(count)
begin
if PCsrc = '1' then mux1 <= BA;
else mux1 <= RA;
end if;
end process;

process(mux1)
begin
if jmp = '1' then NI <= JA;
else NI <= mux1;
end if;
end process;

process(RA)
begin
Instruction <= ROM(conv_integer(RA));
end process;

end Behavioral;
