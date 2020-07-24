----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 10:52:36
-- Design Name: 
-- Module Name: IEE_754_floating_point_TB - Behavioral
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

entity IEE_754_floating_point_TB is
--  Port ( );
end IEE_754_floating_point_TB;

architecture Behavioral of IEE_754_floating_point_TB is
component IEEE_754_floating_add_sub is
    port (FP_a: in std_logic_vector(31 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(31 downto 0);
          add_sub: in std_logic;
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic;
          FP_z: out std_logic_vector(31 downto 0));
end component;

signal a, b, z: std_logic_vector(31 downto 0);
signal add_sub, overflow, underflow, OMZ: std_logic;
begin
dut : IEEE_754_floating_add_sub port map (a, b, add_sub, overflow, underflow, OMZ, z);
    process
    begin
        --Test addition.
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
        b <= x"00000000";
        a <= x"40000000";
        add_sub <= '1';
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
        wait;
    end process;
end Behavioral;
