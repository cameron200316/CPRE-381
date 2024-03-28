-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RegFile.vhd
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
use IEEE.numeric_std.all;
use work.my_package.all;

entity RegFile is
    port(
         i_ReadAddress1     : in std_logic_vector(5-1 downto 0);
         i_ReadAddress2     : in std_logic_vector(5-1 downto 0);
         i_WriteAddress     : in std_logic_vector(5-1 downto 0);
         i_WriteData        : in std_logic_vector(32-1 downto 0);
         i_Clock            : in std_logic;
         i_Reset            : in std_logic;
         i_WriteEnable      : in std_logic;
         o_ReadData1        : out std_logic_vector(32-1 downto 0);
         o_ReadData2        : out std_logic_vector(32-1 downto 0));
end RegFile;

architecture structural of RegFile is

    -- Component Declaration
    component decoder_5to32 is
        port(
            i_D     : in std_logic_vector(5-1 downto 0);
            o_Q     : out std_logic_vector(32-1 downto 0));
    end component;

    component Nbit_mux_32to1 is
        port(        
            i_Regs  : in t_bus_32x32;
            i_S     : in std_logic_vector(5-1 downto 0);
            o_O     : out std_logic_vector(32-1 downto 0));
    end component;

    component Nbit_dffreg is
        port(
            i_CLK   : in std_logic;
            i_RST   : in std_logic;
            i_WE    : in std_logic;
            i_D     : in std_logic_vector(32-1 downto 0);
            o_Q     : out std_logic_vector(32-1 downto 0));
    end component;

    signal Decoder_to_Regs     : std_logic_vector(32-1 downto 0);
    signal Regs_to_Mux         : t_bus_32x32;

begin
    -- Component Instantiation
    
    -- Decoder Instantiation
    Decoder : decoder_5to32
        port map ( 
            i_D     => i_WriteAddress,
            o_Q     => Decoder_to_Regs
        );
    
    -- Reg $zero Instantiation
    Reg0 : Nbit_dffreg
        port map ( 
            i_CLK   => i_Clock,
            i_RST   => '1',
            i_WE    => Decoder_to_Regs(0),
            i_D     => i_WriteData,
            o_Q     => Regs_to_Mux(0)
        );

    -- Regs Instantiation
    G_N_Regs: for i in 1 to 32-1 generate
        Regs : Nbit_dffreg
            port map ( 
                i_CLK   => i_Clock,
                i_RST   => i_Reset,
                i_WE    => Decoder_to_Regs(i),
                i_D     => i_WriteData,
                o_Q     => Regs_to_Mux(i)
            );
    end generate G_N_Regs;
 
    -- Mux Instantiation
    Mux1 : Nbit_mux_32to1
        port map ( 
            i_Regs  => Regs_to_Mux,   
            i_S     => i_ReadAddress1,
            o_O     => o_ReadData1
        );

    -- Mux Instantiation
    Mux2 : Nbit_mux_32to1
        port map ( 
            i_Regs  => Regs_to_Mux,
            i_S     => i_ReadAddress2,
            o_O     => o_ReadData2
        );
  
end structural;
