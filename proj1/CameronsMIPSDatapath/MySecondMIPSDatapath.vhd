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

entity MySecondMIPSDatapath is
   generic 
	(
		N : integer := 32;		
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);
   port(i_CLKs        : in std_logic;
	i_R           : in std_logic;
	i_AddSub      : in std_logic;
	i_ALUSrc      : in std_logic;
	i_memLoad     : in std_logic;
	i_WE   	      : in std_logic;
	i_sign        : in std_logic;
        i_RD          : in std_logic_vector(4 downto 0); 
        i_RS          : in std_logic_vector(4 downto 0);
        i_RT          : in std_logic_vector(4 downto 0);
	i_immediate   : in std_logic_vector(N-17 downto 0));

end MySecondMIPSDatapath;

architecture structural of MySecondMIPSDatapath is

    component Reg32File is 
       port(i_CLKs        : in std_logic;
	    i_R           : in std_logic;
            i_WD          : in std_logic_vector(N-1 downto 0);
            i_WA          : in std_logic_vector(4 downto 0); 
            i_RS          : in std_logic_vector(4 downto 0);
            i_RT          : in std_logic_vector(4 downto 0);
            o_OUT1        : out std_logic_vector(N-1 downto 0);
            o_OUT0        : out std_logic_vector(N-1 downto 0));
    end component;

    component invg
    	port(i_A             : in std_logic;
             o_F             : out std_logic);
    end component;

    component AddSub is 
	port(i_Cin        : in std_logic;
             i_AddSub     : in std_logic;
       	     i_ALUSrc     : in std_logic;  
             i_D1         : in std_logic_vector(N-1 downto 0);
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_regWrite   : in std_logic_vector(N-1 downto 0);
             o_C          : out std_logic_vector(N-1 downto 0);
             o_S          : out std_logic_vector(N-1 downto 0));
    end component;

    component mem is
	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
    end component; 

    component extender16_32 is 
	port(i_data       : in std_logic_vector(N-17 downto 0);
             i_sign       : in std_logic;
             o_OUT        : out std_logic_vector(N-1 downto 0));
    end component; 

   component mux2to1DF is 
	port(i_D0 		            : in std_logic;
             i_D1		            : in std_logic;
             i_S 		            : in std_logic;
             o_O                            : out std_logic);
   end component; 


signal s_OUT1        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_OUT0        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX1OUT     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_extended    : std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; 
signal s_result      : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_gnd         : std_logic := '0';
signal s_ALUout      : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_memOut      : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_addr        : std_logic_vector(9 downto 0) := "0000000000";


begin

  EXTEND: extender16_32
	port MAP(i_data       => i_immediate,
		 i_sign       => i_sign,
		 o_OUT        => s_extended); 

  ADSB: AddSub
	port MAP(i_Cin        => i_AddSub,
                 i_AddSub     => i_AddSub,
       	         i_ALUSrc     => i_ALUSrc,  
                 i_D1         => s_OUT1,
                 i_D0         => s_OUT0,
                 i_regWrite   => s_extended,
                 o_C          => s_result,
                 o_S          => s_ALUout);	

  G_NBit_MUX1: for i in 0 to N-1 generate
    MUX1: mux2to1DF port map(
              i_D0     => s_ALUout(i),
	      i_D1     => s_memOut(i),
	      i_S      => i_memLoad,
              o_O      => s_MUX1OUT(i));  
  end generate G_NBit_MUX1;

  REG: Reg32File 
	port MAP(i_CLKs        => i_CLKs,
	         i_R           => i_R,
                 i_WD          => s_MUX1OUT,
                 i_WA          => i_RD,
                 i_RS          => i_RS,
                 i_RT          => i_RT,
                 o_OUT1        => s_OUT1,
                 o_OUT0        => s_OUT0);

  G_NBit_DEEXTEND: for i in 0 to N-23 generate
        s_addr(i)     <= s_ALUout(i);  
  end generate G_NBit_DEEXTEND;

  dmem: mem
	port MAP(clk           => i_CLKS,
		 addr          => s_addr,
		 data          => s_OUT1,
		 we            => i_WE,
		 q             => s_memOut);

end structural;
