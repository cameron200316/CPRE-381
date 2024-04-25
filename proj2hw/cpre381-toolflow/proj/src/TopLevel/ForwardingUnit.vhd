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

--Three cases where we need to forward: 
--1. Data hazard with a distance of 2 cycles
--2. Data hazard with a distance of 1 cycle that is not a lw

entity ForwardingUnit is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_CLKs           : in std_logic;
	i_R              : in std_logic;
        i_WB_WA          : in std_logic_vector(4 downto 0);
        i_MEM_WA         : in std_logic_vector(4 downto 0);  
        i_EX_RS          : in std_logic_vector(4 downto 0);
        i_EX_RT          : in std_logic_vector(4 downto 0);
	i_EX_OPCODE      : in std_logic_vector(5 downto 0);
	i_EX_ALUOUT      : in std_logic_vector(2 downto 0);
	i_MEM_OPCODE     : in std_logic_vector(5 downto 0);
        i_MEM_RegWrite   : in std_logic; 	
	i_WB_RegWrite    : in std_logic;
        o_WB_EX2_RS      : out std_logic;
	o_WB_EX2_RT      : out std_logic;
	o_WB_EX2_R2      : out std_logic;
        o_MEM_EX1_RS     : out std_logic;
        o_MEM_EX1_RT     : out std_logic;
        o_MEM_EX1_R2     : out std_logic;
        o_MEM_EX1_RSLW   : out std_logic;
        o_MEM_EX1_RTLW   : out std_logic;
        o_MEM_EX1_R2LW   : out std_logic);

end ForwardingUnit;

architecture structural of ForwardingUnit is

    component andg2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_C          : out std_logic);
    end component;

    component andg3 is 
  	port(i_A          : in std_logic;
       	     i_B          : in std_logic;
       	     i_C          : in std_logic;
             o_C          : out std_logic);
    end component; 

    component andg4 is 
  	port(i_A          : in std_logic;
       	     i_B          : in std_logic;
       	     i_C          : in std_logic;
       	     i_D          : in std_logic;
             o_C          : out std_logic);
    end component; 

    component andg2_6bit is 
  	port(i_A          : in std_logic_vector(5 downto 0);
       	     i_B          : in std_logic_vector(5 downto 0);
             o_C          : out std_logic);
    end component; 

    component andg2_5bit is 
  	port(i_A          : in std_logic_vector(4 downto 0);
       	     i_B          : in std_logic_vector(4 downto 0);
             o_C          : out std_logic);
    end component; 

    component andg2_3bit is 
  	port(i_A          : in std_logic_vector(2 downto 0);
       	     i_B          : in std_logic_vector(2 downto 0);
             o_C          : out std_logic);
    end component; 

    component invg is
	port(i_A          : in std_logic;
       	     o_F          : out std_logic);
    end component;

    component org2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_C          : out std_logic);
    end component;

    component org3 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             i_C          : in std_logic;
             o_C          : out std_logic);
    end component;

    component RegFile is
    	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   	port(
       		i_WD         : in std_logic_vector(N-1 downto 0);
       		i_WEN        : in std_logic; 
       		i_CLKs       : in std_logic;
       		i_R          : in std_logic;
       		o_OUT        : out std_logic_vector(N-1 downto 0));
    end component;

    component dffg is
	port(i_CLK        : in std_logic;     -- Clock input
       	     i_RST        : in std_logic;     -- Reset input
             i_WE         : in std_logic;     -- Write enable input
             i_D          : in std_logic;     -- Data value input
             o_Q          : out std_logic);   -- Data value output
    end component;


signal s_MEM_EX1_RS  : std_logic := '0';
signal s_MEM_EX1_RT  : std_logic := '0';
signal s_MEM_EX1_R2  : std_logic := '0';

signal s_MEM_EX1_RSLW  : std_logic := '0';
signal s_MEM_EX1_RTLW  : std_logic := '0';

signal s_NOTMEM_EX1_RS  : std_logic := '0';
signal s_NOTMEM_EX1_RT  : std_logic := '0';

signal s_NOTMEM_EX1_RSSHIFT  : std_logic := '0';
signal s_NOTMEM_EX1_RTSHIFT  : std_logic := '0';

signal s_WB_EX2_RS  : std_logic := '0';
signal s_WB_EX2_RT  : std_logic := '0';
signal s_WB_EX2_R2  : std_logic := '0';

signal s_RSZERO     : std_logic := '0';
signal s_RTZERO     : std_logic := '0';

