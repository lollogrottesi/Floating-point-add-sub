----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 09:09:32
-- Design Name: 
-- Module Name: normalization_Tb - Behavioral
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

entity normalization_Tb is
--  Port ( );
end normalization_Tb;

architecture Behavioral of normalization_Tb is
component postnormalization_unit is
   port ( E: in std_logic_vector(7 downto 0);
          M: in std_logic_vector(22 downto 0);--Sign bit is apart.
          OMZ: in std_logic;
          norma_M: out std_logic_vector(22 downto 0);
          norma_E: out std_logic_vector(7 downto 0));
end component;


signal E, norma_E: std_logic_vector (7 downto 0);
signal M, norma_M: std_logic_vector(22 downto 0);
signal tmp_M : std_logic_vector(22 downto 0);
signal OMZ: std_logic;

begin
dut : postnormalization_unit port map(E, M, OMZ, norma_M, norma_E);

    process
    begin
        E <= "00000111";
        M <= (others =>'0');
        OMZ <= '1';
        wait for 10 ns;
        OMZ <= '0';
        M <= (0 => '1', others =>'0');
        tmp_M <= (0 => '1', others =>'0');
        wait for 10 ns;
        assert norma_M(22) = '1' report "Non normalized mantissa";
        
loop_tb:        
        for i in 1 to 22 loop
            M <= std_logic_vector(shift_left(unsigned(tmp_M), i));
            wait for 10 ns;
            assert norma_M(22) = '1' report "Non normalized mantissa";
        end loop loop_tb; 
        
        wait;
    end process;

end Behavioral;
