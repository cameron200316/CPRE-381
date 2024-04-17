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
        i_branchne      : in std_logic;
        i_return        : in std_logic;
        i_zero          : in std_logic;
        i_ra            : in std_logic_vector(N-1 downto 0);
        i_instruction25 : in std_logic_vector(25 downto 0);
        i_instruction16   : in std_logic_vector(N-1 downto 0);
        i_PC4           : in std_logic_vector(N-1 downto 0);
        o_JorBorJr      : out std_logic;
        o_NEWPC         : out std_logic_vector(N-1 downto 0));

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

    component mux2t1_N is
	port(i_D0 		            : in std_logic_vector(N-1 downto 0);
       	     i_D1		            : in std_logic_vector(N-1 downto 0);
             i_S 		            : in std_logic;
             o_O                            : out std_logic_vector(N-1 downto 0));

    end component;

    component andg2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_C          : out std_logic);
    end component;

    component org2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_C          : out std_logic);
    end component;

    component invg is
	port(i_A          : in std_logic;
             o_F          : out std_logic);
    end component;

signal s_branchE 	: std_logic;
signal s_branchNE  	: std_logic;
signal s_notZero  	: std_logic;
signal s_branchChoice   : std_logic;

signal s_Jump1	 	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_Instruction	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

signal s_Branch		: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_Jump2		: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX1OUT	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal s_MUX2OUT	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

signal s_null		: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

begin  

  ALU1: AddSub
	port MAP(i_Cin        => '0',
       	         i_AddSub     => '0',
                 i_ALUSrc     => '0', 
                 i_D1         => i_PC4,
                 i_D0         => s_Branch,
                 i_regWrite   => "00000000000000000000000000000000",
                 o_C          => s_null,
                 o_S          => s_Jump2);

  SHIFTLEFT2_1: for i in 0 to 25 generate
        s_Jump1(i+2)     <= i_instruction25(i);  
  end generate SHIFTLEFT2_1;

  SHIFTLEFT2_2: for i in 0 to 29 generate
        s_Branch(i+2)     <= i_instruction16(i);  
  end generate SHIFTLEFT2_2;

  UPPER: for i in 28 to 31 generate
        s_Jump1(i)     <= i_PC4(i);  
  end generate UPPER;

  notG: invg
	port MAP(
            i_A                  => i_zero,
		        o_F                  => s_notZero
          );

  and2a: andg2
	port MAP(
            i_A                  => i_branch,
            i_B                  => i_zero,
            o_C                  => s_branchE
          );

  and2b: andg2
	port MAP(
            i_A                  => i_branchne,
            i_B                  => s_notZero,
            o_C                  => s_branchNE
          );

  or2a: org2
	port MAP(
            i_A                  => s_branchE,
            i_B                  => s_branchNE,
            o_C                  => s_branchChoice
          );

  or2b: org2
  port MAP(
            i_A       => s_branchChoice,
            i_B       => i_jump,
            o_C       => o_JorBorJr
          );

  MUX1: mux2t1_N
	port MAP(
            i_D0      => i_PC4,         
            i_D1      => s_Jump2,    
            i_S 	    => s_branchChoice,     
            o_O       => s_MUX1OUT
          );

  MUX2: mux2t1_N
	port MAP(
            i_D0      => s_MUX1OUT,         
            i_D1      => s_Jump1,    
            i_S       => i_jump,     
            o_O       => s_MUX2OUT
          );

  MUX3: mux2t1_N
	port MAP(
            i_D0      => s_MUX2OUT,         
            i_D1      => i_ra,    
            i_S       => i_return,     
            o_O       => o_NEWPC
          );



end structural;
