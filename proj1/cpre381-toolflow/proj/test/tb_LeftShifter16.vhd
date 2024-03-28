library IEEE;
use IEEE.std_logic_1164.all;

entity tb_LeftShifter16 is
end entity tb_LeftShifter16;

architecture testbench of tb_LeftShifter16 is
    
    -- Instantiate the DUT
    component LeftShifter16
        port (
            input_number : in std_logic_vector(31 downto 0);
            shifted_number: out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals
    signal input_number : std_logic_vector(31 downto 0);
    signal shifted_number: std_logic_vector(31 downto 0);

begin

    -- Instantiate the DUT
    DUT: LeftShifter16
    port map (
        input_number    => input_number,
        shifted_number   => shifted_number
    );

    P_TEST_CASES: process
    begin
        -- Initialize input
        input_number <= (others => '0');
        wait for 10 ns;

        input_number <= "11111110000000000000000100010001";
        wait for 10 ns;
         
        -- Stimulus: change input to a non-zero value
        input_number <= "00000000000000000000000000000011";
        wait for 10 ns;

        -- Stimulus: change input to a non-zero value
        input_number <= "11111111111111111111111111111111";
        wait for 10 ns;
        
        -- Stimulus: change input to a non-zero value again
        input_number <= "11000000000000001000000000000100";
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;

end architecture testbench;
