library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.my_package.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_MIPS_Datapath is
    generic(gCLK_HPER   : time := 50 ns);
end tb_MIPS_Datapath;

architecture behavior of tb_MIPS_Datapath is

    constant cCLK_PER  : time := gCLK_HPER * 2;
  
    component MIPS_Datapath
        port (
            -- Clock, Reset, and Write Enable
            i_Clock         : in  std_logic;
            i_Reset         : in  std_logic;
            i_WriteEnable   : in  std_logic;

            -- Control signals
            i_nAdd_Sub      : in  std_logic; --Controls Adding or Subtracting
            i_ALU_Src       : in  std_logic; --Controls Immediate Value or Register Value
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
    end component;


    -- Temporary signals to connect to the decoder component.
    -- Clock, Reset, and Write Enable
    signal s_i_Clock         :  std_logic;
    signal s_i_Reset         :  std_logic;
    signal s_i_WriteEnable   :  std_logic;

    -- Control signals
    signal s_i_nAdd_Sub      :  std_logic; --Controls Adding or Subtracting
    signal s_i_ALU_Src       :  std_logic; --Controls Immediate Value or Register Value
    signal s_i_LoadStore     :  std_logic;
    signal s_i_Sign          :  std_logic;

    -- Register file ports
    signal s_i_RegDst        :  std_logic_vector(4 downto 0); --Register Desination Address
    signal s_i_IMM           :  std_logic_vector(15 downto 0); --Register Desination Data
    signal s_i_RegRs         :  std_logic_vector(4 downto 0); --Register Source Address
    signal s_i_RegRt         :  std_logic_vector(4 downto 0); --Register Target Addres

    signal s_o_extender        :  std_logic_vector(31 downto 0);
    signal s_o_mem_q           :  std_logic_vector(31 downto 0);
    signal s_o_DataRs        :  std_logic_vector(31 downto 0); --Register Source Data
    signal s_o_DataRt        :  std_logic_vector(31 downto 0); --Register Target Data
    signal s_o_ALUOut        :  std_logic_vector(31 downto 0);
begin

  DUT: MIPS_Datapath 
    port map(
        i_Clock         => s_i_Clock,
        i_Reset         => s_i_Reset,
        i_WriteEnable   => s_i_WriteEnable,

        -- Control signals
        i_nAdd_Sub      => s_i_nAdd_Sub,
        i_ALU_Src       => s_i_ALU_Src,
        i_LoadStore     => s_i_LoadStore,
        i_Sign          => s_i_Sign,

        -- Register file ports
        i_RegDst        => s_i_RegDst,
        i_Imm           => s_i_Imm,
        i_RegRs         => s_i_RegRs,
        i_RegRt         => s_i_RegRt,

        o_extender      => s_o_extender,
        o_mem_q         => s_o_mem_q,
        o_DataRs        => s_o_DataRs,
        o_DataRt        => s_o_DataRt,
        o_ALUOut        => s_o_ALUOut);
  
    P_CLK: process
    begin
        s_i_Clock <= '0';
        wait for cCLK_PER;
        s_i_Clock <= '1';
        wait for cCLK_PER;
    end process;
 
    -- Testbench process  
    P_TB: process
    begin

        wait for cCLK_PER;
        s_i_Reset <= '1';
        wait for cCLK_PER;
        s_i_Reset <= '0';
        wait for cCLK_PER;

        -- Test Case 1: addi $25, $0, 0 # Load &A into $25
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '1'; 
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "11001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00000";
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 2: addi $26, $0, 256 # Load &B into $26
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '1'; 
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "11010"; 
        s_i_IMM <= "0000000100000000";  
        s_i_RegRs <= "00000";
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 3: lw $1, 0($25) # Load A[0] into $1
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "00001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "11001"; 
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 4: lw $2, 4($25) # Load A[1] into $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "00010"; 
        s_i_IMM <= "0000000000000100";  
        s_i_RegRs <= "11001"; 
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 5: add $1, $1, $2 # $1 = $1 + $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00010"; 
        s_i_Sign <= '0';

        -- Test Case 6: sw $1, 0($26) # Store $1 into B[0]
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00000";
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "11010"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 7: lw $2, 8($25) # Load A[2] into $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0'; 
        s_i_ALU_Src <= '1'; 
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "00010"; 
        s_i_IMM <= "0000000000001000";  
        s_i_RegRs <= "11001"; 
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 8: add $1, $1, $2 # $1 = $1 + $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '1'; 
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00010"; 
        s_i_RegRt <= "00010"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 9: sw $1, 4($26) # Store $1 into B[1]
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0'; 
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00000";
        s_i_IMM <= "0000000000000100";  
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00110"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 10: lw $2, 12($25) # Load A[3] into $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "00010"; 
        s_i_IMM <= "0000000000001100";  
        s_i_RegRs <= "11001"; 
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 11: add $1, $1, $2 # $1 = $1 + $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '1'; 
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00010"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 12: sw $1, 8($26) # Store $1 into B[2]
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00000";
        s_i_IMM <= "0000000000001000";  
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00110"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 13: lw $2, 16($25) # Load A[4] into $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "00010"; 
        s_i_IMM <= "0000000000010000";  
        s_i_RegRs <= "11001"; 
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 14: add $1, $1, $2 # $1 = $1 + $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '1'; 
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00010"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 15: sw $1, 12($26) # Store $1 into B[3]
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00000";
        s_i_IMM <= "0000000000001100";  
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00110"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 16: lw $2, 20($25) # Load A[5] into $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "00010"; 
        s_i_IMM <= "0000000000010100";  
        s_i_RegRs <= "11001"; 
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 17: add $1, $1, $2 # $1 = $1 + $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '1'; 
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00010"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 18: sw $1, 16($26) # Store $1 into B[4]
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00000";
        s_i_IMM <= "0000000000010000";  
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00110"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 19: lw $2, 24($25) # Load A[6] into $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '1'; 
        s_i_RegDst <= "00010"; 
        s_i_IMM <= "0000000000011000";  
        s_i_RegRs <= "11001"; 
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 20: add $1, $1, $2 # $1 = $1 + $2
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '1'; 
        s_i_ALU_Src <= '0'; 
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00001"; 
        s_i_IMM <= "0000000000000000"; 
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "00010"; 
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 21: addi $27, $0, 512 # Load &B[64] into $27
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '1'; 
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "11011"; 
        s_i_IMM <= "0000000001000000"; 
        s_i_RegRs <= "00000";
        s_i_RegRt <= "00000";
        s_i_Sign <= '0';
        wait for cCLK_PER;

        -- Test Case 22: sw $1, -4($27) # Store $1 into B[63]
        s_i_WriteEnable <= '1';
        s_i_nAdd_Sub <= '0';
        s_i_ALU_Src <= '0';
        s_i_LoadStore <= '0'; 
        s_i_RegDst <= "00000";
        s_i_IMM <= "1111111111111100"; 
        s_i_RegRs <= "00001"; 
        s_i_RegRt <= "11011"; 
        s_i_Sign <= '1';
        wait for cCLK_PER;

        wait;
    end process;
  
end behavior;
