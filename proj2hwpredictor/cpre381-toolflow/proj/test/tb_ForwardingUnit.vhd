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
entity tb_ForwardingUnit is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_ForwardingUnit;

architecture mixed of tb_ForwardingUnit is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component ForwardingUnit is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_WB_WA          : in std_logic_vector(4 downto 0);
        i_MEM_WA         : in std_logic_vector(4 downto 0);  
        i_EX_RS          : in std_logic_vector(4 downto 0);
        i_EX_RT          : in std_logic_vector(4 downto 0);
	i_MEM_OPCODE     : in std_logic_vector(5 downto 0);
        o_WB_EX2_RS      : out std_logic;
	o_WB_EX2_RT      : out std_logic;
        o_MEM_EX1_RS     : out std_logic;
        o_MEM_EX1_RT     : out std_logic);

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_WB_WA 		  : std_logic_vector(4 downto 0)  := "00000";
signal s_MEM_WA 	  : std_logic_vector(4 downto 0)  := "00000";
signal s_EX_RS  	  : std_logic_vector(4 downto 0)  := "00000";
signal s_EX_RT   	  : std_logic_vector(4 downto 0)  := "00000";
signal s_MEM_OPCODE       : std_logic_vector(5 downto 0)  := "000000";
signal s_WB_EX2_RS    	  : std_logic := '0';
signal s_WB_EX2_RT  	  : std_logic := '0';
signal s_MEM_EX1_RS   	  : std_logic := '0';
signal s_MEM_EX1_RT  	  : std_logic := '0';

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: ForwardingUnit
   port MAP(i_WB_WA          => s_WB_WA,
        i_MEM_WA         => s_MEM_WA,  
        i_EX_RS          => s_EX_RS,
        i_EX_RT          => s_EX_RT,
	i_MEM_OPCODE     => s_MEM_OPCODE,
        o_WB_EX2_RS      => s_WB_EX2_RS,
	o_WB_EX2_RT      => s_WB_EX2_RT,
        o_MEM_EX1_RS     => s_MEM_EX1_RS,
        o_MEM_EX1_RT     => s_MEM_EX1_RT);
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

    -- Test case 1: (Testing no forwards needed)
    s_WB_WA   	   <= "00100";
    s_MEM_WA       <= "10000";
    s_EX_RS        <= "00000"; 
    s_EX_RT        <= "00000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 2: (Testing no forwards needed (zero))
    s_WB_WA   	   <= "00000";
    s_MEM_WA       <= "00000";
    s_EX_RS        <= "00000"; 
    s_EX_RT        <= "00000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 3: (Testing distance two forward (RS))
    s_WB_WA   	   <= "10000";
    s_MEM_WA       <= "00000";
    s_EX_RS        <= "10000"; 
    s_EX_RT        <= "00000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 1
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 3: (Testing distance two forward (RT))
    s_WB_WA   	   <= "10000";
    s_MEM_WA       <= "00000";
    s_EX_RS        <= "00000"; 
    s_EX_RT        <= "10000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 1
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 4: (Testing distance of one (no LW)(RS))
    s_WB_WA   	   <= "00000";
    s_MEM_WA       <= "10000";
    s_EX_RS        <= "10000"; 
    s_EX_RT        <= "00000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 1
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 5: (Testing distance of one (no LW)(RT))
    s_WB_WA   	   <= "00000";
    s_MEM_WA       <= "10000";
    s_EX_RS        <= "00000"; 
    s_EX_RT        <= "10000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 1

    -- Test case 6: (Testing distance of one (LW)(RS))
    s_WB_WA   	   <= "00000";
    s_MEM_WA       <= "10000";
    s_EX_RS        <= "10000"; 
    s_EX_RT        <= "00000";
    s_MEM_OPCODE   <= "100000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 7: (Testing distance of one (LW)(RT))
    s_WB_WA   	   <= "00000";
    s_MEM_WA       <= "10000";
    s_EX_RS        <= "00000"; 
    s_EX_RT        <= "10000";
    s_MEM_OPCODE   <= "100000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 8: (Testing distance of one (LW)(RT))
    s_WB_WA   	   <= "10000";
    s_MEM_WA       <= "10000";
    s_EX_RS        <= "10000"; 
    s_EX_RT        <= "00000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 0

    -- Test case 9: (Testing distance of one (LW)(RT))
    s_WB_WA   	   <= "10000";
    s_MEM_WA       <= "10000";
    s_EX_RS        <= "00000"; 
    s_EX_RT        <= "10000";
    s_MEM_OPCODE   <= "000000"; 
    wait for gCLK_HPER*2;
    -- Expect: s_WB_EX2_RS = 0
    -- Expect: s_WB_EX2_RT = 0
    -- Expect: s_MEM_EX1_RS = 0
    -- Expect: s_MEM_EX1_RT = 1

    wait;
  end process;

end mixed;