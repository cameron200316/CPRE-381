-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
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

entity ALU is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        i_A                 : in std_logic_vector(N-1 downto 0);
        i_B                 : in std_logic_vector(N-1 downto 0);
        i_Imm               : in std_logic_vector(N-1 downto 0);
        i_nAdd_Sub          : in std_logic;
        i_ALU_Src           : in std_logic;
        o_C                 : out std_logic_vector(N-1 downto 0));
end ALU;

architecture structural of ALU is

    -- Component Declaration
    component Nbit_AddSub is
        port(
            i_A             : in std_logic_vector(N-1 downto 0);
            i_B             : in std_logic_vector(N-1 downto 0);
            i_nAdd_Sub      : in std_logic;
            o_Sum           : out std_logic_vector(N-1 downto 0);
            o_Carry_Out     : out std_logic);
    end component;

    component mux2t1_N is
        port (
            i_D0            : in std_logic_vector(N-1 downto 0);
            i_D1            : in std_logic_vector(N-1 downto 0);
            i_S             : in std_logic;
            o_O             : out std_logic_vector(N-1 downto 0));
    end component;

    signal AddSub_Reg_toMUX : std_logic_vector(N-1 downto 0);
    signal AddSub_Imm_toMUX : std_logic_vector(N-1 downto 0);

begin
    -- Component Instantiation
    
    -- Adder_Subtractor Instantiation
    add_sub_reg : Nbit_AddSub
        port map ( 
            i_A         => i_A,
            i_B         => i_B,
            i_nAdd_Sub  => i_nAdd_Sub,
            o_Sum       => AddSub_Reg_toMUX,
            o_Carry_Out => open
        );

    add_sub_imm : Nbit_AddSub
        port map ( 
            i_A         => i_A,
            i_B         => i_Imm,
            i_nAdd_Sub  => i_nAdd_Sub,
            o_Sum       => AddSub_Imm_toMUX,
            o_Carry_Out => open
        );

    -- Mux Instantiation
    mux : mux2t1_N
        port map ( 
            i_S         => i_ALU_Src,
            i_D0        => AddSub_Reg_toMUX,
            i_D1        => AddSub_Imm_toMUX,
            o_O         => o_C
        );

end structural;
