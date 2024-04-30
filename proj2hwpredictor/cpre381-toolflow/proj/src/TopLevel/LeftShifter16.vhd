-- LeftShifter16.vhd

library IEEE;
use ieee.numeric_std.all; 
use IEEE.std_logic_1164.all;

entity LeftShifter16 is
    generic (N : integer := 32);
    port (
        input_number        : in std_logic_vector(N-1 downto 0);
        shifted_number      : out std_logic_vector(N-1 downto 0)
    );
end entity LeftShifter16;

architecture Behavioral of LeftShifter16 is

begin
   shifted_number <= std_logic_vector(shift_left(unsigned(input_number), 16));
end Behavioral;