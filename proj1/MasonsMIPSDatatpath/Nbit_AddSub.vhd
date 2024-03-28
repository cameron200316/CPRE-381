-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Nbit_AddSub.vhd
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

entity Nbit_AddSub is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_A               : in std_logic_vector(N-1 downto 0);
         i_B               : in std_logic_vector(N-1 downto 0);
         i_nAdd_Sub        : in std_logic;
         o_Sum             : out std_logic_vector(N-1 downto 0);
         o_Carry_Out       : out std_logic);
end Nbit_AddSub;

architecture structural of Nbit_AddSub is

    -- Component Declaration
    component Complementor is
        port(i_A 		  : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component mux2t1_N is
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component Nbit_full_adder is
        port(i_A          : in std_logic_vector(N-1 downto 0);
             i_B          : in std_logic_vector(N-1 downto 0);
             i_Cin        : in std_logic;
             o_Sum        : out std_logic_vector(N-1 downto 0);
             o_Cout       : out std_logic);
    end component;

    signal Complementor_to_Mux     : std_logic_vector(N-1 downto 0);
    signal Mux_to_Adder            : std_logic_vector(N-1 downto 0);

begin
    -- Component Instantiation
    
    -- Inverter Instantiation
    Nbit_Inverter : Complementor
        port map ( 
            i_A         => i_B,
            o_O         => Complementor_to_Mux
        );
    
    -- Mux Instantiation
    Nbit_2to1Mux : mux2t1_N
        port map ( 
            i_S         => i_nAdd_Sub,
            i_D0        => i_B,
            i_D1        => Complementor_to_Mux,
            o_O         => Mux_to_Adder
        );
 
    -- Adder Instantiation
    Nbit_Adder : Nbit_full_adder
        port map ( 
            i_A         => i_A,
            i_B         => Mux_to_Adder,
            i_Cin       => i_nAdd_Sub,
            o_Sum       => o_Sum,
            o_Cout      => o_Carry_Out
        );
  
end structural;
