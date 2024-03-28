-------------------------------------------------------------------------
-- Mason Kotlarz
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- ZeroChecker.vhd


library IEEE;
use IEEE.std_logic_1164.all;

entity ZeroChecker is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        input_number      : in std_logic_vector(N-1 downto 0);
        is_zero           : out std_logic
    );
end ZeroChecker;

architecture structural of ZeroChecker is

    constant all_zero : std_logic_vector(N-1 downto 0) := (others => '0');

begin

    --  is_zero <= '1' when input_number = (others => '0') else '0';
    is_zero <= '1' when input_number = all_zero else '0';

end structural;