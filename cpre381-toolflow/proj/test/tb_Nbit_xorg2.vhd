-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_Nbit_xorg2.vhd
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
-- TODO: change all instances of tb_Nbit_xorg2 to reflect the new testbench.
entity tb_Nbit_xorg2 is
end tb_Nbit_xorg2;

architecture mixed of tb_Nbit_xorg2 is

constant N : integer := 32;  -- Set N to the desired bit width

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component Nbit_xorg2 is
  port(
       i_A 		          : in std_logic_vector;
       i_B              : in std_logic_vector;
       o_O 		            : out std_logic_vector);
end component;

-- TODO: change input and output signals as needed.
signal s_i_A   : std_logic_vector(N-1 downto 0);
signal s_i_B   : std_logic_vector(N-1 downto 0);
signal s_o_O    : std_logic_vector(N-1 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: Nbit_xorg2
  port map(
            i_A       => s_i_A,
            i_B       => s_i_B,
            o_O        => s_o_O);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html


  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for 10 ns;

    -- Test case 1:
    s_i_A   <= "00000000000000000000000000000000";  -- Not strictly necessary, but this makes the testcases easier to read
    s_i_B   <= "11000000001111001100001000100011";  -- Not strictly necessary, but this makes the testcases easier to read
    wait for 10 ns;

    -- Test case 2:
    s_i_A   <= "11111111111111111111111111111111";  -- Not strictly necessary, but this makes the testcases easier to read
    s_i_B   <= "11000000001111001100001000100011";  -- Not strictly necessary, but this makes the testcases easier to read
    wait for 10 ns;

    -- Test case 3:
    s_i_A   <= "00110000001000000011100000110010";  -- Not strictly necessary, but this makes the testcases easier to read
    s_i_B   <= "11000000001111001100001000100011";  -- Not strictly necessary, but this makes the testcases easier to read
    wait for 10 ns;


    wait for 10 ns;

    wait;
  end process;

end mixed;
