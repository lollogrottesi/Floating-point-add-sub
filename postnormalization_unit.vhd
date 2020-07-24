----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2020 18:53:43
-- Design Name: 
-- Module Name: postnormalization_unit - Behavioral
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

entity postnormalization_unit is
    port (E: in std_logic_vector(7 downto 0); --E is unbiased.
          --23 bit mantissa + 1 hidden bit + 1 carry out = 25 bit.
          M: in std_logic_vector(24 downto 0);--Sign bit is apart.
          OMZ: in std_logic;                  --This flag is used to handle total zero mantissa.
          norma_M: out std_logic_vector(22 downto 0);
          norma_E: out std_logic_vector(7 downto 0));
end postnormalization_unit;

architecture Behavioral of postnormalization_unit is

type shift_matrix is array (0 to 23) of std_logic_vector(24 downto 0);
signal shift_M : shift_matrix;
signal flag_mask, right_mask: std_logic_vector(24 downto 0);
signal long_normalized_M : std_logic_vector(24 downto 0);
signal mask_index: std_logic_vector (7 downto 0);
begin

--Generate all possible shift left.
mask_shift:
    for i in 0 to 23 generate
        shift_M(i) <= std_logic_vector(shift_left(unsigned(M), i));
    end generate mask_shift;
       
 
--Check for mask that has '1' in 22 position (23 is the sign).
flag_mak: 
    for j in 23 downto 0 generate
        flag_mask(j) <=  shift_M(j)(23) and '1';
    end generate flag_mak;
    
Decoder_process:    
    process(flag_mask)
    begin
        if (flag_mask (0) = '1') then
            mask_index <= "00000000";
        elsif (flag_mask (1 downto 0) = "10") then
            mask_index <= "00000001";   
        elsif (flag_mask (2 downto 0) = "100") then
            mask_index <= "00000010";  
        elsif (flag_mask (3 downto 0) = "1000") then
            mask_index <= "00000011";  
        elsif (flag_mask (4 downto 0) = "10000") then
            mask_index <= "00000100";  
        elsif (flag_mask (5 downto 0) = "100000") then
            mask_index <= "00000101";  
        elsif (flag_mask (6 downto 0) = "1000000") then
            mask_index <= "00000110";  
        elsif (flag_mask (7 downto 0) = "10000000") then
            mask_index <= "00000111";  
        elsif (flag_mask (8 downto 0) = "100000000") then
            mask_index <= "00001000";    
        elsif (flag_mask (9 downto 0) = "1000000000") then
            mask_index <= "00001001";  
        elsif (flag_mask (10 downto 0)= "10000000000") then
            mask_index <= "00001010";    
        elsif (flag_mask (11 downto 0)= "100000000000") then
            mask_index <= "00001011"; 
        elsif (flag_mask (12 downto 0)= "1000000000000") then
            mask_index <= "00001100"; 
        elsif (flag_mask (13 downto 0)= "10000000000000") then
            mask_index <= "00001101"; 
        elsif (flag_mask (14 downto 0)= "100000000000000") then
            mask_index <= "00001110";     
        elsif (flag_mask (15 downto 0)= "1000000000000000") then
            mask_index <= "00001111";  
        elsif (flag_mask (16 downto 0)= "10000000000000000") then
            mask_index <= "00010000"; 
        elsif (flag_mask (17 downto 0)= "100000000000000000") then
            mask_index <= "00010001";     
        elsif (flag_mask (18 downto 0)= "1000000000000000000") then
            mask_index <= "00010010"; 
        elsif (flag_mask (19 downto 0)= "10000000000000000000") then
            mask_index <= "00010011"; 
        elsif (flag_mask (20 downto 0)= "100000000000000000000") then
            mask_index <= "00010100";     
        elsif (flag_mask (21 downto 0)= "1000000000000000000000") then
            mask_index <= "00010101";   
        elsif (flag_mask (22 downto 0)= "10000000000000000000000") then
            mask_index <= "00010110";   
        elsif (flag_mask (23 downto 0)= "100000000000000000000000") then
            mask_index <= "00010111"; 
        else
            mask_index <= "00000000";
        end if;
    end process;

    process(OMZ, mask_index, M, E)
    begin
        if (M(24) = '1') then
           long_normalized_M <= std_logic_vector(shift_right(unsigned(E), 1));
           norma_E <= std_logic_vector(unsigned(E) + 1);
        else
           if (OMZ = '0') then
               long_normalized_M <= M;
               norma_E <= E; 
           else
               long_normalized_M <= std_logic_vector(shift_left(unsigned(M), to_integer(unsigned(mask_index)))); 
               norma_E <= std_logic_vector(unsigned(E) - unsigned(mask_index)); 
           end if; 
        end if;
    end process;
    
--norma_E <= std_logic_vector(unsigned(E) - unsigned(mask_index))  when OMZ = '0' and M(24) = '0' else
--           E                                                     when OMZ = '0' and M(24) = '1' and mask_index = "00000000" else
--           std_logic_vector(unsigned(E) + 1)                     when OMZ = '0' and M(24) = '1' else
--           E                                                     when OMZ = '1';
            
--post_normalized_M <= std_logic_vector(shift_left(unsigned(M), to_integer(unsigned(mask_index))))  when OMZ = '0' and M(24) = '0' else
--                     M                                                                            when OMZ = '0' and M(24) = '1' and mask_index = "00000000" else
--                     std_logic_vector(shift_right(unsigned(E), 1))                                when OMZ = '0' and M(24) = '1' else
--                     M                                                                            when OMZ = '1';
                     
norma_M <= long_normalized_M(22 downto 0);--Drop last normalized 1.

end Behavioral;
