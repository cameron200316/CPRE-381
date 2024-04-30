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

entity IF_ID is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_CLKs        : in std_logic;
	i_Flush       : in std_logic; --this is the flush value
        i_Stall       : in std_logic; --this is the stall value
        
        i_PC4         : in std_logic_vector(N-1 downto 0);
        i_Inst        : in std_logic_vector(N-1 downto 0);
        o_PC4         : out std_logic_vector(N-1 downto 0);
        o_Inst        : out std_logic_vector(N-1 downto 0));

end IF_ID;

architecture structural of IF_ID is

  component RegFileSync is 
  port(
      i_CLKs       : in std_logic;
      i_FLUSH      : in std_logic;
      i_STALL      : in std_logic; 
      i_WD         : in std_logic_vector(N-1 downto 0);
      o_OUT        : out std_logic_vector(N-1 downto 0));
end component;

component dffgSync is
  port(
      i_CLK        : in std_logic;     -- Clock input
      i_FSH        : in std_logic;     -- Reset input
      i_STL        : in std_logic;     -- Stall input
      i_D          : in std_logic;     -- Data value input
      o_Q          : out std_logic);   -- Data value output
end component;

begin  

  REG0: RegFileSync
	port map(
            i_CLKs    => i_CLKs,    
            i_Flush   => i_Flush,         
            i_Stall   => i_Stall, 
            i_WD      => i_PC4,  
	      	  o_OUT     => o_PC4); 

  REG1: RegFileSync 
	port map(
            i_CLKs    => i_CLKs,    
            i_Flush   => i_Flush,         
            i_Stall   => i_Stall, 
            i_WD      => i_Inst,  
	      	  o_OUT     => o_Inst);

end structural;
