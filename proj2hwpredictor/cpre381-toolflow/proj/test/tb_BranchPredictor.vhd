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
entity tb_BranchPredictor is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_BranchPredictor;

architecture mixed of tb_BranchPredictor is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component BranchPredictor is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_CLKs        	: in std_logic;
	i_R        	: in std_logic;
	i_branch_taken	: in std_logic;
	i_ex_branch    	: in std_logic;
	o_branch_pred   : out std_logic;
	o_notBranch_pred: out std_logic);

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_R	         : std_logic := '0';
signal s_branch_taken    : std_logic := '0';
signal s_ex_branch       : std_logic := '0';
signal s_branch_pred     : std_logic := '0';
signal s_notBranch_pred  : std_logic := '0';


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: BranchPredictor
  port MAP(i_CLKs        	=> CLK,
	i_R        		=> s_R,
	i_branch_taken		=> s_branch_taken,
	i_ex_branch    		=> s_ex_branch,
	o_branch_pred   	=> s_branch_pred,
	o_notBranch_pred	=> s_notBranch_pred);
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
    s_R <= '1';
    -- Test case 1: 
    s_branch_taken <= '0';
    s_ex_branch    <= '0'; 
    wait for gCLK_HPER*2;
    -- Expect: s_branch_pred = 0
    -- Expect: s_notBranch_pred = 1

    -- Test case 2: 
    s_R <= '0';
    s_branch_taken <= '1';
    s_ex_branch    <= '0'; 
    wait for gCLK_HPER*2;
    -- Expect: s_branch_pred = 0
    -- Expect: s_notBranch_pred = 1

    -- Test case 3: 
    s_branch_taken <= '1';
    s_ex_branch    <= '1'; 
    wait for gCLK_HPER*2;
    -- Expect: s_branch_pred = 1
    -- Expect: s_notBranch_pred = 0

    -- Test case 4: 
    s_branch_taken <= '0';
    s_ex_branch    <= '0'; 
    wait for gCLK_HPER*2;
    -- Expect: s_branch_pred = 1
    -- Expect: s_notBranch_pred = 0

    -- Test case 5: 
    s_branch_taken <= '0';
    s_ex_branch    <= '1'; 
    wait for gCLK_HPER*2;
    -- Expect: s_branch_pred = 0
    -- Expect: s_notBranch_pred = 1


    wait;
  end process;

end mixed;
