library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O
use ieee.numeric_std.all; 


-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_pipelines is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_pipelines;

architecture mixed of tb_pipelines is

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

    -- Create signals for all of the inputs and outputs of the file that you are testing
    -- := '0' or := (others => '0') just make all the signals start at an initial value of zero
    signal CLK : std_logic := '0';

--SIGNALS FOR PIPELINES

  --Flush and Stall Signals
  signal s_IF_ID_Flush : std_logic;
  signal s_IF_ID_Stall : std_logic;
  signal s_ID_EX_Flush : std_logic;
  signal s_ID_EX_Stall : std_logic;
  signal s_EX_MEM_Flush : std_logic;
  signal s_EX_MEM_Stall : std_logic;
  signal s_MEM_WB_Flush : std_logic;
  signal s_MEM_WB_Stall : std_logic;

  --IF stage
  signal s_IF_PC4         : std_logic_vector(31 downto 0);
  signal s_IF_INSTRUCTION         : std_logic_vector(31 downto 0);

  --ID stage
  signal s_ID_Jump      : std_logic;
  signal s_ID_branch    : std_logic;
  signal s_ID_return    : std_logic;
  signal s_ID_ALUnAddSub  : std_logic;
  signal s_ID_ALUout      : std_logic_vector(2 downto 0);
  signal s_ID_ShiftLorR : std_logic;
  signal s_ID_ShiftArithmetic  : std_logic;
  signal s_ID_unsigned    : std_logic;
  signal s_ID_Lui       : std_logic;
  signal s_ID_BranchNE   : std_logic;
  signal s_ID_A         : std_logic_vector(31 downto 0);
  signal s_ID_B         : std_logic_vector(31 downto 0);
  signal s_ID_r2        : std_logic_vector(31 downto 0);
  signal s_ID_Lw        : std_logic;
  signal s_ID_HoB       : std_logic;
  signal s_ID_sign      : std_logic;
  signal s_ID_MemWrite  : std_logic;
  signal s_ID_MemtoReg  : std_logic;
  signal s_ID_RegWrite  : std_logic;
  signal s_ID_PC4         : std_logic_vector(31 downto 0);
  signal s_ID_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_ID_Link  : std_logic;
  signal s_ID_WA : std_logic_vector(4 downto 0);
  signal s_ID_Halt         : std_logic;

  --EX stage
  signal s_EX_Jump      : std_logic;
  signal s_EX_branch    : std_logic;
  signal s_EX_return    : std_logic;
  signal s_EX_ALUnAddSub  : std_logic;
  signal s_EX_ALUout      : std_logic_vector(2 downto 0);
  signal s_EX_ShiftLorR : std_logic;
  signal s_EX_ShiftArithmetic  : std_logic;
  signal s_EX_unsigned    : std_logic;
  signal s_EX_Lui       : std_logic;
  signal s_EX_BranchNE   : std_logic;
  signal s_EX_A         : std_logic_vector(31 downto 0);
  signal s_EX_B         : std_logic_vector(31 downto 0);
  signal s_EX_r2        : std_logic_vector(31 downto 0);
  signal s_EX_Lw        : std_logic;
  signal s_EX_HoB       : std_logic;
  signal s_EX_sign      : std_logic;
  signal s_EX_MemWrite  : std_logic;
  signal s_EX_MemtoReg  : std_logic;
  signal s_EX_RegWrite  : std_logic;
  signal s_EX_Final         : std_logic_vector(31 downto 0);
  signal s_EX_PC4         : std_logic_vector(31 downto 0);
  signal s_EX_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_EX_Link  : std_logic;
  signal s_EX_WA : std_logic_vector(4 downto 0);
  signal s_EX_Halt         : std_logic;

  --MEM stage
  signal s_MEM_B         : std_logic_vector(31 downto 0);
  signal s_MEM_r2        : std_logic_vector(31 downto 0);
  signal s_MEM_Lw        : std_logic;
  signal s_MEM_HoB       : std_logic;
  signal s_MEM_sign      : std_logic;
  signal s_MEM_MemWrite  : std_logic;
  signal s_MEM_MemtoReg  : std_logic;
  signal s_MEM_RegWrite  : std_logic;
  signal s_MEM_Final         : std_logic_vector(31 downto 0);
  signal s_MEM_WA        : std_logic_vector(4 downto 0);
  signal s_MEM_WD         : std_logic_vector(31 downto 0);
  signal s_MEM_PC4         : std_logic_vector(31 downto 0);
  signal s_MEM_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_MEM_Link  : std_logic;
  signal s_MEM_Halt         : std_logic;

  --WB stage
  signal s_WB_RegWrite         : std_logic;
  signal s_WB_WA        : std_logic_vector(4 downto 0);
  signal s_WB_WD         : std_logic_vector(31 downto 0);
  signal s_WB_PC4         : std_logic_vector(31 downto 0);
  signal s_WB_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_WB_Link  : std_logic;
  signal s_WB_Halt         : std_logic;

