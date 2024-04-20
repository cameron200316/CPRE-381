library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_IF_ID is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_IF_ID;

architecture mixed of tb_IF_ID is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component IF_ID is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        i_CLKs        : in std_logic;
        i_Flush       : in std_logic;
        i_Stall       : in std_logic;

        i_PC4         : in std_logic_vector(N-1 downto 0);
        i_Inst        : in std_logic_vector(N-1 downto 0);
        o_PC4         : out std_logic_vector(N-1 downto 0);
        o_Inst        : out std_logic_vector(N-1 downto 0)
    );
 
end component;

component ID_EX is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        i_CLKs        : in std_logic;
        i_Flush       : in std_logic;
        i_Stall       : in std_logic; 

        i_Jump               : in std_logic;
        i_Branch             : in std_logic;
        i_BranchNE           : in std_logic;
        i_Return             : in std_logic;
        i_ALUnAddSub         : in std_logic;
        i_ALUout             : in std_logic_vector(2 downto 0);
        i_ShiftLorR          : in std_logic;
        i_ShiftArithmetic    : in std_logic;
        i_Unsigned           : in std_logic;
        i_Lui                : in std_logic;
        i_Lw                 : in std_logic;
        i_HoB                : in std_logic;
        i_Sign               : in std_logic;
        i_MemWrite           : in std_logic;
        i_MemtoReg           : in std_logic;
        i_RegWrite           : in std_logic;
        i_A        	     : in std_logic_vector(N-1 downto 0);
        i_B        	     : in std_logic_vector(N-1 downto 0);
        i_r2             : in std_logic_vector(N-1 downto 0);
        i_PC4        	     : in std_logic_vector(N-1 downto 0);
        i_Inst       	     : in std_logic_vector(N-1 downto 0);
        i_WA       	     : in std_logic_vector(4 downto 0);
        i_Link              : in std_logic;
        i_Halt               : in std_logic;
        o_Jump               : out std_logic;
        o_Branch             : out std_logic;
        o_BranchNE           : out std_logic;
        o_Return             : out std_logic;
        o_ALUnAddSub         : out std_logic;
        o_ALUout             : out std_logic_vector(2 downto 0);
        o_ShiftLorR          : out std_logic;
        o_ShiftArithmetic    : out std_logic;
        o_Unsigned           : out std_logic;
        o_Lui                : out std_logic;
        o_Lw                 : out std_logic;
        o_HoB                : out std_logic;
        o_Sign               : out std_logic;
        o_MemWrite           : out std_logic;
        o_MemtoReg           : out std_logic;
        o_RegWrite           : out std_logic;
        o_A        	     : out std_logic_vector(N-1 downto 0);
        o_B        	     : out std_logic_vector(N-1 downto 0);
        o_r2             : out std_logic_vector(N-1 downto 0);
        o_PC4        	     : out std_logic_vector(N-1 downto 0);
        o_Inst        	     : out std_logic_vector(N-1 downto 0);
        o_WA       	     : out std_logic_vector(4 downto 0);
        o_Link              : out std_logic;
        o_Halt               : out std_logic
    );
end component;

component EX_MEM is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        i_CLKs               : in std_logic;
        i_Flush                  : in std_logic;
        i_Stall                   : in std_logic;

        i_Lw                 : in std_logic;
        i_HoB                : in std_logic;
        i_Sign               : in std_logic;
        i_MemWrite           : in std_logic;
        i_MemtoReg           : in std_logic;
        i_RegWrite           : in std_logic;
        i_B        	     : in std_logic_vector(N-1 downto 0);
        i_r2             : in std_logic_vector(N-1 downto 0);
        i_Final        	     : in std_logic_vector(N-1 downto 0);
        i_PC4        	     : in std_logic_vector(N-1 downto 0);
        i_Inst       	     : in std_logic_vector(N-1 downto 0);
        i_WA       	     : in std_logic_vector(4 downto 0);
        i_Link              : in std_logic;
        i_Halt               : in std_logic;
        o_Lw                 : out std_logic;
        o_HoB                : out std_logic;
        o_Sign               : out std_logic;
        o_MemWrite           : out std_logic;
        o_MemtoReg           : out std_logic;
        o_RegWrite           : out std_logic;
        o_B        	     : out std_logic_vector(N-1 downto 0);
        o_r2             : out std_logic_vector(N-1 downto 0);
        o_Final        	     : out std_logic_vector(N-1 downto 0);
        o_PC4        	     : out std_logic_vector(N-1 downto 0);
        o_Inst        	     : out std_logic_vector(N-1 downto 0);
        o_WA       	     : out std_logic_vector(4 downto 0);
        o_Link              : out std_logic;
        o_Halt               : out std_logic
    );
 
