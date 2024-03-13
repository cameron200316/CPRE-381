library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ZeroChecker is
end entity tb_ZeroChecker;

architecture testbench of tb_ZeroChecker is
    
    -- Instantiate the DUT
    component ZeroChecker
        port (
            input_number : in std_logic_vector(31 downto 0);
            is_zero      : out std_logic
        );
    end component;

    -- Signals
    signal input_number : std_logic_vector(31 downto 0);
    signal is_zero      : std_logic;

begin

    -- Instantiate the DUT
    DUT: ZeroChecker
    port map (
        input_number => input_number,
        is_zero      => is_zero
    );

    P_TEST_CASES: process
    begin
        -- Initialize input
        input_number <= (others => '0');
        
        -- Wait for some time to observe the output
        wait for 10 ns;
        
        -- Stimulus: change input to a non-zero value
        input_number <= "00000000000000000000000000000001";
        wait for 10 ns;
        
        -- Stimulus: change input to all zeros
        input_number <= (others => '0');
        wait for 10 ns;
        
        -- Stimulus: change input to a non-zero value again
        input_number <= "00000000000000000000000000000100";
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;

end architecture testbench;
