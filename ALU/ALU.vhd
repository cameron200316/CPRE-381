-- ALU.vhd


library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is

    generic(N : integer := 32); 

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

end ALU;

architecture structural of ALU is

    -- Component Declaration

    -- 8t1Mux
    component Nbit_8t1Mux is
        port(
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

    -- And
    component Nbit_andg2 is
        port(
            i_A             : in std_logic_vector(N-1 downto 0);
            i_B             : in std_logic_vector(N-1 downto 0);
            o_O             : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    -- Or
    component Nbit_org2 is
        port(
            i_A             : in std_logic_vector(N-1 downto 0);
            i_B             : in std_logic_vector(N-1 downto 0);
            o_O             : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Adder/Subtractor
    component Nbit_AddSub is
        port(
            i_A             : in std_logic_vector(N-1 downto 0);
            i_B             : in std_logic_vector(N-1 downto 0);
            i_nAdd_Sub      : in std_logic;
            o_Sum           : out std_logic_vector(N-1 downto 0);
            o_Carry_Out     : out std_logic;
            o_Overflow      : out std_logic
        );
    end component;
    
    -- Xor
    component Nbit_xorg2 is
        port(
            i_A 		    : in std_logic_vector(N-1 downto 0);
            i_B             : in std_logic_vector(N-1 downto 0);
            o_O             : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Nor (not + or)
    component Complementor is
        port(
            i_A 		    : in std_logic_vector(N-1 downto 0);
            o_O             : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Barrel Shifter
    component BarrelShifter is
        port(
            i_signed        : in std_logic;
            i_left	        : in std_logic;
            i_WD            : in std_logic_vector(N-1 downto 0);
            i_SHAMT         : in std_logic_vector(4 downto 0);
            o_numShifted    : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Negative Checker
    component NegativeChecker is
        port(
            input_number    : in std_logic_vector(N-1 downto 0);
            output_number   : out std_logic_vector(N-1 downto 0);
            is_negative     : out std_logic
        );
    end component;

    -- Zero Checker
    component ZeroChecker is
        port(
            input_number    : in std_logic_vector(N-1 downto 0);
            is_zero         : out std_logic
        );
    end component;

    -- And (1 bit)
    component andg2 is
        port(
            i_A             : in std_logic;
            i_B             : in std_logic;
            o_F             : out std_logic
        );
    end component;

    -- Left Shift 16
    component LeftShifter16 is
        port(
            input_number    : in std_logic_vector(N-1 downto 0);
            shifted_number  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- 2t1Mux
    component mux2t1_N is
        port(
            i_S             : in std_logic;
            i_D0            : in std_logic_vector(N-1 downto 0);
            i_D1            : in std_logic_vector(N-1 downto 0);
            o_O             : out std_logic_vector(N-1 downto 0)
        );
    end component;


    -- Signal Declaration

    -- 8t1 Mux Inputs                                                   -- ALUOut       Operation
    Signal s_And_OperationOutput    : std_logic_vector(N-1 downto 0);   -- 000          and
    Signal s_Or_OperationOutput     : std_logic_vector(N-1 downto 0);   -- 001          or
    Signal s_AddSub_OperationOutput : std_logic_vector(N-1 downto 0);   -- 010 & 011    add & sub
    Signal s_Xor_OperationOutput    : std_logic_vector(N-1 downto 0);   -- 100          xor
    Signal s_Nor_OperationOutput    : std_logic_vector(N-1 downto 0);   -- 101          nor
    Signal s_Shift_OperationOutput  : std_logic_vector(N-1 downto 0);   -- 110          shift
    Signal s_Slt_OperationOutput    : std_logic_vector(N-1 downto 0);   -- 111          slt

    --Addition Signal lines
    Signal s_Or_to_Not_Output       : std_logic_vector(N-1 downto 0);
    Signal s_Mux_Output             : std_logic_vector(N-1 downto 0);
    Signal s_LeftShift16_Output     : std_logic_vector(N-1 downto 0);
    Signal s_overflow               : std_logic;

begin

    -- Component Instantiation

    -- 8t1Mux
    muxxx : Nbit_8t1Mux
        port map (
            i_select        => i_ALUout,
            i_A             => s_And_OperationOutput,
            i_B             => s_Or_OperationOutput,
            i_C             => s_AddSub_OperationOutput,
            i_D             => s_AddSub_OperationOutput,
            i_E             => s_Xor_OperationOutput,
            i_F             => s_Nor_OperationOutput,
            i_G             => s_Shift_OperationOutput,
            i_H             => s_Slt_OperationOutput,
            o_Output        => s_Mux_Output
        );

    -- And
    andgateoperation : Nbit_andg2
        port map (
            i_A             => i_A,
            i_B             => i_B,
            o_O             => s_And_OperationOutput
        );
    
    -- Or
    orgateoperation : Nbit_org2 
        port map (
            i_A             => i_A,
            i_B             => i_B,
            o_O             => s_Or_OperationOutput
        );

    -- Adder/Subtractor
    adder_subtractor : Nbit_AddSub 
        port map (
            i_A             => i_A,
            i_B             => i_B,
            i_nAdd_Sub      => i_nAdd_Sub,
            o_Sum           => s_AddSub_OperationOutput,
            o_Carry_Out     => o_Carry_Out,
            o_Overflow      => s_overflow
        );
    
    -- Xor
    xorgate : Nbit_xorg2 
        port map (
            i_A 		    => i_A,
            i_B             => i_B,
            o_O             => s_Xor_OperationOutput
        );

    -- Nor (not + or)
    -- Or
    orgate_noroperation : Nbit_org2 
        port map (
            i_A             => i_A,
            i_B             => i_B,
            o_O             => s_Or_to_Not_Output
        );

    -- Inverter 
    Nbit_Inverter : Complementor
        port map ( 
            i_A             => s_Or_to_Not_Output,
            o_O             => s_Nor_OperationOutput
        );

    -- Barrel Shifter
    Shifter : BarrelShifter 
        port map (
            i_signed        => i_ShiftArithemtic,
            i_left	        => i_ShiftLorR,
            i_WD            => i_A,
            i_SHAMT         => i_B(5-1 downto 0),
            o_numShifted    => s_Shift_OperationOutput
        );

    -- Negative Checker
    sltchecker : NegativeChecker
        port map (
            input_number    => s_AddSub_OperationOutput,
            output_number   => s_Slt_OperationOutput,
            is_negative     => o_Negative
        );

    -- Zero Checker
    branchchecker : ZeroChecker 
        port map (
            input_number    => s_AddSub_OperationOutput,
            is_zero         => o_Zero
        );

    -- And (1 bit)
    overflowchecker : andg2 
        port map (
            i_A             => i_Unsigned,
            i_B             => s_overflow, 
            o_F             => o_Overflow
        );

    -- Left Shift 16
    luioperation : LeftShifter16
        port map (
            input_number    => s_Mux_Output,
            shifted_number  => s_LeftShift16_Output
        );

    -- 2t1Mux
    luiselection : mux2t1_N 
        port map (
            i_S             => i_Lui,
            i_D0            => s_Mux_Output,
            i_D1            => s_LeftShift16_Output,
            o_O             => o_Final
        );
  
end structural;