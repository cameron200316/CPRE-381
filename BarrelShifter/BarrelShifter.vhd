-------------------------------------------------------------------------
-- Cameron Gilbertson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- BarrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This is the barrel shifter for project part 1 for
-- CPRE-381
--
--
-- NOTES:
-- 2/28/24 by Cameron Gilbertson.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity BarrelShifter is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_signed      : in std_logic;
        i_left	      : in std_logic;
        i_WD          : in std_logic_vector(N-1 downto 0);
        i_SHAMT       : in std_logic_vector(4 downto 0);
        o_numShifted  : out std_logic_vector(N-1 downto 0));

end BarrelShifter;

architecture structural of BarrelShifter is

    component BarrelDecoder5_32 is 
       port(i_WA         : in std_logic_vector(4 downto 0);
            o_OUT        : out std_logic_vector(N-1 downto 0));
    end component;

    component mux4to1DF is
	port(i_D0 		            : in std_logic;
       	     i_D1		            : in std_logic;
             i_D2		            : in std_logic;
             i_D3		            : in std_logic;
             i_S0 		            : in std_logic;
             i_S1 		            : in std_logic;
             o_O                            : out std_logic);
    end component;

    component andg2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_C          : out std_logic);
    end component;

    component mux2to1DF is
  	port(i_D0 		            : in std_logic;
             i_D1		            : in std_logic;
             i_S 		            : in std_logic;
             o_O                          : out std_logic);
    end component;

signal s_MUX1OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX2OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX3OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX4OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX5OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

begin  

--MUXES FOR SRL
  
  --MUXES FOR SRL (1)
  MUX1_32: for i in 0 to 30 generate
        MUX1: mux2to1DF
	port MAP(i_D0      => i_WD(i),         
       	         i_D1      => i_WD(i+1),    
                 i_S 	   => i_SHAMT(0),     
                 o_O       => s_MUX1OUT(i));
  end generate MUX1_32;

  MUX1A: mux2to1DF
       port MAP(i_D0      => i_WD(31),         
       	        i_D1      => '0',    
                i_S 	  => i_SHAMT(0),     
                o_O       => s_MUX1OUT(31));

  --MUXES FOR SRL (2)
  MUX2_32: for i in 0 to 29 generate
        MUX2: mux2to1DF
	port MAP(i_D0      => s_MUX1OUT(i),         
       	         i_D1      => s_MUX1OUT(i+2),    
                 i_S 	   => i_SHAMT(1),     
                 o_O       => s_MUX2OUT(i));
  end generate MUX2_32;

  MUX2A_32: for i in 0 to 2 generate
        MUX2A: mux2to1DF
	port MAP(i_D0      => s_MUX1OUT(i+29),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(1),     
                 o_O       => s_MUX2OUT(i+29));
  end generate MUX2A_32;

  --MUXES FOR SRL (3)
  MUX3_32: for i in 0 to 27 generate
        MUX3: mux2to1DF
	port MAP(i_D0      => s_MUX2OUT(i),         
       	         i_D1      => s_MUX2OUT(i+4),    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX3OUT(i));
  end generate MUX3_32;

  MUX3A_32: for i in 0 to 4 generate
        MUX3A: mux2to1DF
	port MAP(i_D0      => s_MUX2OUT(i+27),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX3OUT(i+27));
  end generate MUX3A_32;

  --MUXES FOR SRL (4)
  MUX4_32: for i in 0 to 23 generate
        MUX4: mux2to1DF
	port MAP(i_D0      => s_MUX3OUT(i),         
       	         i_D1      => s_MUX3OUT(i+8),    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX4OUT(i));
  end generate MUX4_32;

  MUX4A_32: for i in 0 to 8 generate
        MUX4A: mux2to1DF
	port MAP(i_D0      => s_MUX3OUT(i+23),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX4OUT(i+23));
  end generate MUX4A_32;

  --MUXES FOR SRL (5)
  MUX5_32: for i in 0 to 15 generate
        MUX5: mux2to1DF
	port MAP(i_D0      => s_MUX4OUT(i),         
       	         i_D1      => s_MUX4OUT(i+16),    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX5OUT(i));
  end generate MUX5_32;

  MUX5A_32: for i in 0 to 16 generate
        MUX5A: mux2to1DF
	port MAP(i_D0      => s_MUX4OUT(i+15),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX5OUT(i+15));
  end generate MUX5A_32;

end structural;
