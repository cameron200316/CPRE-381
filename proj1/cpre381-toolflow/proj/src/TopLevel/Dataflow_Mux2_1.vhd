-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Dataflow_Mux2_1.vhd
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


entity Dataflow_Mux2_1 is

  port(i_D0 		           : in std_logic;
       i_D1 		           : in std_logic;
       i_S 		           : in std_logic;
       o_O                         : out std_logic);

end Dataflow_Mux2_1;

architecture dataflow of Dataflow_Mux2_1 is
begin
    o_O <= i_D0 when (i_S = '0') else 
           i_D1 when (i_S = '1') else
           '0';
end dataflow;
