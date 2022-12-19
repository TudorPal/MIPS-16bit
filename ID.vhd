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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecode is
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
end IDecode;

architecture Behavioral of IDecode is
type reg_array is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal reg_file : reg_array := (
        X"0000",        -- reg n 000
        X"0001",        -- adresa 001
        X"0002",        -- count 010
        X"0003",        -- maxim 011
        X"0004",        -- minim 100
        X"0005",        -- a 101
        X"0006",        -- aux pt and 110
        others => X"0000");
        
signal WriteAddress: STD_LOGIC_VECTOR(2 downto 0);

begin

    with RegDst select
        WriteAddress <= Instr(6 downto 4) when '1',  -- inst de tip R, intra RD
                        Instr(9 downto 7) when '0',  -- inst de tip I, intra RT
                        (others => 'X') when others;

    process(clk)
    begin
    if rising_edge(clk) then
                if en = '1' and RegWrite = '1' then
                    reg_file(conv_integer(WriteAddress)) <= WD;
                 end if;
            end if;
            RD1 <= reg_file(conv_integer(Instr(12 downto 10)));
            RD2 <= reg_file(conv_integer(Instr(9 downto 7)));
    end process;
    
    process (Instr(6 downto 0), ExtOp)
    begin 
        Ext_imm(15 downto 7) <= (others => ExtOp);
        Ext_imm(6 downto 0) <= Instr(6 downto 0);
    end process;
    
    func <= Instr(2 downto 0);
    sa <= Instr(3);
    
end Behavioral;