signal s_RSNOTZERO     : std_logic := '0';
signal s_RTNOTZERO     : std_logic := '0';

signal s_LW     : std_logic := '0';
signal s_NOTLW  : std_logic := '0';

signal s_RType     : std_logic := '0';
signal s_BRANCH    : std_logic := '0';
signal s_STORE    : std_logic := '0';

signal s_BRANCHorRTYPE   : std_logic := '0';

signal s_MEM_EX1_RSO  : std_logic := '0';
signal s_MEM_EX1_RTO  : std_logic := '0';

signal s_WB_EX2_RSO  : std_logic := '0';
signal s_WB_EX2_RTO  : std_logic := '0';

signal s_MEM_EX1_RSFINAL  : std_logic := '0';
signal s_MEM_EX1_RTFINAL  : std_logic := '0';
signal s_MEM_EX1_RSLWFINAL  : std_logic := '0';
signal s_MEM_EX1_RTLWFINAL  : std_logic := '0';
signal s_WB_EX2_RSFINAL  : std_logic := '0';
signal s_WB_EX2_RTFINAL  : std_logic := '0';

signal s_shift            : std_logic := '0';
signal s_notshift            : std_logic := '0';

signal s_MEM_EX1_RSSHIFT  : std_logic := '0';
signal s_MEM_EX1_RTSHIFT  : std_logic := '0';

signal s_MEM_EX1_RSLWSHIFT  : std_logic := '0';
signal s_MEM_EX1_RTLWSHIFT  : std_logic := '0';

signal s_WB_EX2_RSSHIFT  : std_logic := '0';
signal s_WB_EX2_RTSHIFT  : std_logic := '0';

signal s_MEM_EX1_RSO2  : std_logic := '0';
signal s_MEM_EX1_RTO2  : std_logic := '0';

signal s_WB_EX2_RSO2  : std_logic := '0';
signal s_WB_EX2_RTO2  : std_logic := '0';

signal s_MEM_EX1_RSNOTSHIFT  : std_logic := '0';
signal s_MEM_EX1_RTNOTSHIFT  : std_logic := '0';

signal s_MEM_EX1_RSLWNOTSHIFT  : std_logic := '0';
signal s_MEM_EX1_RTLWNOTSHIFT  : std_logic := '0';

signal s_WB_EX2_RSNOTSHIFT  : std_logic := '0';
signal s_WB_EX2_RTNOTSHIFT  : std_logic := '0';








begin  

--Distance 2 Data Hazards
  WB_EX2_RS: andg2_5bit port MAP(
	      i_A       => i_WB_WA, 
	      i_B       => i_EX_RS,
	      o_C       => s_WB_EX2_RS);

  WB_EX2_RT: andg2_5bit port MAP(
	      i_A       => i_WB_WA, 
	      i_B       => i_EX_RT,
	      o_C       => s_WB_EX2_RT);

--Distance 1 Data Hazards (not Lw)
  MEM_EX1_RS: andg2_5bit port MAP(
	      i_A       => i_MEM_WA, 
	      i_B       => i_EX_RS,
	      o_C       => s_MEM_EX1_RS);

  MEM_EX1_RT: andg2_5bit port MAP(
	      i_A       => i_MEM_WA, 
	      i_B       => i_EX_RT,
	      o_C       => s_MEM_EX1_RT);

  LW: andg2_3bit port MAP(
	      i_A       => i_MEM_OPCODE(5 downto 3), 
	      i_B       => "100",
	      o_C       => s_LW);

  NOTLW: invg port MAP(
	     i_A          => s_LW, 
       	     o_F          => s_NOTLW);

  and0: andg3 port MAP(
	      i_A       => s_MEM_EX1_RS, 
	      i_B       => i_MEM_RegWrite,
	      i_C       => s_RSNOTZERO,
	      o_C       => s_MEM_EX1_RSO);

  NOTLWRS: andg2
  port MAP(
            i_A       => s_MEM_EX1_RSO,
            i_B       => s_NOTLW,
            o_C       => s_MEM_EX1_RSO2
          );

  LWRS: andg2
  port MAP(
            i_A       => s_MEM_EX1_RSO,
            i_B       => s_LW,
            o_C       => s_MEM_EX1_RSLW
          );

  and1: andg4 port MAP(
	      i_A       => s_MEM_EX1_RT, 
	      i_B       => i_MEM_RegWrite,
	      i_C       => s_RTNOTZERO,
	      i_D       => s_BRANCHorRTYPE, 
	      o_C       => s_MEM_EX1_RTO);

  LWRT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RTO,
            i_B       => s_LW,
            o_C       => s_MEM_EX1_RTLW
          );

  NOTLWRT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RTO,
            i_B       => s_NOTLW,
            o_C       => s_MEM_EX1_RTO2
          );

  o_MEM_EX1_RS <= s_MEM_EX1_RSFINAL;
  o_MEM_EX1_RT <= s_MEM_EX1_RTFINAL;
  o_MEM_EX1_RSLW <= s_MEM_EX1_RSLWFINAL;
  o_MEM_EX1_RTLW <= s_MEM_EX1_RTLWFINAL;
  o_WB_EX2_RS  <= s_WB_EX2_RSFINAL;
  o_WB_EX2_RT  <= s_WB_EX2_RTFINAL;


