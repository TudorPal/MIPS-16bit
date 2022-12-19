----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 03:43:19 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
  Port ( clk : in STD_LOGIC;
         en : in STD_LOGIC;
         ALUResIn : in STD_LOGIC_VECTOR(15 downto 0);
         RD2 : in STD_LOGIC_VECTOR(15 downto 0);
         MemWrite : in STD_LOGIC;
         MemData : out STD_LOGIC_VECTOR(15 downto 0);
         ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal ram:ram_type := (
   X"0004",
   X"0002",
   X"0007",
   X"0020",
   X"0013",
   X"0000",
   X"0001",
   others => X"0000"
);
begin
process(CLK)
begin
    if(rising_edge(CLK)) then
        if MemWrite='1' then
            ram(conv_integer(ALUResIn))<=RD2;
         end if;
         end if;
end process;

process(ALUResIn)
begin
MemData<=ram(conv_integer(ALUResIn));
ALUResOut<=ALUResIn;
end process;
end Behavioral;