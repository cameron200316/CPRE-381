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

entity Reg32File is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_CLKs        : in std_logic;
	i_WE          : in std_logic;
	i_R           : in std_logic;
        i_WD          : in std_logic_vector(N-1 downto 0);
        i_WA          : in std_logic_vector(4 downto 0); 
        i_RS          : in std_logic_vector(4 downto 0);
        i_RT          : in std_logic_vector(4 downto 0);
        o_OUT1        : out std_logic_vector(N-1 downto 0);
        o_OUT0        : out std_logic_vector(N-1 downto 0));

end Reg32File;

architecture structural of Reg32File is

    component Decoder5_32 is 
       port(i_WA         : in std_logic_vector(4 downto 0);
            o_OUT        : out std_logic_vector(N-1 downto 0));
    end component;

    component RegFile is 
       port(i_WD         : in std_logic_vector(N-1 downto 0);
            i_WEN        : in std_logic; 
            i_CLKs       : in std_logic;
            i_R          : in std_logic;
            o_OUT        : out std_logic_vector(N-1 downto 0));
    end component;

    component mux32_1 is 
       port(i_MUX31         : in std_logic_vector(N-1 downto 0);
       	    i_MUX30         : in std_logic_vector(N-1 downto 0);
            i_MUX29         : in std_logic_vector(N-1 downto 0);
            i_MUX28         : in std_logic_vector(N-1 downto 0);
            i_MUX27         : in std_logic_vector(N-1 downto 0);
            i_MUX26         : in std_logic_vector(N-1 downto 0);
            i_MUX25         : in std_logic_vector(N-1 downto 0);
            i_MUX24         : in std_logic_vector(N-1 downto 0);
            i_MUX23         : in std_logic_vector(N-1 downto 0);
            i_MUX22         : in std_logic_vector(N-1 downto 0);
            i_MUX21         : in std_logic_vector(N-1 downto 0);
            i_MUX20         : in std_logic_vector(N-1 downto 0);
            i_MUX19         : in std_logic_vector(N-1 downto 0);
            i_MUX18         : in std_logic_vector(N-1 downto 0);
            i_MUX17         : in std_logic_vector(N-1 downto 0);
            i_MUX16         : in std_logic_vector(N-1 downto 0);
            i_MUX15         : in std_logic_vector(N-1 downto 0);
            i_MUX14         : in std_logic_vector(N-1 downto 0);
            i_MUX13         : in std_logic_vector(N-1 downto 0);
            i_MUX12         : in std_logic_vector(N-1 downto 0);
            i_MUX11         : in std_logic_vector(N-1 downto 0);
            i_MUX10         : in std_logic_vector(N-1 downto 0);
            i_MUX9          : in std_logic_vector(N-1 downto 0);
            i_MUX8          : in std_logic_vector(N-1 downto 0);
            i_MUX7          : in std_logic_vector(N-1 downto 0);
            i_MUX6          : in std_logic_vector(N-1 downto 0);
            i_MUX5          : in std_logic_vector(N-1 downto 0);
            i_MUX4          : in std_logic_vector(N-1 downto 0);
            i_MUX3          : in std_logic_vector(N-1 downto 0);
            i_MUX2          : in std_logic_vector(N-1 downto 0);
            i_MUX1          : in std_logic_vector(N-1 downto 0);
            i_MUX0          : in std_logic_vector(N-1 downto 0);
            i_WA            : in std_logic_vector(4 downto 0);
            o_OUT           : out std_logic_vector(N-1 downto 0));
    end component;

    component andg3 is 
  	port(i_A          : in std_logic;
       	     i_B          : in std_logic;
       	     i_C          : in std_logic;
             o_C          : out std_logic);
    end component; 

    component andg2 is 
  	port(i_A          : in std_logic;
       	     i_B          : in std_logic;
             o_C          : out std_logic);
    end component; 

    component andg2_5bit is 
  	port(i_A          : in std_logic_vector(4 downto 0);
       	     i_B          : in std_logic_vector(4 downto 0);
             o_C          : out std_logic);
    end component; 

    component mux2to1DF is
        port(i_D0 		            : in std_logic;
       	     i_D1		            : in std_logic;
             i_S 		            : in std_logic;
             o_O                            : out std_logic);
    end component;

    component invg is
	port(i_A          : in std_logic;
       	     o_F          : out std_logic);
    end component;


type out32bit is array (0 to 31) of std_logic_vector(31 downto 0);

signal s_WA32  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_WEN32 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_ZERO  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_ONE   : std_logic := '1';
signal s_OUT   : out32bit;
signal s_WARS  : std_logic := '0';
signal s_WART  : std_logic := '0';
signal s_Z     : std_logic := '0';
signal s_notZ  : std_logic := '0';
signal s_WARSZ  : std_logic := '0';
signal s_WARTZ  : std_logic := '0';

signal s_R1  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_R2  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

