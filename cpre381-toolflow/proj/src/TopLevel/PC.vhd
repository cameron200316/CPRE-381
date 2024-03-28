-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
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

entity PC is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(
       i_WD         : in std_logic_vector(N-1 downto 0);
       i_WEN        : in std_logic; 
       i_CLKs       : in std_logic;
       i_R          : in std_logic;
       o_OUT        : out std_logic_vector(N-1 downto 0));

end PC;

architecture structural of PC is

  component dffg is
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;

  component dffg1 is
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;

begin  

  -- Instantiate N mux instances.
  G_NBit_REG: for i in 0 to 21 generate
    DFF: dffg port map(
              i_CLK     => i_CLKs,    
              i_RST     => i_R,         
              i_WE      => i_WEN, 
              i_D       => i_WD(i),  
	      o_Q       => o_OUT(i));  
  end generate G_NBit_REG; 

  DFF1: dffg1 port map(
              i_CLK     => i_CLKs,    
              i_RST     => i_R,         
              i_WE      => i_WEN, 
              i_D       => i_WD(22),  
	      o_Q       => o_OUT(22)); 

  G_NBit_REG1: for i in 23 to 31 generate
    DFF0: dffg port map(
              i_CLK     => i_CLKs,    
              i_RST     => i_R,         
              i_WE      => i_WEN, 
              i_D       => i_WD(i),  
	      o_Q       => o_OUT(i));  
  end generate G_NBit_REG1; 

end structural;
