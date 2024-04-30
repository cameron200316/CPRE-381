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

entity BranchPredictor is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_CLKs        	: in std_logic;
	i_R       	: in std_logic;
	i_branch_taken	: in std_logic;
	i_ex_branch    	: in std_logic;
	o_branch_pred   : out std_logic;
	o_notBranch_pred: out std_logic);

end BranchPredictor;

architecture structural of BranchPredictor is

    component andg2 is 
  	port(i_A          : in std_logic;
       	     i_B          : in std_logic;
             o_C          : out std_logic);
    end component; 

    component invg is
	port(i_A          : in std_logic;
       	     o_F          : out std_logic);
    end component;

    component org2 is
        port(
            i_A             : in std_logic;
            i_B             : in std_logic;
            o_C             : out std_logic
        );
    end component;

   component dffg is
     port(i_CLK        : in std_logic;     -- Clock input
          i_RST        : in std_logic;     -- Reset input
          i_WE         : in std_logic;     -- Write enable input
          i_D          : in std_logic;     -- Data value input
          o_Q          : out std_logic);   -- Data value output
   end component;


signal s_notEX_branch   	: std_logic;
signal s_branchTakenEX          : std_logic;
signal s_branch_pred            : std_logic;
signal s_notBranch_pred         : std_logic;
signal s_branchPred             : std_logic;
signal s_WD                     : std_logic;


begin  

    not1: invg port MAP(
        i_A      => i_ex_branch, 
        o_F      => s_notEX_branch
    );

    not2: invg port MAP(
        i_A      => s_branch_pred, 
        o_F      => s_notBranch_pred
    );

    and1 : andg2 port map(
        i_A      => i_branch_taken,
        i_B      => i_ex_branch,
        o_C      => s_branchTakenEX
    ); 

    and2 : andg2 port map(
        i_A      => s_notEX_branch,
        i_B      => s_branch_pred,
        o_C      => s_branchPred
    ); 

    or1 : org2 port map(
        i_A      => s_branchPred,
        i_B      => s_branchTakenEX,
        o_C      => s_WD
    );

      DFF: dffg port map(
              i_CLK     => i_CLKs,    
              i_RST     => i_R,         
              i_WE      => '1', 
              i_D       => s_WD,  
	      o_Q       => s_branch_pred);  
 
    o_branch_pred  <= s_branch_pred; 
    o_notBranch_pred <= s_notBranch_pred;
  

end structural;
