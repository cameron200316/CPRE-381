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
entity tb_IF_ID is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_IF_ID;

architecture mixed of tb_IF_ID is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component IF_ID is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_CLKs        : in std_logic;
	i_R           : in std_logic;
        i_PC4         : in std_logic_vector(N-1 downto 0);
        i_Inst        : in std_logic_vector(N-1 downto 0);
        o_PC4         : out std_logic_vector(N-1 downto 0);
        o_Inst        : out std_logic_vector(N-1 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_PC4  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_Inst : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_R    : std_logic := '0';
signal s_oPC4 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_oInst: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: IF_ID
  port map(i_CLKs        => CLK,
	   i_R           => s_R,
           i_PC4         => s_PC4, 
           i_Inst        => s_Inst,
           o_PC4         => s_oPC4,
           o_Inst        => s_oInst);
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

    -- Test case 1: (Loading something into the pipeline)
    s_PC4    <= "00000000010000000000000000000000";
    s_Inst   <= "11111111111111111111111111111111";
    s_R      <= '0';
    wait for gCLK_HPER*2;
    -- Expect: s_PC4 = 0x00400000
    -- Expect: s_Inst = 0xFFFFFFFF

    -- Test case 2: (Loading something into the pipeline)
    s_PC4    <= "00000000010000000000000000000000";
    s_Inst   <= "11111111111111111111111111111111";
    s_R      <= '1';
    wait for gCLK_HPER*2;
    -- Expect: s_PC4 = 0x00000000
    -- Expect: s_Inst = 0x00000000

    wait;
  end process;

end mixed;
