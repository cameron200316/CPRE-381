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

entity MEM_WB is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(

   i_CLKs               : in std_logic;
	i_Flush                  : in std_logic;
  i_Stall                   : in std_logic;
	i_RegWrite           : in std_logic;
        i_WD        	     : in std_logic_vector(N-1 downto 0);
        i_PC4        	     : in std_logic_vector(N-1 downto 0);
        i_Inst       	     : in std_logic_vector(N-1 downto 0);
        i_WA       	     : in std_logic_vector(4 downto 0);
        i_Link              : in std_logic;
        i_Halt               : in std_logic;
        i_Ovfl               : in std_logic;
	o_RegWrite           : out std_logic;	
        o_WD        	     : out std_logic_vector(N-1 downto 0);
        o_PC4        	     : out std_logic_vector(N-1 downto 0);
        o_Inst        	     : out std_logic_vector(N-1 downto 0);
        o_WA       	     : out std_logic_vector(4 downto 0);
        o_Link              : out std_logic;
        o_Halt               : out std_logic;
        o_Ovfl               : out std_logic);

end MEM_WB;

architecture structural of MEM_WB is

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

  --DFF for the write address
  WA: for i in 0 to 4 generate
    DFF1: dffgSync port map(
      i_CLK     => i_CLKs,    
      i_FSH     => i_Flush,         
      i_STL     => i_Stall, 
              i_D       => i_WA(i),  
	      o_Q       => o_WA(i));  
  end generate WA; 

  --DFF for link
  LINK: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_Link,  
	      o_Q       => o_Link); 

  --Reg for PC+4
  REG2: RegFileSync 
	port map(
    i_CLKs    => i_CLKs,    
    i_Flush   => i_Flush,         
    i_Stall   => i_Stall, 
              	 i_WD      => i_PC4,  
	      	 o_OUT     => o_PC4); 

  --Reg for Instruction
  REG1: RegFileSync 
	port map(
    i_CLKs    => i_CLKs,    
    i_Flush   => i_Flush,         
    i_Stall   => i_Stall, 
             	 i_WD      => i_Inst,  
	      	 o_OUT     => o_Inst);

  --DFF for RegWrite
  REGWRITE: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_RegWrite,  
	      o_Q       => o_RegWrite); 

  --DFF for halt
  halt: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
        i_D       => i_Halt,  
    o_Q       => o_Halt);  

  --DFF for Overflow
  ovfl: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
        i_D       => i_Ovfl,  
    o_Q       => o_Ovfl);  


  --Reg for data that may be written to a register
  REG0: RegFileSync 
	port map(
    i_CLKs    => i_CLKs,    
    i_Flush   => i_Flush,         
    i_Stall   => i_Stall, 
             	 i_WD      => i_WD,  
	      	 o_OUT     => o_WD);

end structural;
