----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.08.2020 15:19:45
-- Design Name: 
-- Module Name: IEEE_754_CMP_TB - Behavioral
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

entity IEEE_754_CMP_TB is
--  Port ( );
end IEEE_754_CMP_TB;

architecture Behavioral of IEEE_754_CMP_TB is
component IEEE_754_Add_Cmp_unit is
    port (FP_a: in std_logic_vector(31 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(31 downto 0);
          add_subAndCmp: in std_logic;
          cmp_ctrl:      in std_logic_vector(2 downto 0);   --Select one compare operation.
          cmp_out:       out std_logic;                     --Result of the selected comparison.
          FP_z: out std_logic_vector(31 downto 0));
end component;


signal a, b, z: std_logic_vector(31 downto 0);
signal add_sub, overflow, underflow, OMZ, cmp_out: std_logic;
signal cmp_ctrl: std_logic_vector(2 downto 0);
signal A_eq_B, A_not_equal_B: std_logic;
signal A_gr_eq_B, A_gr_B: std_logic;
signal A_low_B, A_low_equal_B: std_logic;
begin
dut : IEEE_754_Add_Cmp_unit port map (a, b, add_sub, cmp_ctrl, cmp_out, z);
    process
    begin
--        --Test addition.
        cmp_ctrl <= "111"; 
        b <= x"40400000";
        a <= x"40000000";
        add_sub <= '0';
        wait for 10 ns;
        add_sub <= '0';
        b <= x"406ccccd";
        a <= x"400ccccd";
        wait for 10 ns;  
        b <= x"408e147b";
        a <= x"3f99999a";
        wait for 10 ns;
        b <= x"3f000000";
        a <= x"408e147b";
        wait for 10 ns;
        b <= x"3f000000";
        a <= x"3f000000";
        wait for 10 ns;
        b <= x"400eb852";
        a <= x"40eccccd";
        --Test differences.
        wait for 10 ns;
        cmp_ctrl <= "000"; 
        b <= x"00000000";
        a <= x"40000000";
        add_sub <= '1';
        wait for 10 ns;
        cmp_ctrl <= "001"; 
        b <= x"406ccccd";
        a <= x"400ccccd";
        wait for 10 ns;  
        cmp_ctrl <= "011"; 
        b <= x"408e147b";
        a <= x"3f99999a";
        wait for 10 ns;
        cmp_ctrl <= "010"; 
        b <= x"3f000000";
        a <= x"408e147b";
        wait for 10 ns;
        cmp_ctrl <= "101"; 
        b <= x"3f000000";
        a <= x"3f000000";
        wait for 10 ns;
        cmp_ctrl <= "100"; 
        b <= x"400eb852";
        a <= x"40eccccd";
        wait for 10 ns;
        b <= x"40400000";
        a <= x"40000000";
        wait for 10 ns;
        b <= x"406ccccd";
        a <= x"400ccccd";
        wait for 10 ns;  
        b <= x"408e147b";
        a <= x"3f99999a";
        wait for 10 ns;
        b <= x"3f000000";
        a <= x"408e147b";
        wait for 10 ns;
        b <= x"3f000000";
        a <= x"3f000000";
        wait for 10 ns;
        b <= x"400eb852";
        a <= x"40eccccd";
        wait for 10 ns;
        b <= x"00000000";
        a <= x"40000000";
        wait for 10 ns;
        a <= x"bfc00000";
        b <= x"40400000";
        wait for 10 ns;
        wait for 10 ns;
        wait for 10 ns;
        a <= x"40400000";
        b <= x"bfc00000";
        wait for 10 ns;
        a <= x"c0cb3333";
        b <= x"c00ccccd";
        wait for 10 ns;
        a <= x"bfe66666";
        b <= x"bfc00000";
        wait;
    end process;
end Behavioral;