begin  

  decode5_32: Decoder5_32
	port MAP(i_WA		      => i_WA,
		 o_OUT		      => s_WA32);

  REG0: RegFile 
	port map(i_CLKs    => i_CLKs,    
                 i_R       => i_R,         
              	 i_WEN     => s_ONE, 
              	 i_WD      => s_ZERO,  
	      	 o_OUT     => s_OUT(0));  

  -- Instantiate N mux instances.
  G_NBit_REG: for i in 0 to N-2 generate
    and2: andg2 port MAP(
	      i_A       => i_WE, 
	      i_B       => s_WA32(i+1),
	      o_C       => s_WEN32(i+1));
	  
    REG: RegFile port map(
              i_CLKs    => i_CLKs,    
              i_R       => i_R,         
              i_WEN     => s_WEN32(i+1), 
              i_WD      => i_WD,  
	      o_OUT     => s_OUT(i+1));  
  end generate G_NBit_REG;

  WARS: andg2_5bit port MAP(
	      i_A       => i_WA, 
	      i_B       => i_RS,
	      o_C       => s_WARS);

  WART: andg2_5bit port MAP(
	      i_A       => i_WA, 
	      i_B       => i_RT,
	      o_C       => s_WART);

  ZERO: andg2_5bit port MAP(
	      i_A       => i_WA, 
	      i_B       => "00000",
	      o_C       => s_Z);

  NOTZERO: invg port MAP(
	     i_A          => s_Z, 
       	     o_F          => s_notZ);

  WARSZ: andg3 port MAP(
	      i_A       => s_notZ, 
	      i_B       => s_WARS,
              i_C       => i_WE,
	      o_C       => s_WARSZ);

  WARTZ: andg3 port MAP(
	      i_A       => s_notZ, 
	      i_B       => s_WART,
	      i_C       => i_WE,
	      o_C       => s_WARTZ);

  MUX1_32: for i in 0 to 31 generate
   	MUX1: mux2to1DF port MAP(i_D0 		            => s_R1(i),
       	     			 i_D1		            => i_WD(i),
            			 i_S 		            => s_WARSZ,
            			 o_O                        => o_OUT1(i)); 
  end generate MUX1_32;

  MUX2_32: for i in 0 to 31 generate
   	MUX2: mux2to1DF port MAP(i_D0 		            => s_R2(i),
       	     			 i_D1		            => i_WD(i),
            			 i_S 		            => s_WARTZ,
             			 o_O                        => o_OUT0(i)); 
  end generate MUX2_32;



  mux32_1_0: mux32_1
   port MAP(i_MUX31         =>	s_OUT(31),
       	    i_MUX30         =>	s_OUT(30),
            i_MUX29         =>	s_OUT(29),
            i_MUX28         =>	s_OUT(28),
            i_MUX27         =>	s_OUT(27),
            i_MUX26         =>	s_OUT(26),
            i_MUX25         =>	s_OUT(25),
            i_MUX24         =>	s_OUT(24),
            i_MUX23         =>	s_OUT(23),
            i_MUX22         =>	s_OUT(22),	
            i_MUX21         =>	s_OUT(21),
            i_MUX20         =>	s_OUT(20),	
            i_MUX19         =>	s_OUT(19),
            i_MUX18         =>	s_OUT(18),
            i_MUX17         =>	s_OUT(17),
            i_MUX16         =>	s_OUT(16),
            i_MUX15         =>	s_OUT(15),
            i_MUX14         =>	s_OUT(14),	
            i_MUX13         =>	s_OUT(13),
            i_MUX12         =>	s_OUT(12),
            i_MUX11         =>	s_OUT(11),
            i_MUX10         =>	s_OUT(10),
            i_MUX9          =>	s_OUT(9),
            i_MUX8          =>	s_OUT(8),
            i_MUX7          =>	s_OUT(7),
            i_MUX6          =>	s_OUT(6),
            i_MUX5          =>	s_OUT(5),
            i_MUX4          =>	s_OUT(4),
            i_MUX3          =>	s_OUT(3),
            i_MUX2          =>	s_OUT(2),
            i_MUX1          =>	s_OUT(1),
            i_MUX0          =>	s_OUT(0),
            i_WA            =>	i_RS,
            o_OUT           =>  s_R1);

  mux32_1_1: mux32_1
   port MAP(i_MUX31         =>	s_OUT(31),
       	    i_MUX30         =>	s_OUT(30),
            i_MUX29         =>	s_OUT(29),
            i_MUX28         =>	s_OUT(28),
            i_MUX27         =>	s_OUT(27),
            i_MUX26         =>	s_OUT(26),
            i_MUX25         =>	s_OUT(25),
            i_MUX24         =>	s_OUT(24),
            i_MUX23         =>	s_OUT(23),
            i_MUX22         =>	s_OUT(22),	
            i_MUX21         =>	s_OUT(21),
            i_MUX20         =>	s_OUT(20),	
            i_MUX19         =>	s_OUT(19),
            i_MUX18         =>	s_OUT(18),
            i_MUX17         =>	s_OUT(17),
            i_MUX16         =>	s_OUT(16),
            i_MUX15         =>	s_OUT(15),
            i_MUX14         =>	s_OUT(14),	
            i_MUX13         =>	s_OUT(13),
            i_MUX12         =>	s_OUT(12),
            i_MUX11         =>	s_OUT(11),
            i_MUX10         =>	s_OUT(10),
            i_MUX9          =>	s_OUT(9),
            i_MUX8          =>	s_OUT(8),
            i_MUX7          =>	s_OUT(7),
            i_MUX6          =>	s_OUT(6),
            i_MUX5          =>	s_OUT(5),
            i_MUX4          =>	s_OUT(4),
            i_MUX3          =>	s_OUT(3),
            i_MUX2          =>	s_OUT(2),
            i_MUX1          =>	s_OUT(1),
            i_MUX0          =>	s_OUT(0),
            i_WA            =>	i_RT,
            o_OUT           =>  s_R2);
  

end structural;
