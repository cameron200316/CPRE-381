-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Nbit_full_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Nbit_full_adder is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       i_Cin        : in std_logic;
       o_Sum        : out std_logic_vector(N-1 downto 0);
       o_Cout       : out std_logic;
       o_Overflow   : out std_logic);

end Nbit_full_adder;

architecture structural of Nbit_full_adder is

  component Structual_full_adder is
    port(i_A                  : in std_logic;
         i_B                  : in std_logic;
         i_Cin                : in std_logic;
         o_Sum                : out std_logic;
         o_Cout               : out std_logic);
  end component;

  signal s_i_Cin   : std_logic_vector(N-1 downto 0);
  signal s_lastCarry : std_logic;

begin

  full_adder_0: Structual_full_adder
    port MAP(i_A         => i_A(0),      -- All instances share the same select input.
             i_B         => i_B(0),  -- ith instance's data 0 input hooked up to ith data 0 input.
             i_Cin       => i_Cin,
             o_Sum       => o_Sum(0),
             o_Cout      => s_i_Cin(0));

  -- Instantiate N full adder instances.
  G_NBit_full_adder: for i in 1 to N-2 generate
  rippleAdder: Structual_full_adder port map(
              i_A         => i_A(i),      -- All instances share the same select input.
              i_B         => i_B(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_Cin       => s_i_Cin(i-1),
              o_Sum       => o_Sum(i),
              o_Cout      => s_i_Cin(i));
  end generate G_NBit_full_adder;

  full_adder_31: Structual_full_adder
  port MAP(i_A         => i_A(31),      -- All instances share the same select input.
           i_B         => i_B(31),  -- ith instance's data 0 input hooked up to ith data 0 input.
           i_Cin       => s_i_Cin(30),
           o_Sum       => o_Sum(31),
           o_Cout      => s_lastCarry);
  
  o_Overflow <= (s_i_Cin(30) xor s_lastCarry);
  o_Cout <= s_lastCarry;

end structural;