library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender is
    port (
        i_switch         : in  std_logic;
        i_input          : in  std_logic_vector(16-1 downto 0);
        o_output         : out std_logic_vector(32-1 downto 0)
    );
end entity extender;

architecture behavior of extender is
begin
    process(i_input, i_switch)
    begin
        if (i_switch = '1') then
            if (i_input(15) = '1') then
                o_output <= "1111111111111111" & i_input;
            else
                o_output <= "0000000000000000" & i_input;
            end if;
        else
            o_output <= "0000000000000000" & i_input;
        end if;
    end process;
end behavior;