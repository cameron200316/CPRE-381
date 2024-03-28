library IEEE;
use IEEE.std_logic_1164.all;

entity tb_NegativeChecker is
end entity tb_NegativeChecker;

architecture testbench of tb_NegativeChecker is
    
    -- Instantiate the DUT
    component NegativeChecker
        port (
            input_number : in std_logic_vector(31 downto 0);
            output_number: out std_logic_vector(31 downto 0);
            is_negative      : out std_logic
        );
    end component;

    -- Signals
    signal input_number : std_logic_vector(31 downto 0);
    signal output_number: std_logic_vector(31 downto 0);
    signal is_negative      : std_logic;

begin

    -- Instantiate the DUT
    DUT: NegativeChecker
    port map (
        input_number    => input_number,
        output_number   => output_number,
        is_negative      => is_negative
    );

    P_TEST_CASES: process
    begin
        -- Initialize input
        input_number <= (others => '0');
        wait for 10 ns;

        input_number <= "11111110000000000000000000000000";
        wait for 10 ns;
         
        -- Stimulus: change input to a non-zero value
        input_number <= "00000000000000000000000000000010";
        wait for 10 ns;
        
        -- Stimulus: change input to all zeros
        input_number <= (others => '0');
        wait for 10 ns;
        
        -- Stimulus: change input to a non-zero value again
        input_number <= "11000000000000000000000000000100";
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;

end architecture testbench;
