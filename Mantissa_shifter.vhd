----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2020 15:01:39
-- Design Name: 
-- Module Name: Mantissa_shifter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mantissa_shifter is
    --1 bit sign + 1 hidden bit + 23 bit mantissa = 25 bits.
    port (M_a: in std_logic_vector(24 downto 0);
          M_b: in std_logic_vector(24 downto 0);
          shift_amt_a: in std_logic_vector(7 downto 0);
          shift_amt_b: in std_logic_vector(7 downto 0);
          M_a_shifted: out std_logic_vector(24 downto 0);
          M_b_shifted: out std_logic_vector(24 downto 0));
end Mantissa_shifter;

architecture Behavioral of Mantissa_shifter is

begin
--Format : 24=> sign, 23=>hiddenbit, 22 downoto 0 => mantissa.
M_a_shifted(23 downto 0) <= std_logic_vector(shift_right(unsigned(M_a(23 downto 0)) , to_integer(unsigned(shift_amt_a))));
M_b_shifted(23 downto 0) <= std_logic_vector(shift_right(unsigned(M_b(23 downto 0)) , to_integer(unsigned(shift_amt_b))));
M_a_shifted(24) <= M_a(24);
M_b_shifted(24) <= M_b(24);
end Behavioral;
