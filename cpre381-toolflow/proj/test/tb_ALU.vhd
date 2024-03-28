library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;  -- For numeric conversions

entity tb_ALU is
end tb_ALU;

architecture testbench of tb_ALU is

    constant N : integer := 32;  -- Width of inputs and outputs

    -- Instantiate the DUT
    component ALU
        port (
            --32bit number inputs
            i_A                 : in std_logic_vector(N-1 downto 0);
            i_B                 : in std_logic_vector(N-1 downto 0);

            --ALU operation selection line
            i_ALUout            : in std_logic_vector(3-1 downto 0);
            i_nAdd_Sub          : in std_logic;
            i_ShiftArithemtic   : in std_logic;
            i_ShiftLorR         : in std_logic;
            i_Unsigned          : in std_logic;
            i_Lui               : in std_logic;

            --Output
            o_Final             : out std_logic_vector(N-1 downto 0);
            o_Carry_Out         : out std_logic;
            o_Zero              : out std_logic;
            o_Negative          : out std_logic;
            o_Overflow          : out std_logic
        );
    end component;


    -- Signals for the ALU inputs
    signal s_i_A, s_i_B : std_logic_vector(N-1 downto 0);
    signal s_i_ALUout : std_logic_vector(3-1 downto 0);
    signal s_i_nAdd_Sub, s_i_ShiftArithemtic, s_i_ShiftLorR, s_i_Unsigned, s_i_Lui : std_logic;

    -- Signals for the ALU outputs
    signal s_o_Final : std_logic_vector(N-1 downto 0);
    signal s_o_Carry_Out, s_o_Zero, s_o_Negative, s_o_Overflow : std_logic;

