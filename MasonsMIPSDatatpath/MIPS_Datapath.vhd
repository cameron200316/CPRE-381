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
use IEEE.numeric_std.all;
use work.my_package.all;

entity MIPS_Datapath is
    port (
        -- Clock, Reset, and Write Enable
        i_Clock         : in  std_logic;
        i_Reset         : in  std_logic;
        i_WriteEnable   : in  std_logic;

        -- Control signals
        i_nAdd_Sub      : in  std_logic; --Controls Adding or Subtracting
        i_ALU_Src        : in  std_logic; --Controls Immediate Value or Register Value
        i_LoadStore     : in  std_logic; --Switch for Load (1) / Store (0)
        i_Sign          : in  std_logic;

        -- Register file ports
        i_RegDst        : in  std_logic_vector(4 downto 0); --Register Desination Address
        i_Imm           : in  std_logic_vector(15 downto 0); --Immediate Register Data
        i_RegRs         : in  std_logic_vector(4 downto 0); --Register Source Address
        i_RegRt         : in  std_logic_vector(4 downto 0); --Register Target Addres

        --outputs just for verifying if it works
        o_extender      : out std_logic_vector(31 downto 0);
        o_mem_q         : out std_logic_vector(31 downto 0);
        o_DataRs        : out std_logic_vector(31 downto 0); --Register Source Data
        o_DataRt        : out std_logic_vector(31 downto 0); --Register Target Data
        o_ALUOut        : out std_logic_vector(31 downto 0));
end entity MIPS_Datapath;

architecture structural of MIPS_Datapath is


    component RegFile is
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
    end component;

    component ALU is
        port(
            i_A                 : in std_logic_vector(32-1 downto 0);
            i_B                 : in std_logic_vector(32-1 downto 0);
            i_Imm               : in std_logic_vector(32-1 downto 0);
            i_nAdd_Sub          : in std_logic;
            i_ALU_Src           : in std_logic;
            o_C                 : out std_logic_vector(32-1 downto 0));
    end component;

    component mem is
        generic (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );
        port (
            clk     : in std_logic;
            addr    : in std_logic_vector((ADDR_WIDTH-1) downto 0);
            data    : in std_logic_vector((DATA_WIDTH-1) downto 0);
            we      : in std_logic;
            q       : out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    end component;

    component extender is
        port (
            i_switch         : in  std_logic;
            i_input          : in  std_logic_vector(15 downto 0);
            o_output         : out std_logic_vector(31 downto 0)
        );
    end component;

    component mux2t1_N is
        port (
            i_D0            : in std_logic_vector(31 downto 0);
            i_D1            : in std_logic_vector(31 downto 0);
            i_S             : in std_logic;
            o_O             : out std_logic_vector(31 downto 0));
    end component;

    component downextender is
        port (
            i_input          : in  std_logic_vector(31 downto 0);
            o_output         : out std_logic_vector(9 downto 0)
        );
    end component;

    signal RegData_Src, RegData_Trg, ALUData : std_logic_vector(31 downto 0);
    signal Extender_Output, Memory_Output : std_logic_vector(31 downto 0);
    signal Mux_Output : std_logic_vector(31 downto 0);
    signal DownExtender_Output : std_logic_vector(9 downto 0); -- Output of down-extender

begin

  -- Component Instantiation
    
    -- ALU Instantiation
    ALU_comp : ALU
        port map ( 
            i_A             => RegData_Src,
            i_B             => RegData_Trg,
            i_Imm           => Extender_Output,
            i_nAdd_Sub      => i_nAdd_Sub,
            i_ALU_Src       => i_ALU_Src,
            o_C             => ALUData
        );

    -- Reg Instantiation
    RegFile_comp : RegFile
        port map ( 
            i_ReadAddress1  => i_RegRs,
            i_ReadAddress2  => i_RegRt,
            i_WriteAddress  => i_RegDst,
            i_WriteData     => ALUData,
            i_Clock         => i_Clock,
            i_Reset         => i_Reset,
            i_WriteEnable   => i_WriteEnable,
            o_ReadData1     => RegData_Src,
            o_ReadData2     => RegData_Trg
        );

    Memory : mem 
        port map (
            clk             => i_Clock, 
            addr            => DownExtender_Output,
            data            => RegData_Src,
            we              => i_LoadStore,
            q               => Memory_Output
        );
    
    extendatron : extender 
        port map (
            i_switch        => i_Sign,
            i_input         => i_Imm, 
            o_output        => Extender_Output
        );
    
    Mux : mux2t1_N
        port map (
            i_D0            => RegData_Src, 
            i_D1            => Memory_Output, 
            i_S             => i_LoadStore, 
            o_O             => Mux_Output
        );
    
    dextendatron : downextender 
        port map (
            i_input         => RegData_Trg,
            o_output        => DownExtender_Output
        );

    -- Output data from register file
    o_extender <= Extender_Output;
    o_mem_q <= Memory_Output;
    o_DataRs <= RegData_Src;
    o_DataRt <= RegData_Trg;
    o_ALUOut <= ALUData;


end structural;