--Makes sure that distance 1 data hazards are priortized over distance 2 data hazards
  NOTMEM_EX1_RS: invg port MAP(
	     i_A          => s_MEM_EX1_RSFINAL, 
       	     o_F          => s_NOTMEM_EX1_RS);

  NOTMEM_EX1_RSSHIFT: org3
  port MAP(
            i_A       => s_NOTMEM_EX1_RS,
            i_B       => s_shift,
	    i_C       => s_STORE,
            o_C       => s_NOTMEM_EX1_RSSHIFT
          );

  NOTMEM_EX1_RTSHIFT: org3
  port MAP(
            i_A       => s_NOTMEM_EX1_RT,
            i_B       => s_shift,
	    i_C       => s_STORE, 
            o_C       => s_NOTMEM_EX1_RTSHIFT
          );

  NOTMEM_EX1_RT: invg port MAP(
	     i_A          => s_MEM_EX1_RTFINAL, 
       	     o_F          => s_NOTMEM_EX1_RT);

  and2: andg3 port MAP(
	      i_A       => s_WB_EX2_RS, 
	      i_B       => s_NOTMEM_EX1_RSSHIFT,
	      i_C       => s_RSNOTZERO,
	      o_C       => s_WB_EX2_RSO);

  WBCHECK3: andg2
  port MAP(
            i_A       => s_WB_EX2_RSO,
            i_B       => i_WB_RegWrite,
            o_C       => s_WB_EX2_RSO2
          );

  and3: andg4 port MAP(
	      i_A       => s_WB_EX2_RT, 
	      i_B       => s_NOTMEM_EX1_RTSHIFT,
	      i_C       => s_RTNOTZERO,
	      i_D       => s_BRANCHorRTYPE,
	      o_C       => s_WB_EX2_RTO);

  WBCHECK4: andg2
  port MAP(
            i_A       => s_WB_EX2_RTO,
            i_B       => i_WB_RegWrite,
            o_C       => s_WB_EX2_RTO2
          );

  R2_2: andg2
  port MAP(
            i_A       => s_WB_EX2_RT,
            i_B       => s_STORE,
            o_C       => s_WB_EX2_R2
          );

  o_WB_EX2_R2 <= s_WB_EX2_R2;
  o_MEM_EX1_R2 <= s_MEM_EX1_R2;

  R2_1: andg2
  port MAP(
            i_A       => s_MEM_EX1_RT,
            i_B       => s_STORE,
            o_C       => s_MEM_EX1_R2
          );

  LWR2: andg2
  port MAP(
            i_A       => s_MEM_EX1_R2,
            i_B       => s_LW,
            o_C       => o_MEM_EX1_R2LW
          );

--Makes sure theres no forwarding if the RS or RT is zero
  ZERORS: andg2_5bit port MAP(
	      i_A       => "00000", 
	      i_B       => i_EX_RS,
	      o_C       => s_RSZERO);

  ZERORT: andg2_5bit port MAP(
	      i_A       => "00000", 
	      i_B       => i_EX_RT,
	      o_C       => s_RTZERO);

  NOTZERORS: invg port MAP(
	     i_A          => s_RSZERO, 
       	     o_F          => s_RSNOTZERO);

  NOTZERORT: invg port MAP(
	     i_A          => s_RTZERO, 
       	     o_F          => s_RTNOTZERO);

