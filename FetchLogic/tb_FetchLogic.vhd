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
entity tb_FetchLogic is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_FetchLogic;

architecture mixed of tb_FetchLogic is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component FetchLogic is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_jump          : in std_logic;
        i_branch        : in std_logic;
        i_return        : in std_logic;
        i_zero          : in std_logic;
        i_init          : in std_logic;
        i_CLK           : in std_logic;
        i_ra            : in std_logic_vector(N-1 downto 0);
        i_instruction25 : in std_logic_vector(25 downto 0);
        i_instruction16 : in std_logic_vector(N-1 downto 0);
        o_PCNEW         : out std_logic_vector(N-1 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_ra         	    : std_logic_vector(31 downto 0)  := "00000000000000000000000000000000";
signal s_PCNEW         	    : std_logic_vector(31 downto 0)  := "00000000000000000000000000000000";
signal s_instruction25      : std_logic_vector(25 downto 0)  := "00000000000000000000000000";
signal s_instruction16      : std_logic_vector(31 downto 0)  := "00000000000000000000000000000000";
signal s_jump       	    : std_logic := '0';
signal s_branch     	    : std_logic := '0';
signal s_return     	    : std_logic := '0';
signal s_zero       	    : std_logic := '0';
signal s_init      	    : std_logic := '0';

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: FetchLogic
       port MAP(i_jump          => s_jump,
        	i_branch        => s_branch,
        	i_return        => s_return,
        	i_zero          => s_zero,
        	i_init          => s_init,
        	i_CLK           => CLK,
        	i_ra            => s_ra,
        	i_instruction25 => s_instruction25,
        	i_instruction16 => s_instruction16,
        	o_PCNEW         => s_PCNEW);
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

    -- Test case 1: PC INIT
	s_jump          <= '0';
        s_branch        <= '0';
        s_return        <= '0';
        s_zero          <= '0';
        s_init          <= '1';
        s_ra            <= "00000000000000000000000000000000";
        s_instruction25 <= "00000000000000000000000000";
        s_instruction16 <= "00000000000000000000000000000000";
    wait for gCLK_HPER*2;
    -- Expect: s_PCNEW = 0x00400000

    -- Test case 2: PC+4
	s_jump          <= '0';
        s_branch        <= '0';
        s_return        <= '0';
        s_zero          <= '0';
        s_init          <= '0';
        s_ra            <= "00000000000000000000000000000000";
        s_instruction25 <= "00000000000000000000000000";
        s_instruction16 <= "00000000000000000000000000000000";
    wait for gCLK_HPER*2;
    -- Expect: s_PCNEW = 0x00400004

    -- Test case 3: Jump
	s_jump          <= '1';
        s_branch        <= '0';
        s_return        <= '0';
        s_zero          <= '0';
        s_init          <= '0';
        s_ra            <= "00000000000000000000000000000000";
        s_instruction25 <= "01000000100001000000000000";
        s_instruction16 <= "00000000000000000000000000000000";
    wait for gCLK_HPER*2;
    -- Expect: s_PCNEW = 0x04084000

    -- Test case 4: Jump Return
	s_jump          <= '1';
        s_branch        <= '0';
        s_return        <= '1';
        s_zero          <= '0';
        s_init          <= '0';
        s_ra            <= "00000000010000000000000000000100";
        s_instruction25 <= "01000000100001000000000000";
        s_instruction16 <= "00000000000000000000000000000000";
    wait for gCLK_HPER*2;
    -- Expect: s_PCNEW = 0x00400004


    -- Test case 5: Branch NOT ZERO
	s_jump          <= '0';
        s_branch        <= '1';
        s_return        <= '0';
        s_zero          <= '0';
        s_init          <= '0';
        s_ra            <= "00000000010000000000000000000100";
        s_instruction25 <= "01000000100001000000000000";
        s_instruction16 <= "00000000000000000000000000000000";
    wait for gCLK_HPER*2;
    -- Expect: s_PCNEW = 0x00400008

    -- Test case 6: Branch ZERO
	s_jump          <= '0';
        s_branch        <= '1';
        s_return        <= '0';
        s_zero          <= '1';
        s_init          <= '0';
        s_ra            <= "00000000010000000000000000000100";
        s_instruction25 <= "01000000100001000000000000";
        s_instruction16 <= "00000000000000000000000010001000";
    wait for gCLK_HPER*2;
    -- Expect: s_PCNEW = 0x00400228

    wait;
  end process;

end mixed;
