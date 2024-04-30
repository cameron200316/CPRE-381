-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- andg2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input AND 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity andg2_6bit is

  port(i_A          : in std_logic_vector(5 downto 0);
       i_B          : in std_logic_vector(5 downto 0);
       o_C          : out std_logic);

end andg2_6bit;

architecture dataflow of andg2_6bit is

signal s0  : std_logic;
signal s1  : std_logic;
signal s2  : std_logic;
signal s3  : std_logic;
signal s4  : std_logic;

begin

  s0 <= (i_A(0) xnor i_B(0));

  s1 <= (i_A(1) xnor i_B(1)) and s0;

  s2 <= (i_A(2) xnor i_B(2)) and s1;

  s3 <= (i_A(3) xnor i_B(3)) and s2;

  s4 <= (i_A(4) xnor i_B(4)) and s3;

  o_C <= (i_A(5) xnor i_B(5)) and s4;
  
end dataflow;
