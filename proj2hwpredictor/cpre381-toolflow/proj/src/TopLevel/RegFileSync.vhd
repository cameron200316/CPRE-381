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

entity RegFileSync is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
      i_CLKs       : in std_logic;
      i_FLUSH      : in std_logic;
      i_STALL      : in std_logic; 
      i_WD         : in std_logic_vector(N-1 downto 0);
      o_OUT        : out std_logic_vector(N-1 downto 0)
    );
end RegFileSync;

architecture mixed of RegFileSync is

  component dffgSync is
    port(i_CLK        : in std_logic;     -- Clock input
         i_FSH        : in std_logic;     -- Flush input
         i_STL        : in std_logic;    -- Stall input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_REG: for i in 0 to N-1 generate
    DFF: dffgSync 
    port map(
              i_CLK     => i_CLKs,    
              i_FSH     => i_FLUSH,         
              i_STL     => i_STALL, 
              i_D       => i_WD(i),  
	            o_Q       => o_OUT(i));  
  end generate G_NBit_REG;
  
end mixed;
