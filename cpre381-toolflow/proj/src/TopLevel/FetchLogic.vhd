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

entity FetchLogic is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_jump          : in std_logic;
        i_branch        : in std_logic;
        i_return        : in std_logic;
        i_zero          : in std_logic;
        i_init          : in std_logic;
        i_CLK           : in std_logic;
        i_ra            : in std_logic_vector(N-1 downto 0);
        i_instruction25 : in std_logic_vector(25 downto 0);
        i_instruction16 : in std_logic_vector(N-1 downto 0);
        o_PCNEW         : out std_logic_vector(N-1 downto 0));

end FetchLogic;

architecture structural of FetchLogic is

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

    component mux2to1DF is
	port(i_D0 		            : in std_logic;
       	     i_D1		            : in std_logic;
             i_S 		            : in std_logic;
             o_O                            : out std_logic);

    end component;

    component andg2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_C          : out std_logic);
    end component;

    component RegFile is
   	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   	port(i_WD         : in std_logic_vector(N-1 downto 0);
       	     i_WEN        : in std_logic; 
             i_CLKs       : in std_logic;
             i_R          : in std_logic;
             o_OUT        : out std_logic_vector(N-1 downto 0));
    end component;

signal s_branchChoice   : std_logic := '0';

signal s_PC4	 	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_Jump1	 	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_Instruction	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

signal s_Branch		: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_Jump2		: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

signal s_MUX1OUT	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX2OUT	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX3OUT	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX4OUT	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_init   	: std_logic_vector(31 downto 0) := "00000000010000000000000000000000";

signal s_null		: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

begin  

  ALU1: AddSub
	port MAP(i_Cin        => '0',
       	         i_AddSub     => '0',
                 i_ALUSrc     => '0', 
                 i_D1         => o_PCNEW,
                 i_D0         => "00000000000000000000000000000100",
                 i_regWrite   => "00000000000000000000000000000000",
                 o_C          => s_null,
                 o_S          => s_PC4);

  SHIFTLEFT2_1: for i in 0 to 25 generate
        s_Jump1(i+2)     <= i_instruction25(i);  
  end generate SHIFTLEFT2_1;

  SHIFTLEFT2_2: for i in 0 to 29 generate
        s_Branch(i+2)     <= i_instruction16(i);  
  end generate SHIFTLEFT2_2;

  UPPER: for i in 28 to 31 generate
        s_Jump1(i)     <= s_PC4(i);  
  end generate UPPER;

  ALU2: AddSub
	port MAP(i_Cin        => '0',
       	         i_AddSub     => '0',
                 i_ALUSrc     => '0', 
                 i_D1         => s_PC4,
                 i_D0         => s_Branch,
                 i_regWrite   => "00000000000000000000000000000000",
                 o_C          => s_null,
                 o_S          => s_Jump2);

  and2: andg2
	port MAP(i_A                  => i_branch,
		 i_B                  => i_zero,
		 o_C                  => s_branchChoice);
  MUX1_32: for i in 0 to N-1 generate
        MUX1: mux2to1DF
	port MAP(i_D0      => s_PC4(i),         
       	         i_D1      => s_Jump2(i),    
                 i_S 	   => s_branchChoice,     
                 o_O       => s_MUX1OUT(i));
  end generate MUX1_32;

  MUX2_32: for i in 0 to N-1 generate
  	MUX2: mux2to1DF
	port MAP(i_D0      => s_MUX1OUT(i),         
       	         i_D1      => s_Jump1(i),    
                 i_S       => i_jump,     
                 o_O       => s_MUX2OUT(i));
  end generate MUX2_32;

  MUX3_32: for i in 0 to N-1 generate
  	MUX3: mux2to1DF
	port MAP(i_D0      => s_MUX2OUT(i),         
       	         i_D1      => i_ra(i),    
                 i_S       => i_return,     
                 o_O       => s_MUX3OUT(i));
  end generate MUX3_32;
  
  MUX4_32: for i in 0 to N-1 generate
  	MUX4: mux2to1DF
	port MAP(i_D0      => s_MUX3OUT(i),         
       	         i_D1      => s_init(i),    
                 i_S       => i_init,     
                 o_O       => s_MUX4OUT(i));
  end generate MUX4_32;

  PC: RegFile  
	port MAP(i_WD         => s_MUX4OUT,
       		 i_WEN        => '1',
       		 i_CLKs       => i_CLK,
       		 i_R          => '0',
       		 o_OUT        => o_PCNEW);

end structural;
