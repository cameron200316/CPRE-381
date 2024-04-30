-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_TPU_MV_Element.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the TPU MAC unit.
--              
-- 01/03/2020 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_ID_EX is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_ID_EX;

architecture mixed of tb_ID_EX is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component ID_EX is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(
    i_CLKs        : in std_logic;
    i_Flush       : in std_logic; --this is the flush value
    i_Stall       : in std_logic; --this is the stall value


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
    o_Halt               : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_Flush : std_logic := '0';
signal s_Stall : std_logic := '0';

signal s_PC4      : std_logic_vector(31 downto 0) := (others => '0');
signal s_Inst     : std_logic_vector(31 downto 0) := (others => '0');

signal s_o_PC4      : std_logic_vector(31 downto 0) := (others => '0');
signal s_o_Inst     : std_logic_vector(31 downto 0) := (others => '0');


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: ID_EX
  port map(i_CLKs        => CLK,
           i_Flush       => s_Flush,
           i_Stall       => s_Stall,

           i_PC4         => s_PC4,
           i_Inst        => s_Inst,
            o_PC4         => s_o_PC4,
            o_Inst        => s_o_Inst,

            
            i_Jump            => '0',
            i_Branch          => '0',
            i_BranchNE        => '0',
            i_Return          => '0',
            i_ALUnAddSub      => '0',
            i_ALUout          => (others => '0'),
            i_ShiftLorR       => '0',
            i_ShiftArithmetic => '0',
            i_Unsigned        => '0',
            i_Lui             => '0',
            i_Lw              => '0',
            i_HoB             => '0',
            i_Sign            => '0',
            i_MemWrite        => '0',
            i_MemtoReg        => '0',
            i_RegWrite        => '0',
            i_A               => (others => '0'),
            i_B               => (others => '0'),
            i_r2              => (others => '0'),
            i_WA              => (others => '0'),
            i_Link            => '0',
            i_Halt            => '0',

            o_Jump            => open,
            o_Branch          => open,
            o_BranchNE        => open,
            o_Return          => open,
            o_ALUnAddSub      => open,
            o_ALUout          => open,
            o_ShiftLorR       => open,
            o_ShiftArithmetic => open,
            o_Unsigned        => open,
            o_Lui             => open,
            o_Lw              => open,
            o_HoB             => open,
            o_Sign            => open,
            o_MemWrite        => open,
            o_MemtoReg        => open,
            o_RegWrite        => open,
            o_A               => open,
            o_B               => open,
            o_r2              => open,
            o_WA              => open,
            o_Link            => open,
            o_Halt            => open


           );
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
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
    
    s_Stall  <= '1';
    s_Flush  <= '1';
    wait for gCLK_HPER*2;

    s_Stall  <= '0';
    s_Flush  <= '0';
    wait for gCLK_HPER*2;

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