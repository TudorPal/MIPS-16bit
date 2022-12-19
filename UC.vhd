----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2022 02:56:26 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity MainControl is
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
end MainControl;

architecture Behavioral of MainControl is

begin
process(OpCode)
begin
case OpCode is 
    when "000" => 
         ALUop <= "000";
         RegDst <= '1';
         ExtOp <= 'X';
         ALUSrc <= '0';
         Branch <= '0';
         Jump <= '0';
         MemWrite <='0';
         MemtoReg <= '0';
         RegWrite <= '1';
    when "001" => --ADDI
         ALUop <= "001";
         RegDst <= '0';
         ExtOp <= '1';
         ALUSrc <= '1';
         Branch <= '0';
         Jump <= '0';
         MemWrite <='0';
         MemtoReg <= '0';
         RegWrite <= '1';
    when "010" => --BEQ
         ALUop <= "010";
         RegDst <= 'X';
         ExtOp <= '1';
         ALUSrc <= '0';
         Branch <= '1';
         Jump <= '0';
         MemWrite <='0';
         MemtoReg <= 'X';
         RegWrite <= '0';
    when "011" => --BGTZ
         ALUop <= "011";
         RegDst <= 'X';
         ExtOp <= '1';
         ALUSrc <= '0';
         Branch <= '1';
         Jump <= '0';
         MemWrite <='0';
         MemtoReg <= 'X';
         RegWrite <= '0';
    when "100" => --BLTZ
        ALUop <= "100";
        RegDst <= 'X';
        ExtOp <= '1';
        ALUSrc <= '0';
        Branch <= '1';
        Jump <= '0';
        MemWrite <='0';
        MemtoReg <= 'X';
        RegWrite <= '0';
    when "101" => --LW
        ALUop <= "101";
        RegDst <= '0';
        ExtOp <= '1';
        ALUSrc <= '1';
        Branch <= '0';
        Jump <= '0';
        MemWrite <='0';
        MemtoReg <= '1';
        RegWrite <= '1';
    when "110" => --SW
        ALUop <= "110";
        RegDst <= 'X';
        ExtOp <= '1';
        ALUSrc <= '1';
        Branch <= '0';
        Jump <= '0';
        MemWrite <='1';
        MemtoReg <= 'X';
        RegWrite <= '0';
    when others =>
         ALUop <= "000";
         RegDst <= 'X';
         ExtOp <= 'X';
         ALUSrc <= 'X';
         Branch <= 'X';
         Jump <= '1';
         MemWrite <='0';
         MemtoReg <= 'X';
         RegWrite <= '1';
 end case;
 end process;
 
end Behavioral;