-- NegativeChecker.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity NegativeChecker is
    generic (N : integer := 32);
    port (
        input_number        : in std_logic_vector(N-1 downto 0);
        output_number       : out std_logic_vector(N-1 downto 0);
        is_negative         : out std_logic
    );
end entity NegativeChecker;

architecture Behavioral of NegativeChecker is

begin

   -- Check if the MSB (most significant bit) is set, indicating a negative number
   process(input_number)
   begin
      if input_number(N-1) = '1' then
         output_number <= x"00000001";
         is_negative   <= '1';
      else
         output_number <= x"00000000";
         is_negative   <= '0';
      end if;
   end process;

end Behavioral;