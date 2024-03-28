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

entity extender16_32 is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_data       : in std_logic_vector(N-17 downto 0);
        i_sign       : in std_logic;
        o_OUT        : out std_logic_vector(N-1 downto 0));

end extender16_32;

architecture structural of extender16_32 is

  component mux2to1DF is
    port(i_D0 		            : in std_logic;
         i_D1		            : in std_logic;
         i_S 		            : in std_logic;
         o_O                        : out std_logic);
  end component;

  component org2 is 
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_C          : out std_logic);
  end component;

  component andg2 is 
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_C          : out std_logic);
  end component;

signal s_data 	    	  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_notMaskedData    : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_mask 	    	  : std_logic_vector(31 downto 0) := "11111111111111110000000000000000"; 
signal s_maskedData 	  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";   
signal s_negative   	  : std_logic := '0'; 

begin  
  
  ANDG: andg2
    port MAP(i_A       => i_data(15),
	     i_B       => i_sign,
	     o_C       => s_negative);

  -- Instantiate N mux instances.
  G_NBit_OR: for i in 0 to N-17 generate
    ORG: org2 port map(
              i_A      => i_data(i),
	      i_B      => s_data(i),
	      o_C      => s_notMaskedData(i));  
  end generate G_NBit_OR;

  -- Instantiate N mux instances.
  G_NBit_OR1: for i in 0 to N-1 generate
    ORG1: org2 port map(
              i_A      => s_mask(i),
	      i_B      => s_notMaskedData(i),
	      o_C      => s_maskedData(i));  
  end generate G_NBit_OR1;
 
  -- Instantiate N mux instances.
  G_NBit_MUX: for i in 0 to N-1 generate
    MUX: mux2to1DF port map(
              i_D0     => s_notMaskedData(i),
	      i_D1     => s_maskedData(i),
	      i_S      => s_negative,
              o_O      => o_OUT(i));  
  end generate G_NBit_MUX;
  
end structural;
