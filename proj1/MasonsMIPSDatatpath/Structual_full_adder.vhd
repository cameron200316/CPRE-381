-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Structual_full_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a processing
-- element for the systolic matrix-vector multiplication array inspired 
-- by Google's TPU.
--
--
-- NOTES:
-- 1/14/19 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity Structual_full_adder is

  port(i_A 		           : in std_logic;
       i_B 		           : in std_logic;
       i_Cin 		         : in std_logic;
       o_Sum             : out std_logic;
       o_Cout            : out std_logic);

end Structual_full_adder;

architecture structure of Structual_full_adder is

  component andg2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component org2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component xorg2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;


  -- Signal to carry xor gate
  signal s_XOR          : std_logic;
  -- Signals to carry the first And gate
  signal s_And1         : std_logic;
  -- Signal to carry the Second And gate
  signal s_And2         : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Gates Implementation
  ---------------------------------------------------------------------------
  g_A_B_to_XOR: xorg2
  port MAP(i_A                => i_A,
           i_B                => i_B,
           o_F                => s_XOR);

  g_XOR_Cin_to_XOR: xorg2 
  port MAP(i_A                => s_XOR,
           i_B                => i_Cin,
           o_F                => o_Sum);

  g_A_B_to_And1: andg2
    port MAP(i_A              => i_A,
             i_B              => i_B,
             o_F              => s_And1);

  g_XOR_Cin_to_And2: andg2
    port MAP(i_A              => s_XOR,
             i_B              => i_Cin,
             o_F              => s_And2);

  g_And1_And2_to_Or: org2
    port MAP(i_A              => s_And1,
             i_B              => s_And2,
             o_F              => o_Cout);
    

  end structure;