begin

    -- Instantiate the ALU
    DUT: ALU
        generic map (N => N)
        port map (
            i_A => s_i_A,
            i_B => s_i_B,
            i_ALUout => s_i_ALUout,
            i_nAdd_Sub => s_i_nAdd_Sub,
            i_ShiftArithemtic => s_i_ShiftArithemtic,
            i_ShiftLorR => s_i_ShiftLorR,
            i_Unsigned => s_i_Unsigned,
            i_Lui => s_i_Lui,
            o_Final => s_o_Final,
            o_Carry_Out => s_o_Carry_Out,
            o_Zero => s_o_Zero,
            o_Negative => s_o_Negative,
            o_Overflow => s_o_Overflow
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Test case 1: Addition
        s_i_A <= std_logic_vector(to_unsigned(10, N));
        s_i_B <= std_logic_vector(to_unsigned(20, N));
        s_i_ALUout <= "010";  -- Add operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';
        s_i_ShiftLorR <= '0';
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 2: Subtraction
        s_i_A <= std_logic_vector(to_unsigned(30, N));
        s_i_B <= std_logic_vector(to_unsigned(15, N));
        s_i_ALUout <= "011";  -- Subtract operation
        s_i_nAdd_Sub <= '1';
        s_i_ShiftArithemtic <= '0';
        s_i_ShiftLorR <= '0';
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 3: Bitwise AND
        s_i_A <= std_logic_vector(to_unsigned(5, N));
        s_i_B <= std_logic_vector(to_unsigned(12, N));
        s_i_ALUout <= "000";  -- AND operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';
        s_i_ShiftLorR <= '0';
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 4: Bitwise OR
        s_i_A <= std_logic_vector(to_unsigned(8, N));
        s_i_B <= std_logic_vector(to_unsigned(3, N));
        s_i_ALUout <= "001";  -- OR operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';
        s_i_ShiftLorR <= '0';
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 5: Bitwise XOR
        s_i_A <= std_logic_vector(to_unsigned(15, N));
        s_i_B <= std_logic_vector(to_unsigned(7, N));
        s_i_ALUout <= "100";  -- XOR operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';
        s_i_ShiftLorR <= '0';
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 6: NOR
        s_i_A <= std_logic_vector(to_unsigned(3, N));
        s_i_B <= std_logic_vector(to_unsigned(7, N));
        s_i_ALUout <= "101";  -- NOR operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';
        s_i_ShiftLorR <= '0';
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 7: Shift Left Logical
        s_i_A <= std_logic_vector(to_unsigned(4, N));
        s_i_B <= std_logic_vector(to_unsigned(2, N));  -- Shift amount
        s_i_ALUout <= "110";  -- Shift  operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';  -- Shift logical
        s_i_ShiftLorR <= '1';  -- Shift left
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 8: Shift Right Logical
        s_i_A <= std_logic_vector(to_unsigned(16, N));
        s_i_B <= std_logic_vector(to_unsigned(2, N));  -- Shift amount
        s_i_ALUout <= "110";  -- Shift  operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';  -- Shift logical
        s_i_ShiftLorR <= '0';  -- Shift right
        s_i_Unsigned <= '1';
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 9: Shift right Arithemtic 
        s_i_A <= std_logic_vector(to_unsigned(4, N));
        s_i_B <= std_logic_vector(to_unsigned(3, N));  -- Shift amount
        s_i_ALUout <= "110";  -- Shift  operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '1';  -- Shift arithmetic
        s_i_ShiftLorR <= '0';  -- Shift right
        s_i_Unsigned <= '1'; 
        s_i_Lui <= '0';
        wait for 10 ns;

        -- Test case 10: Load Upper Immediate (LUI)
        s_i_A <= (others => '0');  -- All zeros
        s_i_B <= std_logic_vector(to_unsigned(25, N));  -- Immediate value
        s_i_ALUout <= "010";  -- Add operation
        s_i_nAdd_Sub <= '0';
        s_i_ShiftArithemtic <= '0';
        s_i_ShiftLorR <= '0';
        s_i_Unsigned <= '1';
        s_i_Lui <= '1';  -- LUI operation
        wait for 10 ns;

        -- Test case 11: Addition without overflow (signed input)
        s_i_A <= "01111111111111111111111111111110";  -- 2^31 - 2
        s_i_B <= "00000000000000000000000000000001";  -- 1
        s_i_ALUout <= "010";  
        s_i_nAdd_Sub <= '0';  -- Addition operation
        s_i_Unsigned <= '1';  -- Signed input
        s_i_Lui <= '0';
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Final: 2^31 - 2 + 1 = 2^31 - 1 (No overflow)

        -- Test case 12: Addition with overflow (signed input)
        s_i_A <= "01111111111111111111111111111111";  -- Max positive value
        s_i_B <= "00000000000000000000000000000001";  -- 1
        s_i_ALUout <= "010"; 
        s_i_nAdd_Sub <= '0';  -- Addition operation
        s_i_Unsigned <= '1';  -- Signed input
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Final: 2^31 - 1 + 1 = 2^31 (Overflow)

        -- Test case 13: Addition without overflow (unsigned input)
        s_i_A <= "01111111111111111111111111111110";  -- 2^31 - 2
        s_i_B <= "00000000000000000000000000000001";  -- 1
        s_i_ALUout <= "010"; 
        s_i_nAdd_Sub <= '0';  -- Addition operation
        s_i_Unsigned <= '0';  -- Unsigned input
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Final: 2^31 - 2 + 1 = 2^31 - 1 (No overflow)

        -- Test case 14: Addition with overflow (unsigned input)
        s_i_A <= "01111111111111111111111111111111";  -- Max positive value
        s_i_B <= "00000000000000000000000000000001";  -- 1
        s_i_ALUout <= "010"; 
        s_i_nAdd_Sub <= '0';  -- Addition operation
        s_i_Unsigned <= '0';  -- Unsigned input
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Final: 2^31 - 1 + 1 = 2^31 (Overflow)

        -- Test case 15: SLT - A less than B (signed input)
        s_i_A <= "11111111111111111111111111111110";  -- -2
        s_i_B <= "11111111111111111111111111111111";  -- -1
        s_i_ALUout <= "111"; 
        s_i_nAdd_Sub <= '1';  -- Subtraction operation (to test SLT)
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Negative: -2 is less than -1, so o_Negative should be '1'

        -- Test case 16: SLT - A greater than B (signed input)
        s_i_A <= "11111111111111111111111111111111";  -- -1
        s_i_B <= "11111111111111111111111111111110";  -- -2
        s_i_ALUout <= "111"; 
        s_i_nAdd_Sub <= '1';  -- Subtraction operation (to test SLT)
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Negative: -1 is greater than -2, so o_Negative should be '0'

        -- Test case 17: SLT - A less than B (unsigned input)
        s_i_A <= "01111111111111111111111111111110";  -- 2^31 - 2
        s_i_B <= "01111111111111111111111111111111";  -- 2^31 - 1
        s_i_ALUout <= "111"; 
        s_i_nAdd_Sub <= '1';  -- Subtraction operation (to test SLT)
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Negative: 2^31 - 2 is less than 2^31 - 1, so o_Negative should be '1'

        -- Test case 18: SLT - A greater than B (unsigned input)
        s_i_A <= "01111111111111111111111111111111";  -- 2^31 - 1
        s_i_B <= "01111111111111111111111111111110";  -- 2^31 - 2
        s_i_ALUout <= "111"; 
        s_i_nAdd_Sub <= '1';  -- Subtraction operation (to test SLT)
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Negative: 2^31 - 1 is greater than 2^31 - 2, so o_Negative should be '0'

        -- Test case 19: Zero output - A equals B
        s_i_A <= "00000000000000000000000000000001";  -- 1
        s_i_B <= "00000000000000000000000000000001";  -- 1
        s_i_ALUout <= "011"; 
        s_i_nAdd_Sub <= '1';
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Zero: 1 equals 1, so o_Zero should be '1'

        -- Test case 20: Zero output - A not equals B
        s_i_A <= "00000000000000000000000000000001";  -- 1
        s_i_B <= "00000000000000000000000000000010";  -- 2
        s_i_ALUout <= "011"; 
        s_i_nAdd_Sub <= '1';
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Zero: 1 not equals 2, so o_Zero should be '0'

        -- Test case 21: Zero output - A equals 0
        s_i_A <= "00000000000000000000000000000000";  -- 0
        s_i_B <= "00000000000000000000000000000001";  -- 1
        s_i_ALUout <= "011"; 
        s_i_nAdd_Sub <= '1';
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Zero: 0 equals 1, so o_Zero should be '0'

        -- Test case 22: Zero output - B equals 0
        s_i_A <= "00000000000000000000000000000001";  -- 1
        s_i_B <= "00000000000000000000000000000000";  -- 0
        s_i_ALUout <= "010"; 
        s_i_nAdd_Sub <= '0';
        wait for 10 ns;  -- Adjust delay as needed
        -- Expected Zero: 1 equals 0, so o_Zero should be '0'




        -- Add more test cases as needed...

        wait;
    end process stimulus;

end testbench;