-------------------------------------------------------------------------
-- Henry Duwe - CPRE 381
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Nbit_dffreg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an dff register 
-- that allows you to create n amount of dffs gates.
--
-- NOTES:
-- 2/1/24 by Mason Kotlarz 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Nbit_dffreg is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_CLK              : in std_logic;
         i_RST              : in std_logic;
         i_WE               : in std_logic;
         i_D                : in std_logic_vector(N-1 downto 0);
         o_Q                : out std_logic_vector(N-1 downto 0));
end Nbit_dffreg;

architecture structural of Nbit_dffreg is

    -- Component Declaration
    component dffg is
        port(i_CLK          : in std_logic;     -- Clock input
             i_RST          : in std_logic;     -- Reset input
             i_WE           : in std_logic;     -- Write enable input
             i_D            : in std_logic;     -- Data value input
             o_Q            : out std_logic);    
    end component;

begin
    -- Component Instantiation
    
    -- Inverter Instantiation
    G_Nbit_reg: for i in 0 to N-1 generate
    Nbit_reg : dffg
        port map (i_CLK         => i_CLK,      
                  i_RST         => i_RST,  
                  i_WE          => i_WE,
                  i_D           => i_D(i),
                  o_Q           => o_Q(i));
    end generate G_Nbit_reg;
    
end structural;