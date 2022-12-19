----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 02:36:56 PM
-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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

entity ExecutionUnit is
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
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal ALURes1 : STD_LOGIC_VECTOR(15 downto 0);
signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);
signal mux1 : STD_LOGIC_VECTOR(15 downto 0);

begin
with ALUSrc select          -- primul MUX
    mux1 <= Rd2 when '0',
            Ext_Imm when '1',
            (others => 'X') when others;
            
process(ALUOp,func)         -- ALU control
begin
case ALUOp is 
    when "000" => ALUCtrl <= func;
    when "001" => ALUCtrl <= "000";     -- +
    when "010" => ALUCtrl <= "001";     -- BEQ
    when "011" => ALUCtrl <= "010";     -- BGTZ
    when "100" => ALUCtrl <= "011";     -- BLTZ
    when "101" => ALUCtrl <= "100";     -- LW
    when "110" => ALUCtrl <= "101";     -- SW
    when others => ALUCtrl <= (others => 'X');      -- unknown
end case;
end process;

process(ALUCtrl, Rd1, sa)
begin
    case ALUOp is
        when "000" =>           -- operatii pt tip R
           case ALUCtrl is
                when "000" =>       -- ADD
                    ALURes1 <= RD1 + RD2;
                when "001" =>       -- SUB
                    ALURes1 <= RD1 - RD2;
                when "010" =>       -- SLL
                    ALURes1(15 downto 1) <= RD1(14 downto 0);
                    ALURes1(0) <= RD1(15);
                when "011" =>       -- SRL
                    ALURes1(14 downto 0) <= RD1(15 downto 1);
                    ALURes1(15) <= RD1(0);
                when "100" =>       -- AND
                    ALURes1 <= RD1 AND RD2;
                when "101" =>       -- OR
                    ALURes1 <= RD1 OR RD2;
                when "110" =>       -- XOR
                    ALURes1 <= RD1 XOR RD2;
                when "111" =>       -- SGT
                    if RD1 > RD2 then ALURes1 <= X"0001";
                    end if;
                when others =>
                    ALURes1 <= X"0000";
             end case;
        when others =>             -- operatii tip I
            case ALUCtrl is
                when "000" =>       -- ADDI
                    ALURes1 <= RD1 + Ext_Imm;
                when "001" =>       -- BEQ
                    ALURes1 <= RD1 - RD2;
                when "010" =>
                    if RD1 > RD2 then ALURes1 <= X"0000";       -- BGTZ
                    end if;
                when "011" =>
                    if RD1 < RD2 then ALURes1 <= X"0000";       -- BLTZ
                    end if;
                when "100" =>       -- LW
                    ALURes1 <= RD1;
                when "101" =>       -- SW
                    ALURes1 <= RD1;
                when others =>
                    ALURes1 <= X"0000";
            end case;    
    end case;

if ALURes1 = X"0000" then zero <= '1';
else zero <= '0';
end if;
end process;

process(PCInc, Ext_Imm)
begin
BranchAddress <= PCInc + Ext_Imm;
end process;

ALURes <= ALUres1;

end Behavioral;
