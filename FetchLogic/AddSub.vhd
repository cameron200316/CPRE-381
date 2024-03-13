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

entity AddSub is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Cin        : in std_logic;
       i_AddSub     : in std_logic;
       i_ALUSrc     : in std_logic;  
       i_D1         : in std_logic_vector(N-1 downto 0);
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_regWrite   : in std_logic_vector(N-1 downto 0);
       o_C          : out std_logic_vector(N-1 downto 0);
       o_S          : out std_logic_vector(N-1 downto 0));

end AddSub;

architecture structural of AddSub is

  component invg
    port(i_A             : in std_logic;
         o_F             : out std_logic);
  end component;

  component mux2to1DF is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component; 

  component Adder is
    port(i_D2                  : in std_logic;
         i_D1                  : in std_logic;
         i_D0                  : in std_logic;
	 o_Sum                 : out std_logic;
         o_Cout                : out std_logic);
  end component;

signal s_notD0   : std_logic_vector(31 downto 0);
signal s_O       : std_logic_vector(31 downto 0);
signal s_O0      : std_logic_vector(31 downto 0);

begin

  MUX1: mux2to1DF
	port map(i_S          => i_ALUSrc,      
                 i_D0         => i_D0(0),  
                 i_D1         => i_regWrite(0), 
                 o_O          => s_O(0)); 

  invert: invg
	port map(i_A          => s_O(0),      
                 o_F          => s_notD0(0));  

  mux: mux2to1DF
	port map(i_S          => i_AddSub,      
                 i_D0         => s_O(0),  
                 i_D1         => s_notD0(0), 
                 o_O          => s_O0(0));

  fullAdd: Adder 
	port map(i_D2         => i_Cin,      
                 i_D1         => i_D1(0),  
                 i_D0         => s_O0(0), 
                 o_Sum        => o_S(0),
	         o_Cout       => o_C(0));  


  -- Instantiate N mux instances.
  G_NBit_ADD: for i in 0 to N-2 generate
    
    INV: invg 
	port map(i_A          => s_O(i+1),      
                 o_F          => s_notD0(i+1));  

    MUX: mux2to1DF
	port map(i_S          => i_AddSub,      
                 i_D0         => s_O(i+1),  
                 i_D1         => s_notD0(i+1), 
                 o_O          => s_O0(i+1));

    MUX2: mux2to1DF
	port map(i_S          => i_ALUSrc,      
                 i_D0         => i_D0(i+1),  
                 i_D1         => i_regWrite(i+1), 
                 o_O          => s_O(i+1));  
  

    ADD: Adder port map(
              i_D2     => o_C(i),     -- All instances share the same select input.
              i_D1     => i_D1(i+1),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D0     => s_O0(i+1),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_Sum    => o_S(i+1),   -- ith instance's data output hooked up to ith data output.
	      o_Cout   => o_C(i+1));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_ADD;
  
end structural;
