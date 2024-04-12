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
	      i_R           : in std_logic;
        i_PC4         : in std_logic_vector(N-1 downto 0);
        i_Inst        : in std_logic_vector(N-1 downto 0);
        o_PC4         : out std_logic_vector(N-1 downto 0);
        o_Inst        : out std_logic_vector(N-1 downto 0));

end IF_ID;

architecture structural of IF_ID is

    component RegFile is 
       port(i_WD         : in std_logic_vector(N-1 downto 0);
            i_WEN        : in std_logic; 
            i_CLKs       : in std_logic;
            i_R          : in std_logic;
            o_OUT        : out std_logic_vector(N-1 downto 0));
    end component;

begin  

  REG0: RegFile 
	port map(i_CLKs    => i_CLKs,    
                 i_R       => i_R,         
              	 i_WEN     => '1', 
              	 i_WD      => i_PC4,  
	      	 o_OUT     => o_PC4); 

  REG1: RegFile 
	port map(i_CLKs    => i_CLKs,    
                 i_R       => i_R,         
              	 i_WEN     => '1', 
             	 i_WD      => i_Inst,  
	      	 o_OUT     => o_Inst);

end structural;
