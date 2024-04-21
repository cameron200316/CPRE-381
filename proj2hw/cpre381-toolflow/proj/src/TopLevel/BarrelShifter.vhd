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

--SRL MUX OUTPUTS
signal s_MUX1OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX2OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX3OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX4OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX5OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

--SLL MUX OUTPUTS
signal s_MUX6OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX7OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX8OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX9OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX10OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

--SRA MUX OUTPUTS
signal s_MUX11OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX12OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX13OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX14OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX15OUT  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

--Signal for the sign
signal s_sign  	: std_logic := '0';


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

  MUX2A_32: for i in 0 to 1 generate
        MUX2A: mux2to1DF
	port MAP(i_D0      => s_MUX1OUT(i+30),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(1),     
                 o_O       => s_MUX2OUT(i+30));
  end generate MUX2A_32;

  --MUXES FOR SRL (4)
  MUX3_32: for i in 0 to 27 generate
        MUX3: mux2to1DF
	port MAP(i_D0      => s_MUX2OUT(i),         
       	         i_D1      => s_MUX2OUT(i+4),    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX3OUT(i));
  end generate MUX3_32;

  MUX3A_32: for i in 0 to 3 generate
        MUX3A: mux2to1DF
	port MAP(i_D0      => s_MUX2OUT(i+28),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX3OUT(i+28));
  end generate MUX3A_32;

  --MUXES FOR SRL (8)
  MUX4_32: for i in 0 to 23 generate
        MUX4: mux2to1DF
	port MAP(i_D0      => s_MUX3OUT(i),         
       	         i_D1      => s_MUX3OUT(i+8),    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX4OUT(i));
  end generate MUX4_32;

  MUX4A_32: for i in 0 to 7 generate
        MUX4A: mux2to1DF
	port MAP(i_D0      => s_MUX3OUT(i+24),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX4OUT(i+24));
  end generate MUX4A_32;

  --MUXES FOR SRL (16)
  MUX5_32: for i in 0 to 15 generate
        MUX5: mux2to1DF
	port MAP(i_D0      => s_MUX4OUT(i),         
       	         i_D1      => s_MUX4OUT(i+16),    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX5OUT(i));
  end generate MUX5_32;

  MUX5A_32: for i in 0 to 15 generate
        MUX5A: mux2to1DF
	port MAP(i_D0      => s_MUX4OUT(i+16),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX5OUT(i+16));
  end generate MUX5A_32;

--MUXES FOR SLL

  --MUXES FOR SLL (1)
  MUX6A: mux2to1DF
       port MAP(i_D0      => i_WD(0),         
       	        i_D1      => '0',    
                i_S 	  => i_SHAMT(0),     
                o_O       => s_MUX6OUT(0));

  MUX6_32: for i in 1 to 31 generate
        MUX6: mux2to1DF
	port MAP(i_D0      => i_WD(i),         
       	         i_D1      => i_WD(i-1),    
                 i_S 	   => i_SHAMT(0),     
                 o_O       => s_MUX6OUT(i));
  end generate MUX6_32;

  --MUXES FOR SLL (2)
  MUX7A_32: for i in 0 to 1 generate
        MUX7A: mux2to1DF
	port MAP(i_D0      => s_MUX6OUT(i),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(1),     
                 o_O       => s_MUX7OUT(i));
  end generate MUX7A_32;

  MUX7_32: for i in 2 to 31 generate
        MUX7: mux2to1DF
	port MAP(i_D0      => s_MUX6OUT(i),         
       	         i_D1      => s_MUX6OUT(i-2),    
                 i_S 	   => i_SHAMT(1),     
                 o_O       => s_MUX7OUT(i));
  end generate MUX7_32;

  --MUXES FOR SLL (4)
  MUX8A_32: for i in 0 to 3 generate
        MUX8A: mux2to1DF
	port MAP(i_D0      => s_MUX7OUT(i),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX8OUT(i));
  end generate MUX8A_32;

  MUX8_32: for i in 4 to 31 generate
        MUX8: mux2to1DF
	port MAP(i_D0      => s_MUX7OUT(i),         
       	         i_D1      => s_MUX7OUT(i-4),    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX8OUT(i));
  end generate MUX8_32;

  --MUXES FOR SLL (8)
  MUX9A_32: for i in 0 to 7 generate
        MUX9A: mux2to1DF
	port MAP(i_D0      => s_MUX8OUT(i),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX9OUT(i));
  end generate MUX9A_32;

  MUX9_32: for i in 8 to 31 generate
        MUX9: mux2to1DF
	port MAP(i_D0      => s_MUX8OUT(i),         
       	         i_D1      => s_MUX8OUT(i-8),    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX9OUT(i));
  end generate MUX9_32;

  --MUXES FOR SLL (16)
  MUX10A_32: for i in 0 to 15 generate
        MUX10A: mux2to1DF
	port MAP(i_D0      => s_MUX9OUT(i),         
       	         i_D1      => '0',    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX10OUT(i));
  end generate MUX10A_32;

  MUX10_32: for i in 16 to 31 generate
        MUX10: mux2to1DF
	port MAP(i_D0      => s_MUX9OUT(i),         
       	         i_D1      => s_MUX9OUT(i-16),    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX10OUT(i));
  end generate MUX10_32;

