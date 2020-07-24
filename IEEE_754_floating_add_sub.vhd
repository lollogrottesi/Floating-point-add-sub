----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 10:25:44
-- Design Name: 
-- Module Name: IEEE_754_floating_add_sub - Structural
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

entity IEEE_754_floating_add_sub is
    port (FP_a: in std_logic_vector(31 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(31 downto 0);
          add_sub: in std_logic;
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic;
          FP_z: out std_logic_vector(31 downto 0));
end IEEE_754_floating_add_sub;

architecture Structural of IEEE_754_floating_add_sub is

component Alignment_compare_E is
    port (E_a: in std_logic_vector(7 downto 0); --E is supposed to be biased.
          E_b: in std_logic_vector(7 downto 0);
          shift_M_a: out std_logic_vector(7 downto 0);
          shift_M_b: out std_logic_vector(7 downto 0);
          max_E: out std_logic_vector(7 downto 0));
end component;

component mantissa_add_sub is
    --The sum is perfomed in 25 bits, 1 bit sign + implicit 1 before mantissa + 23 bit matissa = 25 bit.
    --The rapresentation is sign magnitude so conversion to two's complement could be necessary.
    port (M_a: in std_logic_vector(24 downto 0);
          M_b: in std_logic_vector(24 downto 0);
          add_sub: in std_logic;
          sum_M: out std_logic_vector(24 downto 0);
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic);
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
    port (E: in std_logic_vector(7 downto 0); --E is unbiased.
          --23 bit mantissa + 1 hidden bit + 1 carry out = 25 bit.
          M: in std_logic_vector(24 downto 0);--Sign bit is apart.
          OMZ: in std_logic;                  --This flag is used to handle total zero mantissa.
          norma_M: out std_logic_vector(22 downto 0);
          norma_E: out std_logic_vector(7 downto 0));
end component;


signal shift_amt_a, shift_amt_b: std_logic_vector(7 downto 0);
signal max_E: std_logic_vector(7 downto 0);
signal sign_matissa_a,  sign_matissa_b: std_logic_vector(23 downto 0);
signal post_shift_ma, post_shift_mb: std_logic_vector(23 downto 0);
signal pre_computation_m_a, pre_computation_m_b: std_logic_vector (24 downto 0);
signal post_computation_m: std_logic_vector(24 downto 0);
signal prenormalization_m : std_logic_vector(24 downto 0);

--Debug signals.
signal pre_normalization: std_logic_vector(31 downto 0);
signal prenormalization_mantissa: std_logic_vector(24 downto 0);
signal tmp_OMZ, tmp_carry: std_logic;
begin

--Build the signed matissa.(-1)^S*|M|.
sign_matissa_a <= FP_a(31)&FP_a(22 downto 0);
sign_matissa_b <= FP_b(31)&FP_b(22 downto 0);

--Find the amount of shifting in order to align mantissa and exponents.
alignment_amt_stage: Alignment_compare_E port map (FP_a(30 downto 23), FP_b(30 downto 23), shift_amt_a, shift_amt_b, max_E);
--Shift the mantissa, consider signed mantissa.
alignment_shift_stage: Mantissa_shifter port map(sign_matissa_a, sign_matissa_b, shift_amt_a, shift_amt_b, post_shift_ma, post_shift_mb);
--Perform addition/subctraction.
computation_stage: mantissa_add_sub port map(pre_computation_m_a, pre_computation_m_b, add_sub, post_computation_m, tmp_carry, underflow, tmp_OMZ);
--Normalization.
normalization_stage: postnormalization_unit port map(max_E, prenormalization_m, tmp_OMZ, FP_z(22 downto 0), FP_z(30 downto 23));

----------------------Adjust form from shift stage to add/sub stage-------------------------------------------------------------------------

--Create the pre computation Mantissa : 24 => sign, 23 => IEE 754 hidden bit, 22 downto 0 => mantissa value.

pre_computation_m_a(24) <= post_shift_ma(23);                   --Attach sign from shift stage.
pre_computation_m_a(22 downto 0) <= post_shift_ma(22 downto 0); --Attach shifted mantissa.
pre_computation_m_b(24) <= post_shift_mb(23);
pre_computation_m_b(22 downto 0) <= post_shift_mb(22 downto 0);

--Attach the hidden bit (24th bit) follwing the IEEE 754 standard.
pre_computation_m_a(23) <= '0' when FP_a(30 downto 23) = "00000000" else 
                           '1';
pre_computation_m_b(23) <= '0' when FP_b(30 downto 23) = "00000000" else 
                           '1';
--------------------------------------------------------------------------------------------------------------------------------------------

----------------------Adjust form from add/sub to normalization stage-----------------------------------------------------------------------
prenormalization_m (23 downto 0) <= post_computation_m(23 downto 0); --Includes the hidden bit.
prenormalization_m (24) <= tmp_carry;                                --Attach carry out bit.
--------------------------------------------------------------------------------------------------------------------------------------------
--Debug signal.
pre_normalization <= post_computation_m(23)&max_E&post_computation_m(22 downto 0);
--Add sign to final result.
FP_z(31) <= post_computation_m(23);
--Flags.
OMZ <= tmp_OMZ;
overflow <= tmp_carry;

end Structural;
