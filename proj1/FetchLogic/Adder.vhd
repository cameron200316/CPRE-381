-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- adder operating on integer inputs. 
--
--
-- NOTES: Integer data type is not typically useful when doing hardware
-- design. We use it here for simplicity, but in future labs it will be
-- important to switch to std_logic_vector types and associated math
-- libraries (e.g. signed, unsigned). 


-- 8/19/09 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Adder is

  port(i_D2                 : in std_logic;
       i_D1                 : in std_logic;
       i_D0                 : in std_logic;
       o_Sum                : out std_logic;
       o_Cout               : out std_logic);

end Adder;

architecture structure of Adder is

component andg2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_C             : out std_logic);
  end component;

  component invg
    port(i_A             : in std_logic;
         o_F             : out std_logic);
  end component;

  component org2
    port(i_A           	: in std_logic;
         i_B             : in std_logic;
         o_C             : out std_logic);
  end component;

  component xorg2
    port(i_A           	: in std_logic;
         i_B             : in std_logic;
         o_C             : out std_logic);
  end component;	

signal s_notD2            : std_logic;
signal s_xorD1D0          : std_logic; 
signal s_xnorD1D0         : std_logic; 
signal s_xorandnotD2      : std_logic; 
signal s_xnorandD2        : std_logic; 
signal s_D1andD0          : std_logic; 
signal s_D1orD0           : std_logic; 
signal s_D1andD0andnotD2  : std_logic; 
signal s_D1orD0andD2      : std_logic; 

begin
  
  --Gate 1
  notD2: invg
    port MAP(i_A		      => i_D2,
	     o_F		      => s_notD2);

  --Gate 2
  xor1: xorg2
    port MAP(i_A               => i_D1,
             i_B               => i_D0,
             o_C               => s_xorD1D0);

  --Gate 3
  notD1orD0: invg
    port MAP(i_A               => s_xorD1D0,
             o_F               => s_xnorD1D0);

  --Gate 4
  notD1orD0andD2: andg2
    port MAP(i_A               => s_xnorD1D0,
             i_B               => i_D2,
             o_C               => s_xnorandD2);

  --Gate 5
  D1orD0andnotD2: andg2
    port MAP(i_A               => s_xorD1D0,
             i_B               => s_notD2,
             o_C               => s_xorandnotD2);

  --Gate 6
  orS: org2
    port MAP(i_A               => s_xnorandD2,
             i_B               => s_xorandnotD2,
             o_C               => o_Sum);

  --Gate 7
  D1andD0: andg2
    port MAP(i_A               => i_D1,
             i_B               => i_D0,
             o_C               => s_D1andD0);

  --Gate 8
  D1orD0: org2
    port MAP(i_A               => i_D1,
             i_B               => i_D0,
             o_C               => s_D1orD0);

  --Gate 9
  D1andD0andnotD2: andg2
    port MAP(i_A               => s_notD2,
             i_B               => s_D1andD0,
             o_C               => s_D1andD0andnotD2);

  --Gate 10
  D1orD0andD2: andg2
    port MAP(i_A               => i_D2,
             i_B               => s_D1orD0,
             o_C               => s_D1orD0andD2);

  --Gate 11
  orC: org2
    port MAP(i_A               => s_D1andD0andnotD2,
             i_B               => s_D1orD0andD2,
             o_C               => o_Cout);


end structure;
