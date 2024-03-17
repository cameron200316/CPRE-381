-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
--use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  --Control Logic signals
  signal s_Jump            : std_logic := '0'; 
  signal s_Branch          : std_logic := '0';  
  signal s_Return          : std_logic := '0';  
  signal s_Link            : std_logic := '0';  
  signal s_RegDst          : std_logic := '0';  
  signal s_RegWrite        : std_logic := '0';  
  signal s_MemWrite        : std_logic := '0';  
  signal s_MemRead         : std_logic := '0';  
  signal s_MemtoReg        : std_logic := '0';  
  signal s_ALUSrc          : std_logic := '0';  
  signal s_ALUnAddSub      : std_logic := '0';  
  signal s_ALUout          : std_logic_vector(2 downto 0) := "000";  
  signal s_ShiftLorR       : std_logic := '0';  
  signal s_ShiftArithemtic : std_logic := '0';  
  signal s_Unsigned        : std_logic := '0';  
  signal s_Lui         	   : std_logic := '0';  
  signal s_lw              : std_logic := '0';  
  signal s_HoB             : std_logic := '0';  
  signal s_sign            : std_logic := '0'; 

  --PC
  signal s_PCNEW     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; 

  --Register signals
  signal s_RS     : std_logic_vector(4 downto 0) := "00000";
  signal s_RT     : std_logic_vector(4 downto 0) := "00000";
  signal s_WA     : std_logic_vector(4 downto 0) := "00000";
  signal s_WD     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_R1     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_R2     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --ALU signals
  signal s_B    	   : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_final    	   : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_zero            : std_logic := '0'; 
  signal s_overflow        : std_logic := '0'; 
  signal s_carryOut        : std_logic := '0'; 
  signal s_negative        : std_logic := '0'; 

  --16 bit Extender Output
  signal s_immediate    	   : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --MUX OUTPUTS
  signal s_MUX2OUT         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUX3OUT         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUX4OUT         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUX6OUT         : std_logic_vector(4 downto 0) := "00000";

  --Sign Extender Outputs for LH, LB
  signal s_unsignedByte         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_unsignedHalfword     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_signedByte         	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_signedHalfword     	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  component mem is
    generic(ADDR_WIDTH : integer := 10;
            DATA_WIDTH : integer := 32);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
   
    component ALU is
    generic(N : integer := 32); 
    port (
        --32bit number inputs
        i_A                 : in std_logic_vector(N-1 downto 0);
        i_B                 : in std_logic_vector(N-1 downto 0);

        --ALU operation selection line
        i_ALUout            : in std_logic_vector(3-1 downto 0);
        i_nAdd_Sub          : in std_logic;
        i_ShiftArithemtic   : in std_logic;
        i_ShiftLorR         : in std_logic;
        i_Unsigned          : in std_logic;
        i_Lui               : in std_logic;

        --Output
        o_Final             : out std_logic_vector(N-1 downto 0);
        o_Carry_Out         : out std_logic;
        o_Zero              : out std_logic;
        o_Negative          : out std_logic;
        o_Overflow          : out std_logic
    );
    end component;

   component FetchLogic is
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
    end component;

   component RegFile is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(
         i_ReadAddress1     : in std_logic_vector(5-1 downto 0);
         i_ReadAddress2     : in std_logic_vector(5-1 downto 0);
         i_WriteAddress     : in std_logic_vector(5-1 downto 0);
         i_WriteData        : in std_logic_vector(N-1 downto 0);
         i_Clock            : in std_logic;
         i_Reset            : in std_logic;
         i_WriteEnable      : in std_logic;
         o_ReadData1        : out std_logic_vector(N-1 downto 0);
         o_ReadData2        : out std_logic_vector(N-1 downto 0));
    end component;

   component ControlLogic is
   port (
        -- Opcode and Funct
        i_Opcode            : in  std_logic_vector(5 downto 0); --the first 6 bits [31..26] 
        i_Funct             : in  std_logic_vector(5 downto 0); --the last 6 bits [5..0]

        -- Register and Memory Operations
        o_RegDst            : out  std_logic; 
        o_RegWrite          : out  std_logic; 
        o_MemWrite          : out  std_logic; 
        o_MemRead           : out  std_logic; 
        o_MemToReg          : out  std_logic; 

        -- Immediate into ALU 
        o_ALUsrc            : out  std_logic; 

	--lw, lh, lhu, lb, lbu selection
        o_lw                : out  std_logic;
        o_HoB               : out  std_logic; 
        o_sign              : out  std_logic;  
        
        -- PC Logic
        o_Branch            : out  std_logic; 
        o_Return            : out  std_logic; 
        o_Link              : out  std_logic; 
        o_Jump              : out  std_logic; 

        -- ALU Operations
        o_ALUnAddSub        : out  std_logic; 
        o_ALUout            : out  std_logic_vector(2 downto 0); --3 bits to determine the type of operation
        o_ShiftLorR         : out  std_logic;
        o_ShiftArithemtic   : out  std_logic;
        o_Unsigned          : out  std_logic;
        o_Lui               : out  std_logic);
    end component;

   component mux2to1DF is
   port(i_D0 		            : in std_logic;
        i_D1		            : in std_logic;
        i_S 		            : in std_logic;
        o_O                         : out std_logic);
   end component;

   component mux4to1DF is
   port(i_D0 		            : in std_logic;
        i_D1		            : in std_logic;
        i_D2		            : in std_logic;
        i_D3		            : in std_logic;
        i_S0 		            : in std_logic;
        i_S1 		            : in std_logic;
        o_O                          : out std_logic);
   end component;

   component extender16_32 is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_data       : in std_logic_vector(N-17 downto 0);
        i_sign       : in std_logic;
        o_OUT        : out std_logic_vector(N-1 downto 0));
   end component;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    port map(clk  => iCLK,
             addr => s_final(11 downto 2),
             data => s_R2,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

  CL: ControlLogic
	port MAP(
        i_Opcode            => s_Inst(31 downto 26),
        i_Funct             => s_Inst(5 downto 0), 
        o_RegDst            => s_RegDst,
        o_RegWrite          => s_RegWrite,
        o_MemWrite          => s_MemWrite, 
        o_MemRead           => s_MemRead, 
        o_MemToReg          => s_MemToReg, 
        o_ALUsrc            => s_ALUSrc, 
        o_lw                => s_lw, 
        o_HoB               => s_HoB, 
        o_sign              => s_sign,
        o_Branch            => s_Branch, 
        o_Return            => s_Return,
        o_Link              => s_Link,
        o_Jump              => s_Jump,
        o_ALUnAddSub        => s_ALUnAddSub, 
        o_ALUout            => s_ALUout,
        o_ShiftLorR         => s_ShiftLorR, 
        o_ShiftArithemtic   => s_ShiftArithemtic,
        o_Unsigned          => s_Unsigned,
        o_Lui               => s_Lui);

  FETCH: FetchLogic
	port MAP(
	i_jump          => s_Jump, 
        i_branch        => s_Branch, 
        i_return        => s_Return, 
        i_zero          => s_zero,
        i_init          => iInstLd, 
        i_CLK           => iCLK, 
        i_ra            => s_R1, 
        i_instruction25 => s_Inst(25 downto 0), 
        i_instruction16 => s_Inst, 
        o_PCNEW         => s_PCNEW);

  REG: RegFile 
  	port MAP(
        i_ReadAddress1     => s_RS,
        i_ReadAddress2     => s_RT,
        i_WriteAddress     => s_WA, 
        i_WriteData        => s_WD,
        i_Clock            => iCLK, 
        i_Reset            => iRST, 
        i_WriteEnable      => s_RegWrite,
        o_ReadData1        => s_R1,
        o_ReadData2        => s_R2);

  A: ALU
	port MAP(
        i_A                 => s_R1, 
        i_B                 => s_B, 
        i_ALUout            => s_ALUout, 
        i_nAdd_Sub          => s_ALUnAddSub,
        i_ShiftArithemtic   => s_ShiftArithemtic, 
        i_ShiftLorR         => s_ShiftLorR, 
        i_Unsigned          => s_Unsigned, 
        i_Lui               => s_Lui, 
        o_Final             => s_final, 
        o_Carry_Out         => s_carryOut,
        o_Zero              => s_zero,
        o_Negative          => s_negative, 
        o_Overflow          => s_overflow); 

  --16 bit extender for the immediate value
  EXTEND: extender16_32
	port MAP(
	i_data       => s_Inst(15 downto 0), 
        i_sign       => '1',
        o_OUT        => s_immediate);

  --MUX for the input from i_B of the ALU
  MUX1_32: for i in 0 to 31 generate
        MUX1: mux2to1DF
	port MAP(i_D0      => s_R2(i),         
       	         i_D1      => s_immediate(i),    
                 i_S 	   => s_ALUSrc,     
                 o_O       => s_B(i));
  end generate MUX1_32;

  --MUX for the output of DMEM
  MUX2_32: for i in 0 to 31 generate
        MUX2: mux2to1DF
	port MAP(i_D0      => s_final(i),         
       	         i_D1      => s_DMemOut(i),    
                 i_S 	   => s_MemtoReg,     
                 o_O       => s_MUX2OUT(i));
  end generate MUX2_32;

  --Unsigned extender for the byte
  UB: for i in 0 to 7 generate
	s_unsignedByte(i) 	<= s_MUX2OUT(i);	
  end generate UB;

  --Unsigned extender for the halfword
  UH: for i in 0 to 15 generate
	s_unsignedHalfword(i) 	<= s_MUX2OUT(i);	
  end generate UH;

  --Signed extender for the byte
  SB: for i in 16 to 31 generate
	s_signedByte(i) 	<= s_unsignedByte(15);	
  end generate SB;

  --Signed extender for the halfword
  SH: for i in 16 to 31 generate
	s_signedHalfword(i) 	<= s_unsignedHalfword(15);	
  end generate SH;

  --MUX for the lh, lhu, lb, lbu
  MUX3_32: for i in 0 to 31 generate
  	MUX3: mux4to1DF 
	port MAP(
	      i_D3      => s_signedHalfword(i),    
              i_D2      => s_signedByte(i),	
              i_D1      => s_unsignedHalfword(i),    
              i_D0      => s_unsignedByte(i),         
              i_S0      => s_HoB,
              i_S1      => s_sign, 
	      o_O       => s_MUX3OUT(i)); 
  end generate MUX3_32;

  --MUX for lw vs lhu, lh, lb, lbu (lw when s_lw = 0)
  MUX4_32: for i in 0 to 31 generate
        MUX4: mux2to1DF
	port MAP(i_D0      => s_MUX2OUT(i),         
       	         i_D1      => s_MUX3OUT(i),    
                 i_S 	   => s_lw,     
                 o_O       => s_MUX4OUT(i));
  end generate MUX4_32;

  --MUX for write data
  MUX5_32: for i in 0 to 31 generate
        MUX5: mux2to1DF
	port MAP(i_D0      => s_MUX4OUT(i),         
       	         i_D1      => s_PCNEW(i),    
                 i_S 	   => s_Link,     
                 o_O       => s_WD(i));
  end generate MUX5_32;

  --MUX for choosing between an I-Type or R-Type for the write address
  MUX6_32: for i in 0 to 4 generate
        MUX6: mux2to1DF
	port MAP(i_D0      => s_Inst(i+16),         
       	         i_D1      => s_Inst(i+11),    
                 i_S 	   => s_RegDst,     
                 o_O       => s_MUX6OUT(i));
  end generate MUX6_32;

  --MUX for choosing between a given address or the return register address ($ra) for the WRITE ADDRESS
  MUX7_32: for i in 0 to 4 generate
        MUX7: mux2to1DF
	port MAP(i_D0      => s_MUX6OUT(i),         
       	         i_D1      => '1',    
                 i_S 	   => s_Link,     
                 o_O       => s_WA(i));
  end generate MUX7_32;

  --MUX for choosing between a given address or the return register address ($ra) for the SOURCE REGISTER
  MUX8_32: for i in 0 to 4 generate
        MUX8: mux2to1DF
	port MAP(i_D0      => s_Inst(i+21),         
       	         i_D1      => '1',    
                 i_S 	   => s_Return,     
                 o_O       => s_RS(i));
  end generate MUX8_32;

  --MUX for choosing between a given address or the return register address ($ra) for the SOURCE REGISTER
  MUX9_32: for i in 0 to 31 generate
        MUX9: mux2to1DF
	port MAP(i_D0      => s_PCNEW(i),         
       	         i_D1      => iInstAddr(i),    
                 i_S 	   => iInstLd,     
                 o_O       => s_IMemAddr(i));
  end generate MUX9_32;

  OUTPUT: for i in 0 to 31 generate
	oALUOut(i) 	<= s_final(i);
  end generate OUTPUT;
end structure;

