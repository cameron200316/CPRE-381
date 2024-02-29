-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- TPU_MV_Element.vhd
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


entity mux2to1DF is

  port(i_D0 		            : in std_logic;
       i_D1		            : in std_logic;
       i_S 		            : in std_logic;
       o_O                          : out std_logic);

end mux2to1DF;

architecture dataflow of mux2to1DF is

  signal s_s0         : std_logic;
  signal s_s1         : std_logic;
  signal s_notS       : std_logic;

begin

  s_notS <= not i_S;
  s_s0 <= s_notS and i_D0;
  s_s1 <= i_S and i_D1;
  o_O <= s_s0 or s_s1;

  end dataflow;
