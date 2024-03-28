library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_Nbit_8t1Mux is
end tb_Nbit_8t1Mux;

architecture testbench of tb_Nbit_8t1Mux is

    constant N : integer := 32;

        -- Instantiate the DUT
    component Nbit_8t1Mux
        port (
            i_select        : in std_logic_vector(3-1 downto 0);
            i_A             : in std_logic_vector(N-1 downto 0);
            i_B             : in std_logic_vector(N-1 downto 0);
            i_C             : in std_logic_vector(N-1 downto 0);
            i_D             : in std_logic_vector(N-1 downto 0);
            i_E             : in std_logic_vector(N-1 downto 0);
            i_F             : in std_logic_vector(N-1 downto 0);
            i_G             : in std_logic_vector(N-1 downto 0);
            i_H             : in std_logic_vector(N-1 downto 0);
            o_Output        : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    signal s_i_select   : std_logic_vector(3-1 downto 0);
    signal s_i_A        : std_logic_vector(N-1 downto 0);
    signal s_i_B        : std_logic_vector(N-1 downto 0);
    signal s_i_C        : std_logic_vector(N-1 downto 0);
    signal s_i_D        : std_logic_vector(N-1 downto 0);
    signal s_i_E        : std_logic_vector(N-1 downto 0);
    signal s_i_F        : std_logic_vector(N-1 downto 0);
    signal s_i_G        : std_logic_vector(N-1 downto 0);
    signal s_i_H        : std_logic_vector(N-1 downto 0);
    signal s_o_Output   : std_logic_vector(N-1 downto 0);
    
begin

    DUT : Nbit_8t1Mux
        port map (
            i_select    => s_i_select,
            i_A         => s_i_A,
            i_B         => s_i_B,
            i_C         => s_i_C,
            i_D         => s_i_D,
            i_E         => s_i_E,
            i_F         => s_i_F,
            i_G         => s_i_G,
            i_H         => s_i_H,
            o_Output    => s_o_Output
        );

    P_TEST_CASES: process
    begin
        -- setup
        s_i_A <= x"12345678";
        s_i_B <= x"87654321";
        s_i_C <= x"ABCDEF01";
        s_i_D <= x"FEDCBA09";
        s_i_E <= x"11111111";
        s_i_F <= x"22222222";
        s_i_G <= x"33333333";
        s_i_H <= x"44444444";

            
        -- Test case 1: Select input 000 (0)
        s_i_select <= "000";

        wait for 10 ns;
        -- Expected output: x"12345678" (i_A)
        
        -- Test case 2: Select input 001 (1)
        s_i_select <= "001";
        wait for 10 ns;
        -- Expected output: x"87654321" (i_B)
        
        -- Test case 3: Select input 010 (2)
        s_i_select <= "010";
        wait for 10 ns;
        -- Expected output: x"ABCDEF01" (i_C)
        
        -- Test case 4: Select input 011 (3)
        s_i_select <= "011";
        wait for 10 ns;
        -- Expected output: x"FEDCBA09" (i_D)
        
        -- Test case 5: Select input 100 (4)
        s_i_select <= "100";
        wait for 10 ns;
        -- Expected output: x"11111111" (i_E)
        
        -- Test case 6: Select input 101 (5)
        s_i_select <= "101";
        wait for 10 ns;
        -- Expected output: x"22222222" (i_F)
        
        -- Test case 7: Select input 110 (6)
        s_i_select <= "110";
        wait for 10 ns;
        -- Expected output: x"33333333" (i_G)
        
        -- Test case 8: Select input 111 (7)
        s_i_select <= "111";
        wait for 10 ns;
        -- Expected output: x"44444444" (i_H)
        
        -- End simulation
        wait;
    end process;
    
end architecture testbench;
