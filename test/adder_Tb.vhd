----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 09:34:25
-- Design Name: 
-- Module Name: adder_Tb - Behavioral
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

entity adder_Tb is
--  Port ( );
end adder_Tb;

architecture Behavioral of adder_Tb is
component c_l_addr IS
    generic (N: integer:= 25);
    PORT
        (
         x_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
END component;
constant N: integer := 8;
signal x, y, sum: std_logic_vector(N-1 downto 0);
signal a_s, overflow, underflow, omz: std_logic;
--signal cin,cout : std_logic;
begin

dut: c_l_addr generic map (N) port map (x, y, a_s, sum, overflow);
    process
    begin
        a_s <= '0';
        x <= std_logic_vector(signed(to_unsigned(5, N)));
        y <= std_logic_vector(signed(to_unsigned(2, N)));
        wait for 10 ns;
        a_s <= '1';
        x <= std_logic_vector(signed(to_unsigned(5, N)));
        y <= std_logic_vector(signed(to_unsigned(2, N)));
        wait for 10 ns;
        x <= std_logic_vector(signed(to_unsigned(5, N)));
        y <= std_logic_vector(signed(to_unsigned(3, N)));
        wait for 10 ns;
        a_s <= '0';
        x <= (others=>'1');
        y <= (0=>'1', others => '0');
        wait for 10 ns;
        a_s <= '1';
        x <= std_logic_vector(signed(to_unsigned(8, N)));
        y <= std_logic_vector(signed(to_unsigned(8, N)));
        wait;
    end process;

end Behavioral;