--MUXES FOR SRA

  -- AND gate used to make sure the signed bit should be one or zero depending on if the the most significant bit is 1 or 0
  and2: andg2
	port MAP(i_A                  => i_signed,
		 i_B                  => i_WD(31),
		 o_C                  => s_sign);

  --MUXES FOR SRA (1)
  MUX11_32: for i in 0 to 30 generate
        MUX11: mux2to1DF
	port MAP(i_D0      => i_WD(i),         
       	         i_D1      => i_WD(i+1),    
                 i_S 	   => i_SHAMT(0),     
                 o_O       => s_MUX11OUT(i));
  end generate MUX11_32;

  MUX11A: mux2to1DF
       port MAP(i_D0      => i_WD(31),         
       	        i_D1      => s_sign,    
                i_S 	  => i_SHAMT(0),     
                o_O       => s_MUX11OUT(31));

  --MUXES FOR SRA (2)
  MUX12_32: for i in 0 to 29 generate
        MUX12: mux2to1DF
	port MAP(i_D0      => s_MUX11OUT(i),         
       	         i_D1      => s_MUX11OUT(i+2),    
                 i_S 	   => i_SHAMT(1),     
                 o_O       => s_MUX12OUT(i));
  end generate MUX12_32;

  MUX12A_32: for i in 0 to 1 generate
        MUX12A: mux2to1DF
	port MAP(i_D0      => s_MUX11OUT(i+30),         
       	         i_D1      => s_sign,    
                 i_S 	   => i_SHAMT(1),     
                 o_O       => s_MUX12OUT(i+30));
  end generate MUX12A_32;

  --MUXES FOR SRA (4)
  MUX13_32: for i in 0 to 27 generate
        MUX13: mux2to1DF
	port MAP(i_D0      => s_MUX12OUT(i),         
       	         i_D1      => s_MUX12OUT(i+4),    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX13OUT(i));
  end generate MUX13_32;

  MUX13A_32: for i in 0 to 3 generate
        MUX13A: mux2to1DF
	port MAP(i_D0      => s_MUX12OUT(i+28),         
       	         i_D1      => s_sign,    
                 i_S 	   => i_SHAMT(2),     
                 o_O       => s_MUX13OUT(i+28));
  end generate MUX13A_32;

  --MUXES FOR SRA (8)
  MUX14_32: for i in 0 to 23 generate
        MUX14: mux2to1DF
	port MAP(i_D0      => s_MUX13OUT(i),         
       	         i_D1      => s_MUX13OUT(i+8),    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX14OUT(i));
  end generate MUX14_32;

  MUX14A_32: for i in 0 to 7 generate
        MUX14A: mux2to1DF
	port MAP(i_D0      => s_MUX13OUT(i+24),         
       	         i_D1      => s_sign,    
                 i_S 	   => i_SHAMT(3),     
                 o_O       => s_MUX14OUT(i+24));
  end generate MUX14A_32;

  --MUXES FOR SRA (16)
  MUX15_32: for i in 0 to 15 generate
        MUX15: mux2to1DF
	port MAP(i_D0      => s_MUX14OUT(i),         
       	         i_D1      => s_MUX14OUT(i+16),    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX15OUT(i));
  end generate MUX15_32;

  MUX15A_32: for i in 0 to 15 generate
        MUX15A: mux2to1DF
	port MAP(i_D0      => s_MUX14OUT(i+16),         
       	         i_D1      => s_sign,    
                 i_S 	   => i_SHAMT(4),     
                 o_O       => s_MUX15OUT(i+16));
  end generate MUX15A_32;

  --MUX for between choosing between the different shift operations
  MUX16_32: for i in 0 to 31 generate
    	MUX16: mux4to1DF port map(
	      i_D3      => s_MUX15OUT(i),    
              i_D2      => s_MUX15OUT(i),	
              i_D1      => s_MUX10OUT(i),    
              i_D0      => s_MUX5OUT(i),         
              i_S0      => i_left,
              i_S1      => i_signed, 
	      o_O       => o_numShifted(i));  
  end generate MUX16_32;  

end structural;
