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


entity Nbit_org2 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A 		           : in std_logic_vector(N-1 downto 0);
       i_B                 : in std_logic_vector(N-1 downto 0);
       o_O               : out std_logic_vector(N-1 downto 0));

end Nbit_org2;

architecture structural of Nbit_org2 is

       component org2 is
         port(i_A                  : in std_logic;
              i_B                  : in std_logic;
              o_C                  : out std_logic);
       end component;
     
     begin
     
       -- Instantiate N invg instances.
       G_NBit_org2: for i in 0 to N-1 generate
         Name: org2 port map(
                   i_A      => i_A(i),      -- All instances share the same select input.
                   i_B      => i_B(i),
                   o_C      => o_O(i));  -- ith instance's data output hooked up to ith data output.
       end generate G_NBit_org2;
       
end structural;
