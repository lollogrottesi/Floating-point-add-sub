----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2020 14:46:52
-- Design Name: 
-- Module Name: Align_Exponent_TB - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Align_Exponent_TB is
--  Port ( );
end Align_Exponent_TB;

architecture Behavioral of Align_Exponent_TB is

component Alignment_compare_E is
    port (E_a: in std_logic_vector(7 downto 0);
          E_b: in std_logic_vector(7 downto 0);
          shift_M_a: out std_logic_vector(7 downto 0);
          shift_M_b: out std_logic_vector(7 downto 0);
          max_E: out std_logic_vector(7 downto 0));
end component;

component Mantissa_shifter is
    port (M_a: in std_logic_vector(23 downto 0);
          M_b: in std_logic_vector(23 downto 0);
          shift_amt_a: in std_logic_vector(7 downto 0);
          shift_amt_b: in std_logic_vector(7 downto 0);
          M_a_shifted: out std_logic_vector(23 downto 0);
          M_b_shifted: out std_logic_vector(23 downto 0));
end component;

component postnormalization_unit is
   port ( E: in std_logic_vector(7 downto 0);
          M: in std_logic_vector(22 downto 0);--Sign bit is apart.
          OMZ: in std_logic;
          norma_M: out std_logic_vector(22 downto 0);
          norma_E: out std_logic_vector(7 downto 0));
end component;

--signal E_a, E_b, shift_M_a, shift_M_b, max_E: std_logic_vector (7 downto 0);
--signal M_a, M_b, M_a_shifted, M_b_shifted: std_logic_vector(22 downto 0);
--signal shift_amt_a, shift_amt_b : std_logic_vector(7 downto 0);
signal E, norma_E: std_logic_vector (7 downto 0);
signal M, norma_M: std_logic_vector(22 downto 0);
signal OMZ: std_logic;


begin
--dut : Alignment_compare_E port map(E_a, E_b, shift_M_a, shift_M_b, max_E);
--dut: Mantissa_shifter port map (M_a, M_b, shift_amt_a, shift_amt_b, M_a_shifted, M_b_shifted);
dut : postnormalization_unit port map(E, M, OMZ, norma_M, norma_E);

    process
    begin
        E <= "00000111";
        M <= "00010000011000000000001";
        OMZ <= '0';
        wait;
    end process;    
--    process
--    begin
--        M_a <= "100000000000000100000000";
--        M_b <= "100000000100000100000000";
--        shift_amt_a <= "00000001";
--        shift_amt_b <= "00001000";
--        wait;
--    end process;

--    process
--    begin
--        E_a <= "00000001";
--        E_b <= "00000001";
--        wait for 10 ns;
--        E_a <= "00000010";
--        E_b <= "00000000";
--        wait for 10 ns;
--        E_a <= "00000011";
--        E_b <= "00000100";
--        wait;
--    end process;
end Behavioral;