end component;

component MEM_WB is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        i_CLKs               : in std_logic;
        i_Flush                  : in std_logic;
        i_Stall                   : in std_logic;

        i_RegWrite           : in std_logic;
        i_WD        	     : in std_logic_vector(N-1 downto 0);
        i_PC4        	     : in std_logic_vector(N-1 downto 0);
        i_Inst       	     : in std_logic_vector(N-1 downto 0);
        i_WA       	     : in std_logic_vector(4 downto 0);
        i_Link              : in std_logic;
        i_Halt               : in std_logic;
        o_RegWrite           : out std_logic;	
        o_WD        	     : out std_logic_vector(N-1 downto 0);
        o_PC4        	     : out std_logic_vector(N-1 downto 0);
        o_Inst        	     : out std_logic_vector(N-1 downto 0);
        o_WA       	     : out std_logic_vector(4 downto 0);
        o_Link              : out std_logic;
        o_Halt               : out std_logic
    );

end component;

-- Signals for the IF_ID pipeline
signal s_IF_ID_Flush      : std_logic := '0';
signal s_IF_ID_Stall      : std_logic := '0';
signal s_IF_ID_PC4        : std_logic_vector(31 downto 0) := (others => '0');
signal s_IF_ID_Inst       : std_logic_vector(31 downto 0) := (others => '0');

-- Signals for the ID_EX pipeline
signal s_ID_EX_Jump               : std_logic := '0';
signal s_ID_EX_Branch             : std_logic := '0';
signal s_ID_EX_BranchNE           : std_logic := '0';
signal s_ID_EX_Return             : std_logic := '0';
signal s_ID_EX_ALUnAddSub         : std_logic := '0';
signal s_ID_EX_ALUout             : std_logic_vector(2 downto 0) := (others => '0');
signal s_ID_EX_ShiftLorR          : std_logic := '0';
signal s_ID_EX_ShiftArithmetic    : std_logic := '0';
signal s_ID_EX_Unsigned           : std_logic := '0';
signal s_ID_EX_Lui                : std_logic := '0';
signal s_ID_EX_Lw                 : std_logic := '0';
signal s_ID_EX_HoB                : std_logic := '0';
signal s_ID_EX_Sign               : std_logic := '0';
signal s_ID_EX_MemWrite           : std_logic := '0';
signal s_ID_EX_MemtoReg           : std_logic := '0';
signal s_ID_EX_RegWrite           : std_logic := '0';
signal s_ID_EX_A                  : std_logic_vector(31 downto 0) := (others => '0');
signal s_ID_EX_B                  : std_logic_vector(31 downto 0) := (others => '0');
signal s_ID_EX_r2                 : std_logic_vector(31 downto 0) := (others => '0');
signal s_ID_EX_WA                 : std_logic_vector(4 downto 0) := (others => '0');
signal s_ID_EX_Link               : std_logic := '0';
signal s_ID_EX_Halt               : std_logic := '0';

-- Signals for the EX_MEM pipeline
signal s_EX_MEM_Lw                 : std_logic := '0';
signal s_EX_MEM_HoB                : std_logic := '0';
signal s_EX_MEM_Sign               : std_logic := '0';
signal s_EX_MEM_MemWrite           : std_logic := '0';
signal s_EX_MEM_MemtoReg           : std_logic := '0';
signal s_EX_MEM_RegWrite           : std_logic := '0';
signal s_EX_MEM_B                  : std_logic_vector(31 downto 0) := (others => '0');
signal s_EX_MEM_r2                 : std_logic_vector(31 downto 0) := (others => '0');
signal s_EX_MEM_Final              : std_logic_vector(31 downto 0) := (others => '0');
signal s_EX_MEM_PC4                : std_logic_vector(31 downto 0) := (others => '0');
signal s_EX_MEM_Inst               : std_logic_vector(31 downto 0) := (others => '0');
signal s_EX_MEM_WA                 : std_logic_vector(4 downto 0) := (others => '0');
signal s_EX_MEM_Link               : std_logic := '0';
signal s_EX_MEM_Halt               : std_logic := '0';

