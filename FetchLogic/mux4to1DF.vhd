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


entity mux4to1DF is

  port(i_D0 		            : in std_logic;
       i_D1		            : in std_logic;
       i_D2		            : in std_logic;
       i_D3		            : in std_logic;
       i_S0 		            : in std_logic;
       i_S1 		            : in std_logic;
       o_O                          : out std_logic);

end mux4to1DF;

architecture dataflow of mux4to1DF is

  signal s_d0          : std_logic;
  signal s_d1          : std_logic;
  signal s_d2          : std_logic;
  signal s_d3          : std_logic;
  signal s_notS0       : std_logic;
  signal s_notS1       : std_logic;

begin

  s_notS0 <= not i_S0;
  s_notS1 <= not i_S1;
  s_d0    <= s_notS0 and s_notS1 and i_D0;
  s_d1    <= i_S0 and s_notS1 and i_D1;
  s_d2    <= s_notS0 and i_S1 and i_D2;
  s_d3    <= i_S0 and i_S1 and i_D3;
  o_O     <=  s_d0 or s_d1 or s_d2 or s_d3;

  end dataflow;
