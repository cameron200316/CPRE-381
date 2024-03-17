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
             o_F          : out std_logic);
    end component;

--Array Declaration 
type out32bit is array (31 downto 0,31 downto 0) of std_logic;

--Will be used later and explained there
signal shifts  		: integer := 0;

--Used for the signed ANDED with the most significant bit of WD
signal s_sign   	: std_logic := '0';

--Will be used for the selection lines for all the muxs
signal s_shiftEN 	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

--Array with 32 32 bit wide elements 
--Used to keep track of the outputs of all the MUXS
signal s_OUT   		: out32bit := ("00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000",
			      	       "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000",
			               "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000",
			               "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000",
			               "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000",
			               "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000",
			               "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000",
			               "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000");

begin  

  -- Special Decoder that makes each bit 1 for each position (ex. i_SHAMT = 00101, s_shiftEN "00...0011111")
  decode5_32: BarrelDecoder5_32
	port MAP(i_WA		      => i_SHAMT,
		 o_OUT		      => s_shiftEN); 

  -- AND gate used to make sure the signed bit should be one or zero depending on if the the most significant bit is 1 or 0
  and2: andg2
	port MAP(i_A                  => i_signed,
		 i_B                  => i_WD(31),
		 o_F                  => s_sign);
  
  -- Creates the 1st MUX of the first layer
  -- These have to be done seperately inorder to bring in the new 0
  MUX6: mux4to1DF port map(
	      i_D3      => '0',    
              i_D2      => i_WD(0),	
              i_D1      => i_WD(1),    
              i_D0      => i_WD(0),         
              i_S0      => s_shiftEN(0),
              i_S1      => i_left, 
	      o_O       => s_OUT(0,0)); 	     
  
  -- Creates the first layer of MUXs 
  -- The first layer has to be created seperately because it has WD as its inputs
  G_NBit_MUX3: for i in 1 to N-2 generate
    	MUX1: mux4to1DF port map(
	      i_D3      => i_WD(i-1),    
              i_D2      => i_WD(i),	
              i_D1      => i_WD(i+1),    
              i_D0      => i_WD(i),         
              i_S0      => s_shiftEN(0),
              i_S1      => i_left, 
	      o_O       => s_OUT(0,i));  
  end generate G_NBit_MUX3;  
  
  -- Creates the 31st MUX of the first layer
  -- These have to be done seperately inorder to use the sign bit for D1
  MUX: mux4to1DF port map(
	      i_D3      => i_WD(30),    
              i_D2      => i_WD(31),	
              i_D1      => s_sign,    
              i_D0      => i_WD(31),         
              i_S0      => s_shiftEN(0),
              i_S1      => i_left, 
	      o_O       => s_OUT(0,31)); 

  -- Creates the rest of the MUXs
  G_NBit_MUX1: for i in 1 to N-1 generate
    
  -- Creates the 1st MUX of the layer
  MUX7: mux4to1DF port map(
	      i_D3      => '0',    
              i_D2      => s_OUT(i-1, 0),	
              i_D1      => s_OUT(i-1, 1),    
              i_D0      => s_OUT(i-1, 0),         
              i_S0      => s_shiftEN(i),
              i_S1      => i_left, 
	      o_O       => s_OUT(i,0));


     G_NBit_MUX2: for j in 1 to N-2 generate
    	MUX5: mux4to1DF port map(
	      i_D3      => s_OUT(i-1, j-1),    
              i_D2      => s_OUT(i-1, j),	
              i_D1      => s_OUT(i-1, j+1),    
              i_D0      => s_OUT(i-1, j),         
              i_S0      => s_shiftEN(i),
              i_S1      => i_left, 
	      o_O       => s_OUT(i,j)); 
     end generate G_NBit_MUX2;  
  
  -- Creates the 31st MUX of the layer 
  MUX4: mux4to1DF port map(
	      i_D3      => s_OUT(i-1, 30),    
              i_D2      => s_OUT(i-1, 31),	
              i_D1      => s_sign,    
              i_D0      => s_OUT(i-1, 31),         
              i_S0      => s_shiftEN(i),
              i_S1      => i_left, 
	      o_O       => s_OUT(i,31)); 
  end generate G_NBit_MUX1;

  -- Converts the SHAMT to a integer
  -- This will be used to grab the final shifted value
  shifts <= to_integer(unsigned(i_SHAMT));

  -- Copies the final shifted value.
  G_NBit_OUTPUT: for i in 0 to N-1 generate
        o_numShifted(i)     <= s_OUT(shifts, i);  
  end generate G_NBit_OUTPUT;

end structural;