begin

    -- Instantiate IF_ID pipeline
    DUT0: IF_ID
    port map(
        i_CLKs  => CLK,
        i_Flush => s_IF_ID_Flush,
        i_Stall => s_IF_ID_Stall,

        i_PC4   => s_IF_PC4,
        i_Inst  => s_IF_INSTRUCTION,

        o_PC4   => s_ID_PC4,
        o_Inst  => s_ID_INSTRUCTION   
    );

    -- Instantiate ID_EX pipeline
    DUT1: ID_EX
    port map(
        i_CLKs           => CLK,
        i_Flush          => s_ID_EX_Flush,
        i_Stall          => s_ID_EX_Stall,

        i_Jump           => s_ID_Jump,
        i_Branch         => s_ID_Branch,
        i_BranchNE       => s_ID_BranchNE,
        i_Return         => s_ID_Return,
        i_ALUnAddSub     => s_ID_ALUnAddSub,
        i_ALUout         => s_ID_ALUout,
        i_ShiftLorR      => s_ID_ShiftLorR,
        i_ShiftArithmetic=> s_ID_ShiftArithmetic,
        i_Unsigned       => s_ID_Unsigned,
        i_Lui            => s_ID_Lui,
        i_Lw             => s_ID_Lw,
        i_HoB            => s_ID_HoB,
        i_Sign           => s_ID_Sign,
        i_MemWrite       => s_ID_MemWrite,
        i_MemtoReg       => s_ID_MemtoReg,
        i_RegWrite       => s_ID_RegWrite,
        i_A              => s_ID_A,
        i_B              => s_ID_B,
        i_r2             => s_ID_r2,
        i_PC4            => s_ID_PC4, 
        i_Inst           => s_ID_INSTRUCTION, 
        i_WA             => s_ID_WA,
        i_Link           => s_ID_Link,
        i_Halt           => s_ID_Halt,
        o_Jump           => s_EX_Jump,  
        o_Branch         => s_EX_Branch, 
        o_BranchNE       => s_EX_BranchNE, 
        o_Return         => s_EX_Return, 
        o_ALUnAddSub     => s_EX_ALUnAddSub, 
        o_ALUout         => s_EX_ALUout, 
        o_ShiftLorR      => s_EX_ShiftLorR, 
        o_ShiftArithmetic=> s_EX_ShiftArithmetic, 
        o_Unsigned       => s_EX_Unsigned, 
        o_Lui            => s_EX_Lui, 
        o_Lw             => s_EX_Lw, 
        o_HoB            => s_EX_HoB, 
        o_Sign           => s_EX_Sign, 
        o_MemWrite       => s_EX_MemWrite, 
        o_MemtoReg       => s_EX_MemtoReg, 
        o_RegWrite       => s_EX_RegWrite, 
        o_A              => s_EX_A, 
        o_B              => s_EX_B, 
        o_r2             => s_EX_r2, 
        o_PC4            => s_EX_PC4, 
        o_Inst           => s_EX_INSTRUCTION, 
        o_WA             => s_EX_WA, 
        o_Link           => s_EX_Link, 
        o_Halt           => s_EX_Halt 
    );

    -- Instantiate EX_MEM pipeline
    DUT2: EX_MEM
    port map(
        i_CLKs           => CLK,
        i_Flush          => s_EX_MEM_Flush,
        i_Stall          => s_EX_MEM_Stall,

        i_Lw             => s_EX_Lw, 
        i_HoB            => s_EX_HoB, 
        i_Sign           => s_EX_Sign, 
        i_MemWrite       => s_EX_MemWrite, 
        i_MemtoReg       => s_EX_MemtoReg, 
        i_RegWrite       => s_EX_RegWrite, 
        i_B              => s_EX_B, 
        i_r2             => s_EX_r2, 
        i_Final          => s_EX_Final, 
        i_PC4            => s_EX_PC4, 
        i_Inst           => s_EX_INSTRUCTION, 
        i_WA             => s_EX_WA, 
        i_Link           => s_EX_Link, 
        i_Halt           => s_EX_Halt, 

        o_Lw             => s_MEM_Lw, 
        o_HoB            => s_MEM_HoB, 
        o_Sign           => s_MEM_Sign, 
        o_MemWrite       => s_MEM_MemWrite, 
        o_MemtoReg       => s_MEM_MemtoReg, 
        o_RegWrite       => s_MEM_RegWrite, 
        o_B              => s_MEM_B, 
        o_r2             => s_MEM_r2, 
        o_Final          => s_MEM_Final, 
        o_PC4            => s_MEM_PC4, 
        o_Inst           => s_MEM_INSTRUCTION, 
        o_WA             => s_MEM_WA, 
        o_Link           => s_MEM_Link, 
        o_Halt           => s_MEM_Halt 
    );

    -- Instantiate MEM_WB pipeline
    DUT3: MEM_WB
    port map(
        i_CLKs           => CLK,
        i_Flush          => s_MEM_WB_Flush,
        i_Stall          => s_MEM_WB_Stall,

        i_RegWrite       => s_MEM_RegWrite, 
        i_WD             => s_MEM_Final, 
        i_PC4            => s_MEM_PC4, 
        i_Inst           => s_MEM_INSTRUCTION, 
        i_WA             => s_MEM_WA, 
        i_Link           => s_MEM_Link, 
        i_Halt           => s_MEM_Halt, 

        o_RegWrite       => s_WB_RegWrite, 
        o_WD             => s_WB_WD, 
        o_PC4            => s_WB_PC4, 
        o_Inst           => s_WB_INSTRUCTION, 
        o_WA             => s_WB_WA, 
        o_Link           => s_WB_Link, 
        o_Halt           => s_WB_Halt 
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

        -- -- Assign all signals to zero
        s_IF_ID_Flush <= '0';
        s_IF_ID_Stall <= '0';
        s_ID_EX_Flush <= '0';
        s_ID_EX_Stall <= '0';
        s_EX_MEM_Flush <= '0';
        s_EX_MEM_Stall <= '0';
        s_MEM_WB_Flush <= '0';
        s_MEM_WB_Stall <= '0';

        s_IF_ID_Flush <= '1';
        s_IF_ID_Stall <= '1';
        s_ID_EX_Flush <= '1';
        s_ID_EX_Stall <= '1';
        s_EX_MEM_Flush <= '1';
        s_EX_MEM_Stall <= '1';
        s_MEM_WB_Flush <= '1';
        s_MEM_WB_Stall <= '1';
        wait for gCLK_HPER * 2; 

        s_IF_ID_Flush <= '0';
        s_IF_ID_Stall <= '0';
        s_ID_EX_Flush <= '0';
        s_ID_EX_Stall <= '0';
        s_EX_MEM_Flush <= '0';
        s_EX_MEM_Stall <= '0';
        s_MEM_WB_Flush <= '0';
        s_MEM_WB_Stall <= '0';
        wait for gCLK_HPER * 2; 

        -- s_IF_PC4 <= (others => '1');
        -- s_ID_PC4 <= (others => '1');
        -- s_EX_PC4 <= (others => '1');
        -- s_MEM_PC4 <= (others => '1');
        -- s_WB_PC4 <= (others => '1');
        -- wait for gCLK_HPER * 2; 

        -- Test Case 1: Verify IF/ID Register Functionality
        s_IF_PC4 <= (others => '1');
        wait for gCLK_HPER * 2; 
        s_IF_PC4 <= (others => '0');
        wait for 4 * gCLK_HPER * 2;

        -- Test Case 2: Verify Insertion of New Values
        for i in 0 to 10 loop
            s_IF_PC4 <= std_logic_vector(to_unsigned(i, s_IF_PC4'length));
            wait for gCLK_HPER * 2; 
        end loop;

        s_IF_PC4 <= (others => '0');
        wait for 4 * gCLK_HPER * 2;

        s_IF_PC4 <= (others => '1');   
        wait for gCLK_HPER * 2;
        s_IF_ID_Flush <= '1';
        wait for gCLK_HPER * 2; 
        s_ID_EX_Flush <= '1';
        wait for gCLK_HPER * 2; 
        s_EX_MEM_Flush <= '1';
        wait for gCLK_HPER * 2; 
        s_MEM_WB_Flush <= '1';
        wait for gCLK_HPER * 2; 

        s_IF_PC4 <= (others => '0');   
        s_IF_ID_Flush <= '0';
        s_ID_EX_Flush <= '0';
        s_EX_MEM_Flush <= '0';
        s_MEM_WB_Flush <= '0';
        wait for gCLK_HPER * 2; 
        s_IF_PC4 <= (others => '1');        
        s_IF_ID_Stall <= '1';
        s_ID_EX_Stall <= '1';
        s_EX_MEM_Stall <= '1';
        s_MEM_WB_Stall <= '1';
        wait for gCLK_HPER * 2; 
        s_IF_ID_Stall <= '0';
        wait for gCLK_HPER * 2; 
        s_ID_EX_Stall <= '0';
        wait for gCLK_HPER * 2; 
        s_EX_MEM_Stall <= '0';
        wait for gCLK_HPER * 2; 
        s_MEM_WB_Stall <= '0';
        wait for gCLK_HPER * 2; 





        
        wait;
    end process;

end mixed;