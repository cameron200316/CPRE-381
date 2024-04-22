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
   port(i_WB_WA          : in std_logic_vector(4 downto 0);
        i_MEM_WA         : in std_logic_vector(4 downto 0);  
        i_EX_RS          : in std_logic_vector(4 downto 0);
        i_EX_RT          : in std_logic_vector(4 downto 0);
	i_EX_OPCODE      : in std_logic_vector(5 downto 0);
	i_MEM_OPCODE     : in std_logic_vector(5 downto 0);
        o_WB_EX2_RS      : out std_logic;
	o_WB_EX2_RT      : out std_logic;
        o_MEM_EX1_RS     : out std_logic;
        o_MEM_EX1_RT     : out std_logic);

end ForwardingUnit;

architecture structural of ForwardingUnit is

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

signal s_MEM_EX1_RS  : std_logic := '0';
signal s_MEM_EX1_RT  : std_logic := '0';

signal s_NOTMEM_EX1_RS  : std_logic := '0';
signal s_NOTMEM_EX1_RT  : std_logic := '0';

signal s_WB_EX2_RS  : std_logic := '0';
signal s_WB_EX2_RT  : std_logic := '0';

signal s_RSZERO     : std_logic := '0';
signal s_RTZERO     : std_logic := '0';

signal s_RSNOTZERO     : std_logic := '0';
signal s_RTNOTZERO     : std_logic := '0';

signal s_LW     : std_logic := '0';
signal s_NOTLW  : std_logic := '0';

signal s_RType     : std_logic := '0';
signal s_BRANCH    : std_logic := '0';

signal s_BRANCHorRTYPE    : std_logic := '0';

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
	      i_B       => s_NOTLW,
	      i_C       => s_RSNOTZERO,
	      o_C       => o_MEM_EX1_RS);

  and1: andg4 port MAP(
	      i_A       => s_MEM_EX1_RT, 
	      i_B       => s_NOTLW,
	      i_C       => s_RTNOTZERO,
	      i_D       => s_RType,
	      o_C       => o_MEM_EX1_RT);


--Makes sure that distance 1 data hazards are priortized over distance 2 data hazards
  NOTMEM_EX1_RS: invg port MAP(
	     i_A          => s_MEM_EX1_RS, 
       	     o_F          => s_NOTMEM_EX1_RS);

  NOTMEM_EX1_RT: invg port MAP(
	     i_A          => s_MEM_EX1_RT, 
       	     o_F          => s_NOTMEM_EX1_RT);

  and2: andg3 port MAP(
	      i_A       => s_WB_EX2_RS, 
	      i_B       => s_NOTMEM_EX1_RS,
	      i_C       => s_RSNOTZERO,
	      o_C       => o_WB_EX2_RS);

  and3: andg4 port MAP(
	      i_A       => s_WB_EX2_RT, 
	      i_B       => s_NOTMEM_EX1_RT,
	      i_C       => s_RTNOTZERO,
	      i_D       => s_BRANCHorRTYPE,
	      o_C       => o_WB_EX2_RT);

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

  BRANCHorRTYPE: org2
  port MAP(
            i_A       => s_RType,
            i_B       => s_BRANCH,
            o_C       => s_BRANCHorRTYPE
          );

end structural;
