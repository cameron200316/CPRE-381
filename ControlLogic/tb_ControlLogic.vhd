-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_ControlLogic.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_ControlLogic is
end tb_ControlLogic;

architecture mixed of tb_ControlLogic is


    component ControlLogic is
        port(
            i_Opcode            : in  std_logic_vector(5 downto 0);
            i_Funct             : in  std_logic_vector(5 downto 0);
            o_RegDst            : out  std_logic;
            o_RegWrite          : out  std_logic;
            o_MemWrite          : out  std_logic;
            o_MemRead           : out  std_logic;
            o_MemToReg          : out  std_logic;
            o_ALUsrc            : out  std_logic;
            o_lw                : out  std_logic;
            o_HoB               : out  std_logic;
            o_sign              : out  std_logic;
            o_Branch            : out  std_logic;
            o_Branch            : out  std_logic;
            o_Return            : out  std_logic;
            o_Link              : out  std_logic;
            o_Jump              : out  std_logic;
            o_ALUnAddSub        : out  std_logic;
            o_ALUout            : out  std_logic_vector(2 downto 0);
            o_ShiftLorR         : out  std_logic;
            o_ShiftArithemtic   : out  std_logic;
            o_Unsigned          : out  std_logic;
            o_Lui               : out  std_logic
        );
    end component;


    -- Signals for testbench
    signal opcode: std_logic_vector(5 downto 0);
    signal funct: std_logic_vector(5 downto 0);
    signal regDst, regWrite, memWrite, memRead, memToReg, aluSrc, lw, HoB, sign, branch, branchne, rturn, link, jump, aluNAddSub, shiftLorR, shiftArithemtic, usigned, lui: std_logic;
    signal aluOut: std_logic_vector(2 downto 0);


begin

    DUT0: ControlLogic
    port map(
        i_Opcode => opcode,
        i_Funct => funct,
        o_RegDst => regDst,
        o_RegWrite => regWrite,
        o_MemWrite => memWrite,
        o_MemRead => memRead,
        o_MemToReg => memToReg,
        o_ALUsrc => aluSrc,
        o_lw => lw,
        o_HoB => HoB,
        o_sign => sign,
        o_Branch => branch,
        o_Branch => branchne,
        o_Return => rturn,
        o_Link => link,
        o_Jump => jump,
        o_ALUnAddSub => aluNAddSub,
        o_ALUout => aluOut,
        o_ShiftLorR => shiftLorR,
        o_ShiftArithemtic => shiftArithemtic,
        o_Unsigned => usigned,
        o_Lui => lui
    );

    -- Test cases
    P_TEST_CASES: process
    begin
        -- R-Type instructions
        opcode <= "000000";
        funct <= "100000";  -- add
        wait for 10 ns;

        opcode <= "000000";
        funct <= "100001";  -- addu
        wait for 10 ns;

        opcode <= "000000";
        funct <= "100100";  -- and
        wait for 10 ns;

        opcode <= "000000";
        funct <= "100111";  -- nor
        wait for 10 ns;

        opcode <= "000000";
        funct <= "100110";  -- xor
        wait for 10 ns;

        opcode <= "000000";
        funct <= "100101";  -- or
        wait for 10 ns;

        opcode <= "000000";
        funct <= "101010";  -- slt
        wait for 10 ns;

        opcode <= "000000";
        funct <= "000000";  -- sll
        wait for 10 ns;

        opcode <= "000000";
        funct <= "000010";  -- srl
        wait for 10 ns;

        opcode <= "000000";
        funct <= "000011";  -- sra
        wait for 10 ns;

        opcode <= "000000";
        funct <= "100010";  -- sub
        wait for 10 ns;

        opcode <= "000000";
        funct <= "100011";  -- subu
        wait for 10 ns;

        opcode <= "000000";
        funct <= "001000";  -- jr
        wait for 10 ns;

        opcode <= "000000";
        funct <= "000100";  -- sllv
        wait for 10 ns;

        opcode <= "000000";
        funct <= "000110";  -- srlv
        wait for 10 ns;

        opcode <= "000000";
        funct <= "000111";  -- srav
        wait for 10 ns;



        -- I-Type instructions
        opcode <= "001000";
        funct <= (others => '0');  -- addi
        wait for 10 ns;

        opcode <= "001001";
        funct <= (others => '0');  -- addiu
        wait for 10 ns;

        opcode <= "001100";
        funct <= (others => '0');  -- andi
        wait for 10 ns;

        opcode <= "001111";
        funct <= (others => '0');  -- lui
        wait for 10 ns;

        opcode <= "100011";
        funct <= (others => '0');  -- lw
        wait for 10 ns;

        opcode <= "001110";
        funct <= (others => '0');  -- xori
        wait for 10 ns;

        opcode <= "001101";
        funct <= (others => '0');  -- ori
        wait for 10 ns;

        opcode <= "001010";
        funct <= (others => '0');  -- slti
        wait for 10 ns;

        opcode <= "101011";
        funct <= (others => '0');  -- sw
        wait for 10 ns;

        -- Branch instructions
        opcode <= "000100";
        funct <= (others => '0');  -- beq
        wait for 10 ns;

        opcode <= "000101";
        funct <= (others => '0');  -- bne
        wait for 10 ns;

        -- J-Type instructions
        opcode <= "000010";
        funct <= (others => '0');  -- j
        wait for 10 ns;

        opcode <= "000011";
        funct <= (others => '0');  -- jal
        wait for 10 ns;

        -- Load/Store instructions
        opcode <= "100000";
        funct <= (others => '0');   -- lb
        wait for 10 ns;

        opcode <= "100100";
        funct <= (others => '0');   -- lbu
        wait for 10 ns;

        opcode <= "100001";
        funct <= (others => '0');   -- lh
        wait for 10 ns;

        opcode <= "100101";
        funct <= (others => '0');   -- lhu
        wait for 10 ns;
        
    wait;
    end process;    

end mixed;
