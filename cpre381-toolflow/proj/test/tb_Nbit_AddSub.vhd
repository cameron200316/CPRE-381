-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_Nbit_AddSub.vhd
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
entity tb_Nbit_AddSub is
end tb_Nbit_AddSub;

architecture mixed of tb_Nbit_AddSub is

constant N : integer := 32;  -- Set N to the desired bit width

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
component Nbit_AddSub is
  generic ( N : integer := 32 ); -- Pass the same value as the testbench constant    
  port(i_A               : in std_logic_vector(N-1 downto 0);
  i_B               : in std_logic_vector(N-1 downto 0);
  i_nAdd_Sub        : in std_logic;
  o_Sum             : out std_logic_vector(N-1 downto 0);
  o_Carry_Out       : out std_logic;
  o_Overflow        : out std_logic);
end component;


signal s_i_A, s_i_B, s_o_Sum : std_logic_vector(N-1 downto 0);
signal s_i_nAdd_Sub, s_o_Cout, s_o_Overflow : std_logic;


begin

  DUT0: Nbit_AddSub

  generic map ( N => N )

  port map(
    i_A               => s_i_A,
    i_B               => s_i_B,
    i_nAdd_Sub                => s_i_nAdd_Sub,
    o_Sum                 => s_o_Sum,
    o_Carry_Out                 => s_o_Cout,
    o_Overflow        => s_o_Overflow
          );
  
  P_TEST_CASES: process
  begin

       -- Test case 1: Minimum values addition
   s_i_A <= "10000000000000000000000000000000";  -- Minimum negative value
   s_i_B <= "10000000000000000000000000000000";  -- Minimum negative value
   s_i_nAdd_Sub <= '0';  -- Addition operation
   wait for 10 ns;  -- Adjust delay as needed
   -- Expected Sum: -2^31 + (-2^31) = -2^32 (Overflow)

   -- Test case 2: Maximum values addition
   s_i_A <= "01111111111111111111111111111111";  -- Maximum positive value
   s_i_B <= "01111111111111111111111111111111";  -- Maximum positive value
   s_i_nAdd_Sub <= '0';  -- Addition operation
   wait for 10 ns;  -- Adjust delay as needed
   -- Expected Sum: 2^31 - 1 + (2^31 - 1) = 2^32 - 2 (Overflow)

   -- Test case 3: Minimum values subtraction
   s_i_A <= "10000000000000000000000000000000";  -- Minimum negative value
   s_i_B <= "10000000000000000000000000000000";  -- Minimum negative value
   s_i_nAdd_Sub <= '1';  -- Subtraction operation
   wait for 10 ns;  -- Adjust delay as needed
   -- Expected Sum: -2^31 - (-2^31) = 0

   -- Test case 4: Maximum values subtraction
   s_i_A <= "01111111111111111111111111111111";  -- Maximum positive value
   s_i_B <= "10000000000000000000000000000000";  -- Minimum negative value
   s_i_nAdd_Sub <= '1';  -- Subtraction operation
   wait for 10 ns;  -- Adjust delay as needed
   -- Expected Sum: 2^31 - 1 - (-2^31) = 2^31 + 2^31 - 1 = 2^32 - 1 (Overflow)

    wait;
  end process;

end mixed;
