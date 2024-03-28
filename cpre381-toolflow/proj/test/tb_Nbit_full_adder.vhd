-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_Nbit_full_adder.vhd
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
-- TODO: change all instances of tb_Nbit_full_adder to reflect the new testbench.
entity tb_Nbit_full_adder is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_Nbit_full_adder;

architecture mixed of tb_Nbit_full_adder is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;
constant N : integer := 32;  -- Set N to the desired bit width

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component Nbit_full_adder is
  generic (
    N : integer := 32  -- Pass the same value as the testbench constant    
    );
  port(
       i_A 		              : in std_logic_vector(N-1 downto 0);
       i_B 		              : in std_logic_vector(N-1 downto 0);
       i_Cin 		            : in std_logic;
       o_Sum 		            : out std_logic_vector(N-1 downto 0);
       o_Cout               : out std_logic;
       o_Overflow           : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_i_A, s_i_B, s_o_Sum : std_logic_vector(N-1 downto 0);
signal s_i_Cin, s_o_Cout, s_o_Overflow : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: Nbit_full_adder

  generic map (
            N => N
        )

  port map(
            i_A          => s_i_A,
            i_B          => s_i_B,
            i_Cin        => s_i_Cin,
            o_Sum        => s_o_Sum,
            o_Cout       => s_o_Cout,
            o_Overflow   => s_o_Overflow);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    s_i_A   <= "01010101010101010101010101010101";  
    s_i_B   <= "10101010101010101010101010101010";
    s_i_Cin      <= '0';
    wait for gCLK_HPER*2;
    -- Expect: o_Sum should be equal to i_A + i_B (the value 11111111111111111111111111111111)

    -- Test case 2:
    s_i_A   <= "11111111111111111111111111111111";  
    s_i_B   <= "00000000000000000000000000000000";
    s_i_Cin      <= '0';
    wait for gCLK_HPER*2;
    -- Expect: o_Sum should be equal to i_A + i_B (the value 11111111111111111111111111111111)

    -- Test case 3:
    s_i_A   <= "11111111111111111111111111111111";  
    s_i_B   <= "00000000000000000000000000000000";
    s_i_Cin      <= '1';
    wait for gCLK_HPER*2;
    -- Expect: o_Sum should be equal to i_A + i_B (the value 00000000000000000000000000000000)

    -- Test case 4:
    s_i_A   <= "01100110101001101110111010101010"; 
    s_i_B   <= "00110101010100101010101010101101";
    s_i_Cin      <= '0';
    wait for gCLK_HPER*2;
    -- Expect: o_Sum should be equal to i_A + i_B (the value 00011011111110011001100101010111)

    -- Test case 5:
    s_i_A   <= "00000000000000000000000000000010";  
    s_i_B   <= "00000000000000000000000000000000";
    s_i_Cin      <= '1';
    wait for gCLK_HPER*2;
    -- Expect: o_Sum should be equal to i_A + i_B (the value 00000000000000000000000000000011)

    -- Test case 6:
    s_i_A   <= "00000000000000000000000000000010";  
    s_i_B   <= "00000000000000000000000000000011";
    s_i_Cin      <= '1';
    wait for gCLK_HPER*2;
    -- Expect: o_Sum should be equal to i_A + i_B (the value 00000000000000000000000000000110)

    -- Test case 7:
    s_i_A   <= "10000000000000000000000000000010";  
    s_i_B   <= "10000000000000000000000000000011";
    s_i_Cin      <= '1';
    wait for gCLK_HPER*2;
    -- Expect: o_Sum should be equal to i_A + i_B (the value 00000000000000000000000000000110)


    wait for gCLK_HPER*2;

    wait;
  end process;

end mixed;
