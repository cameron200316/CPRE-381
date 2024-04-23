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

entity EX_MEM is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_CLKs               : in std_logic;
	i_Flush                  : in std_logic;
       i_Stall                   : in std_logic;

	i_Lw                 : in std_logic;
	i_HoB                : in std_logic;
	i_Sign               : in std_logic;
	i_MemWrite           : in std_logic;
	i_MemtoReg           : in std_logic;
	i_RegWrite           : in std_logic;
        i_B        	     : in std_logic_vector(N-1 downto 0);
        i_r2             : in std_logic_vector(N-1 downto 0);
        i_Final        	     : in std_logic_vector(N-1 downto 0);
        i_PC4        	     : in std_logic_vector(N-1 downto 0);
        i_Inst       	     : in std_logic_vector(N-1 downto 0);
        i_WA       	     : in std_logic_vector(4 downto 0);
        i_Link              : in std_logic;
        i_Halt               : in std_logic;
        i_Ovfl               : in std_logic;
	o_Lw                 : out std_logic;
	o_HoB                : out std_logic;
	o_Sign               : out std_logic;
	o_MemWrite           : out std_logic;
	o_MemtoReg           : out std_logic;
	o_RegWrite           : out std_logic;
        o_B        	     : out std_logic_vector(N-1 downto 0);
        o_r2             : out std_logic_vector(N-1 downto 0);
        o_Final        	     : out std_logic_vector(N-1 downto 0);
        o_PC4        	     : out std_logic_vector(N-1 downto 0);
        o_Inst        	     : out std_logic_vector(N-1 downto 0);
        o_WA       	     : out std_logic_vector(4 downto 0);
        o_Link              : out std_logic;
        o_Halt               : out std_logic;
        o_Ovfl               : out std_logic);

end EX_MEM;

architecture structural of EX_MEM is

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

  --Reg for r2
  R2: RegFileSync 
	port map(
    i_CLKs    => i_CLKs,    
    i_Flush   => i_Flush,         
    i_Stall   => i_Stall, 
              	 i_WD      => i_r2,  
	      	 o_OUT     => o_r2); 

  --DFF for link
  LINK: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_Link,  
	      o_Q       => o_Link); 

  --Reg for PC+4
  REG0: RegFileSync 
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

  --DFF for Load Word
  LW: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_Lw,  
	      o_Q       => o_Lw);  

  --DFF for HoB
  HOB: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_HoB,  
	      o_Q       => o_HoB);  

  --DFF for Sign
  SIGN: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_Sign,  
	      o_Q       => o_Sign);  

  --DFF for MemWrite
  MEMWRITE: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_MemWrite,  
	      o_Q       => o_MemWrite);  

  --DFF for MemtoReg
  MEMTOREG: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_MemtoReg,  
	      o_Q       => o_MemtoReg);  

  --DFF for RegWrite
  REGWRITE: dffgSync port map(
    i_CLK     => i_CLKs,    
    i_FSH     => i_Flush,         
    i_STL     => i_Stall, 
              i_D       => i_RegWrite,  
	      o_Q       => o_RegWrite); 

  --Reg for the output from the ALU 
  REG2: RegFileSync 
	port map(
    i_CLKs    => i_CLKs,    
    i_Flush   => i_Flush,         
    i_Stall   => i_Stall, 
             	 i_WD      => i_Final,  
	      	 o_OUT     => o_Final);

  --Reg for B input to the ALU
  REG3: RegFileSync 
	port map(
    i_CLKs    => i_CLKs,    
    i_Flush   => i_Flush,         
    i_Stall   => i_Stall, 
             	 i_WD      => i_B,  
	      	 o_OUT     => o_B);

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

end structural;