-- Signals for the MEM_WB pipeline
signal s_MEM_WB_RegWrite           : std_logic := '0';
signal s_MEM_WB_WD                 : std_logic_vector(31 downto 0) := (others => '0');
signal s_MEM_WB_PC4                : std_logic_vector(31 downto 0) := (others => '0');
signal s_MEM_WB_Inst               : std_logic_vector(31 downto 0) := (others => '0');
signal s_MEM_WB_WA                 : std_logic_vector(4 downto 0) := (others => '0');
signal s_MEM_WB_Link               : std_logic := '0';
signal s_MEM_WB_Halt               : std_logic := '0';

begin

    -- Instantiate IF_ID pipeline
    DUT0: IF_ID
    port map(
        i_CLKs  => CLK,
        i_Flush => s_IF_ID_Flush,
        i_Stall => s_IF_ID_Stall,
        i_PC4   => s_IF_ID_PC4,
        i_Inst  => s_IF_ID_Inst,
        o_PC4   => s_EX_MEM_PC4,  -- Output from IF_ID becomes input to EX_MEM
        o_Inst  => s_EX_MEM_Inst   -- Output from IF_ID becomes input to EX_MEM
    );

    -- Instantiate ID_EX pipeline
    DUT1: ID_EX
    port map(
        i_CLKs           => CLK,
        i_Flush          => s_IF_ID_Flush,
        i_Stall          => s_IF_ID_Stall,
        i_Jump           => s_ID_EX_Jump,
        i_Branch         => s_ID_EX_Branch,
        i_BranchNE       => s_ID_EX_BranchNE,
        i_Return         => s_ID_EX_Return,
        i_ALUnAddSub     => s_ID_EX_ALUnAddSub,
        i_ALUout         => s_ID_EX_ALUout,
        i_ShiftLorR      => s_ID_EX_ShiftLorR,
        i_ShiftArithmetic=> s_ID_EX_ShiftArithmetic,
        i_Unsigned       => s_ID_EX_Unsigned,
        i_Lui            => s_ID_EX_Lui,
        i_Lw             => s_ID_EX_Lw,
        i_HoB            => s_ID_EX_HoB,
        i_Sign           => s_ID_EX_Sign,
        i_MemWrite       => s_ID_EX_MemWrite,
        i_MemtoReg       => s_ID_EX_MemtoReg,
        i_RegWrite       => s_ID_EX_RegWrite,
        i_A              => s_ID_EX_A,
        i_B              => s_ID_EX_B,
        i_r2             => s_ID_EX_r2,
        i_PC4            => s_EX_MEM_PC4, -- Input from IF_ID pipeline
        i_Inst           => s_EX_MEM_Inst, -- Input from IF_ID pipeline
        i_WA             => s_ID_EX_WA,
        i_Link           => s_ID_EX_Link,
        i_Halt           => s_ID_EX_Halt,
        o_Jump           => s_EX_MEM_Jump,  -- Output from ID_EX becomes input to EX_MEM
        o_Branch         => s_EX_MEM_Branch, -- Output from ID_EX becomes input to EX_MEM
        o_BranchNE       => s_EX_MEM_BranchNE, -- Output from ID_EX becomes input to EX_MEM
        o_Return         => s_EX_MEM_Return, -- Output from ID_EX becomes input to EX_MEM
        o_ALUnAddSub     => s_EX_MEM_ALUnAddSub, -- Output from ID_EX becomes input to EX_MEM
        o_ALUout         => s_EX_MEM_ALUout, -- Output from ID_EX becomes input to EX_MEM
        o_ShiftLorR      => s_EX_MEM_ShiftLorR, -- Output from ID_EX becomes input to EX_MEM
        o_ShiftArithmetic=> s_EX_MEM_ShiftArithmetic, -- Output from ID_EX becomes input to EX_MEM
        o_Unsigned       => s_EX_MEM_Unsigned, -- Output from ID_EX becomes input to EX_MEM
        o_Lui            => s_EX_MEM_Lui, -- Output from ID_EX becomes input to EX_MEM
        o_Lw             => s_EX_MEM_Lw, -- Output from ID_EX becomes input to EX_MEM
        o_HoB            => s_EX_MEM_HoB, -- Output from ID_EX becomes input to EX_MEM
        o_Sign           => s_EX_MEM_Sign, -- Output from ID_EX becomes input to EX_MEM
        o_MemWrite       => s_EX_MEM_MemWrite, -- Output from ID_EX becomes input to EX_MEM
        o_MemtoReg       => s_EX_MEM_MemtoReg, -- Output from ID_EX becomes input to EX_MEM
        o_RegWrite       => s_EX_MEM_RegWrite, -- Output from ID_EX becomes input to EX_MEM
        o_A              => s_EX_MEM_A, -- Output from ID_EX becomes input to EX_MEM
        o_B              => s_EX_MEM_B, -- Output from ID_EX becomes input to EX_MEM
        o_r2             => s_EX_MEM_r2, -- Output from ID_EX becomes input to EX_MEM
        o_Final          => s_EX_MEM_Final, -- Output from ID_EX becomes input to EX_MEM
        o_PC4            => s_EX_MEM_PC4, -- Output from ID_EX becomes input to EX_MEM
        o_Inst           => s_EX_MEM_Inst, -- Output from ID_EX becomes input to EX_MEM
        o_WA             => s_EX_MEM_WA, -- Output from ID_EX becomes input to EX_MEM
        o_Link           => s_EX_MEM_Link, -- Output from ID_EX becomes input to EX_MEM
        o_Halt           => s_EX_MEM_Halt -- Output from ID_EX becomes input to EX_MEM
    );

    -- Instantiate EX_MEM pipeline
    DUT2: EX_MEM
    port map(
        i_CLKs           => CLK,
        i_Flush          => s_IF_ID_Flush,
        i_Stall          => s_IF_ID_Stall,
        i_Lw             => s_ID_EX_Lw, -- Input from ID_EX pipeline
        i_HoB            => s_ID_EX_HoB, -- Input from ID_EX pipeline
        i_Sign           => s_ID_EX_Sign, -- Input from ID_EX pipeline
        i_MemWrite       => s_ID_EX_MemWrite, -- Input from ID_EX pipeline
        i_MemtoReg       => s_ID_EX_MemtoReg, -- Input from ID_EX pipeline
        i_RegWrite       => s_ID_EX_RegWrite, -- Input from ID_EX pipeline
        i_B              => s_ID_EX_B, -- Input from ID_EX pipeline
        i_r2             => s_ID_EX_r2, -- Input from ID_EX pipeline
        i_Final          => s_ID_EX_Final, -- Input from ID_EX pipeline
        i_PC4            => s_EX_MEM_PC4, -- Input from ID_EX pipeline
        i_Inst           => s_EX_MEM_Inst, -- Input from ID_EX pipeline
        i_WA             => s_ID_EX_WA, -- Input from ID_EX pipeline
        i_Link           => s_ID_EX_Link, -- Input from ID_EX pipeline
        i_Halt           => s_ID_EX_Halt, -- Input from ID_EX pipeline
        o_Lw             => s_MEM_WB_Lw, -- Output from EX_MEM, unused
        o_HoB            => s_MEM_WB_HoB, -- Output from EX_MEM, unused
        o_Sign           => s_MEM_WB_Sign, -- Output from EX_MEM, unused
        o_MemWrite       => s_MEM_WB_MemWrite, -- Output from EX_MEM, unused
        o_MemtoReg       => s_MEM_WB_MemtoReg, -- Output from EX_MEM, unused
        o_RegWrite       => s_MEM_WB_RegWrite, -- Output from EX_MEM, unused
        o_B              => s_MEM_WB_B, -- Output from EX_MEM, unused
        o_r2             => s_MEM_WB_r2, -- Output from EX_MEM, unused
        o_Final          => s_MEM_WB_Final, -- Output from EX_MEM, unused
        o_PC4            => s_MEM_WB_PC4, -- Output from EX_MEM, unused
        o_Inst           => s_MEM_WB_Inst, -- Output from EX_MEM, unused
        o_WA             => s_MEM_WB_WA, -- Output from EX_MEM, unused
        o_Link           => s_MEM_WB_Link, -- Output from EX_MEM, unused
        o_Halt           => s_MEM_WB_Halt -- Output from EX_MEM, unused
    );

    -- Instantiate MEM_WB pipeline
    DUT3: MEM_WB
    port map(
        i_CLKs           => CLK,
        i_Flush          => s_IF_ID_Flush,
        i_Stall          => s_IF_ID_Stall,
        i_RegWrite       => s_EX_MEM_RegWrite, -- Input from EX_MEM pipeline
        i_WD             => s_EX_MEM_Final, -- Input from EX_MEM pipeline
        i_PC4            => s_EX_MEM_PC4, -- Input from EX_MEM pipeline
        i_Inst           => s_EX_MEM_Inst, -- Input from EX_MEM pipeline
        i_WA             => s_EX_MEM_WA, -- Input from EX_MEM pipeline
        i_Link           => s_EX_MEM_Link, -- Input from EX_MEM pipeline
        i_Halt           => s_EX_MEM_Halt, -- Input from EX_MEM pipeline
        o_RegWrite       => s_MEM_WB_RegWrite, -- Output from MEM_WB, unused
        o_WD             => s_MEM_WB_WD, -- Output from MEM_WB, unused
        o_PC4            => s_MEM_WB_PC4, -- Output from MEM_WB, unused
        o_Inst           => s_MEM_WB_Inst, -- Output from MEM_WB, unused
        o_WA             => s_MEM_WB_WA, -- Output from MEM_WB, unused
        o_Link           => s_MEM_WB_Link, -- Output from MEM_WB, unused
        o_Halt           => s_MEM_WB_Halt -- Output from MEM_WB, unused
    );

    P_CLK: process
    begin
        CLK <= '1';         -- clock starts at 1
        wait for gCLK_HPER; -- after half a cycle
        CLK <= '0';         -- clock becomes a 0 (negative edge)
        wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;
    
    -- Assign inputs for each test case.
    -- TODO: add test cases as needed.
    P_TEST_CASES: process
    begin
        wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

        -- Test case 1: (Loading something into the pipeline)
        s_Stall  <= '0';
        s_Flush  <= '0';
        s_PC4    <= "00000000000000000000000000000000";
        s_Inst   <= "11111111111111111111111111111111";

        wait for gCLK_HPER*2;
        -- Expect: s_PC4 = 0x00400000
        -- Expect: s_Inst = 0xFFFFFFFF

        -- Test case 2: (Loading something into the pipeline)
        s_Stall  <= '0';
        s_Flush  <= '0';
        s_PC4    <= "00010000010000011110000001010001";
        s_Inst   <= "00010000010000011110000001010001";
        wait for gCLK_HPER*2;

        -- Test case 3: (flush pipeline)
        s_Stall  <= '0';
        s_Flush  <= '1';
        wait for gCLK_HPER*2;
        -- Expect: s_PC4 = 0x00000000
        -- Expect: s_Inst = 0x00000000

        -- Test case 4: (Loading something into the pipeline)
        s_Stall  <= '0';
        s_Flush  <= '0';
        s_PC4    <= "00010000010000011110000001010001";
        s_Inst   <= "00010000010000011110000001010001";
        wait for gCLK_HPER*2;

        -- Test case 5: (stall pipeline)
        s_Stall  <= '1';
        s_Flush  <= '0';
        s_PC4    <= "00000000000000000000000000000000";
        s_Inst   <= "11111111111111111111111111111111";
        wait for gCLK_HPER*2;

        -- Test case 6: (stall pipeline)
        s_Stall  <= '0';
        s_Flush  <= '0';
        s_PC4    <= "11111111111111111111111111111111";
        s_Inst   <= "00000000000000000000000000000000";
        wait for gCLK_HPER*2;
        wait;
    end process;

end mixed;