--Checks if EX is an itype instruction
  EX_RType: andg2_6bit port MAP(
	      i_A       => i_EX_OPCODE, 
	      i_B       => "000000",
	      o_C       => s_RType);

  BRANCH: andg2_5bit port MAP(
	      i_A       => i_EX_OPCODE(5 downto 1), 
	      i_B       => "00010",
	      o_C       => s_BRANCH);

  EX_STORE: andg2_6bit port MAP(
	      i_A       => i_EX_OPCODE, 
	      i_B       => "101011",
	      o_C       => s_STORE);


  BRANCHorRTYPE: org2
  port MAP(
            i_A       => s_RType,
            i_B       => s_BRANCH,
            o_C       => s_BRANCHorRTYPE
          );

  SHIFT: andg2_3bit port MAP(
	      i_A       => i_EX_ALUOUT(2 downto 0), 
	      i_B       => "110",
	      o_C       => s_shift);

  NOTSHIFT: invg port MAP(
	     i_A          => s_shift, 
       	     o_F          => s_notshift);

  WB_EX2_RTSHIFT: andg2
  port MAP(
            i_A       => s_WB_EX2_RSO2,
            i_B       => s_shift,
            o_C       => s_WB_EX2_RTSHIFT
          );

  WB_EX2_RSSHIFT: andg2
  port MAP(
            i_A       => s_WB_EX2_RTO2,
            i_B       => s_shift,
            o_C       => s_WB_EX2_RSSHIFT
          );

  MEM_EX1_RTSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RSO2,
            i_B       => s_shift,
            o_C       => s_MEM_EX1_RTSHIFT
          );

  MEM_EX1_RTLWSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RSLW,
            i_B       => s_shift,
            o_C       => s_MEM_EX1_RTLWSHIFT
          );


  MEM_EX1_RSSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RTO2,
            i_B       => s_shift,
            o_C       => s_MEM_EX1_RSSHIFT
          );

  MEM_EX1_RSLWSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RTLW,
            i_B       => s_shift,
            o_C       => s_MEM_EX1_RSLWSHIFT
          );

  WB_EX2_RTNOTSHIFT: andg2
  port MAP(
            i_A       => s_WB_EX2_RTO2,
            i_B       => s_notshift,
            o_C       => s_WB_EX2_RTNOTSHIFT
          );

  WB_EX2_RSNOTSHIFT: andg2
  port MAP(
            i_A       => s_WB_EX2_RSO2,
            i_B       => s_notshift,
            o_C       => s_WB_EX2_RSNOTSHIFT
          );

  MEM_EX1_RTNOTSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RTO2,
            i_B       => s_notshift,
            o_C       => s_MEM_EX1_RTNOTSHIFT
          );

  MEM_EX1_RTLWNOTSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RTLW,
            i_B       => s_notshift,
            o_C       => s_MEM_EX1_RTLWNOTSHIFT
          );

  MEM_EX1_RSNOTSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RSO2,
            i_B       => s_notshift,
            o_C       => s_MEM_EX1_RSNOTSHIFT
          );

  MEM_EX1_RSLWNOTSHIFT: andg2
  port MAP(
            i_A       => s_MEM_EX1_RSLW,
            i_B       => s_notshift,
            o_C       => s_MEM_EX1_RSLWNOTSHIFT
          );

  WB_EX2_RSFINAL: org2
  port MAP(
            i_A       => s_WB_EX2_RSSHIFT,
            i_B       => s_WB_EX2_RSNOTSHIFT,
            o_C       => s_WB_EX2_RSFINAL
          );

  WB_EX2_RTFINAL: org2
  port MAP(
            i_A       => s_WB_EX2_RTSHIFT,
            i_B       => s_WB_EX2_RTNOTSHIFT,
            o_C       => s_WB_EX2_RTFINAL
          );

  MEM_EX1_RSFINAL: org2
  port MAP(
            i_A       => s_MEM_EX1_RSSHIFT,
            i_B       => s_MEM_EX1_RSNOTSHIFT,
            o_C       => s_MEM_EX1_RSFINAL
          );

  MEM_EX1_RTFINAL: org2
  port MAP(
            i_A       => s_MEM_EX1_RTSHIFT,
            i_B       => s_MEM_EX1_RTNOTSHIFT,
            o_C       => s_MEM_EX1_RTFINAL
          );

  MEM_EX1_RSLWFINAL: org2
  port MAP(
            i_A       => s_MEM_EX1_RSLWSHIFT,
            i_B       => s_MEM_EX1_RSLWNOTSHIFT,
            o_C       => s_MEM_EX1_RSLWFINAL
          );

  MEM_EX1_RTLWFINAL: org2
  port MAP(
            i_A       => s_MEM_EX1_RTLWSHIFT,
            i_B       => s_MEM_EX1_RTLWNOTSHIFT,
            o_C       => s_MEM_EX1_RTLWFINAL
          );

end structural;
