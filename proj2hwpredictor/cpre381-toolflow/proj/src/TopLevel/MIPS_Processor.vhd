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
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0);
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
  signal s_DMemData     : std_logic_vector(N-1 downto 0);
 
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
  signal s_MemRead         : std_logic := '0';  
  signal s_ALUSrc          : std_logic := '0';    
  signal s_SHAMT           : std_logic := '0'; 
  signal s_RegDst          : std_logic := '0'; 

  --PC
  signal s_PC4             : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_PC              : std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; 

  --Register signals
  signal s_RS     : std_logic_vector(4 downto 0) := "00000";
  signal s_RT     : std_logic_vector(4 downto 0) := "00000";
  signal s_R1     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --ALU signals
  signal s_zero            : std_logic := '0';
  signal s_carryOut        : std_logic := '0'; 
  signal s_negative        : std_logic := '0'; 

  --16 bit Extender Output
  signal s_immediate    	   : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --MUX OUTPUTS
  signal s_MUX2OUT         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUX3OUT         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUX4OUT         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUX6OUT         : std_logic_vector(4 downto 0)  := "00000";
  signal s_MUX11OUT        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUX12OUT        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_MUXnumOUT       : std_logic_vector(31 downto 0);

  --Sign Extender Outputs for LH, LB
  signal s_unsignedByte         : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_unsignedHalfword     : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_signedByte         	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_signedHalfword     	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --Signals for Byte Offset
  signal s_byte0	        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_byte1	        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";  
  signal s_byte2	        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_byte3	        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --Signals for Half Offset
  signal s_half0	        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_half1	        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --16 bits instructions
  signal s_instruction16        : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --32 bit verison of the SHAMT
  signal s_SHAMT32    	   : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  --32 bit 0 (works as a ground input)
  signal s_null		: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

  signal s_MUX13OUT : std_logic_vector(31 downto 0);
  signal s_JorBorJr : std_logic;
  signal s_NEWPC : std_logic_vector(31 downto 0);
  signal s_r_WB_RegWrite : std_logic;
  signal s_r_WB_WA : std_logic_vector(4 downto 0);
  signal s_r_WB_WD : std_logic_vector(31 downto 0);
  signal s_PCJUMPJRJAL : std_logic_vector(31 downto 0);



  --SIGNALS FOR PIPELINES
  --IF stage
  signal s_IF_PC4         : std_logic_vector(31 downto 0);
  signal s_IF_PCNEW          : std_logic;
  signal s_IF_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_IF_PCINSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_IF_Flush     : std_logic; 
  signal s_IF_PCWRITE     : std_logic;
  signal s_IF_JorBorJrWRITE     : std_logic;
  signal s_IF_WRITE     : std_logic;
  signal s_IF_NotStall    : std_logic;
  signal s_IF_BranchAddr4         : std_logic_vector(31 downto 0);

  --ID stage
  signal s_ID_Jump      : std_logic;
  signal s_ID_branch    : std_logic;
  signal s_ID_return    : std_logic;
  signal s_ID_ALUnAddSub  : std_logic;
  signal s_ID_ALUout      : std_logic_vector(2 downto 0);
  signal s_ID_ShiftLorR : std_logic;
  signal s_ID_ShiftArithemtic  : std_logic;
  signal s_ID_unsigned    : std_logic;
  signal s_ID_Lui       : std_logic;
  signal s_ID_BranchNE   : std_logic;
  signal s_ID_A         : std_logic_vector(31 downto 0);
  signal s_ID_B         : std_logic_vector(31 downto 0);
  signal s_ID_r2        : std_logic_vector(31 downto 0);
  signal s_ID_Lw        : std_logic;
  signal s_ID_HoB       : std_logic;
  signal s_ID_sign      : std_logic;
  signal s_ID_MemWrite  : std_logic;
  signal s_ID_MemtoReg  : std_logic;
  signal s_ID_RegWrite  : std_logic;
  signal s_ID_PC4         : std_logic_vector(31 downto 0);
  signal s_ID_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_ID_Link  : std_logic;
  signal s_ID_WA : std_logic_vector(4 downto 0);
  signal s_ID_Halt         : std_logic;
  signal s_ID_INSTRUCTION16  : std_logic_vector(31 downto 0); 
  signal s_ID_BranchAddr     : std_logic_vector(31 downto 0);
  signal s_ID_BranchVal     : std_logic_vector(31 downto 0);
  signal s_ID_BranchEither  : std_logic;
  signal s_ID_BranchNeither  : std_logic;
  signal s_ID_Flush     : std_logic;

  --EX stage
  signal s_EX_Jump      : std_logic;
  signal s_EX_branch    : std_logic;
  signal s_EX_return    : std_logic;
  signal s_EX_ALUnAddSub  : std_logic;
  signal s_EX_ALUout      : std_logic_vector(2 downto 0);
  signal s_EX_ShiftLorR : std_logic;
  signal s_EX_ShiftArithemtic  : std_logic;
  signal s_EX_unsigned    : std_logic;
  signal s_EX_Lui       : std_logic;
  signal s_EX_BranchNE   : std_logic;
  signal s_EX_A         : std_logic_vector(31 downto 0);
  signal s_EX_B         : std_logic_vector(31 downto 0);
  signal s_EX_r2        : std_logic_vector(31 downto 0);
  signal s_EX_Lw        : std_logic;
  signal s_EX_HoB       : std_logic;
  signal s_EX_sign      : std_logic;
  signal s_EX_MemWrite  : std_logic;
  signal s_EX_MemtoReg  : std_logic;
  signal s_EX_RegWrite  : std_logic;
  signal s_EX_Final         : std_logic_vector(31 downto 0);
  signal s_EX_PC4         : std_logic_vector(31 downto 0);
  signal s_EX_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_EX_Link  : std_logic;
  signal s_EX_WA : std_logic_vector(4 downto 0);
  signal s_EX_Halt         : std_logic;
  signal s_EX_BranchAddr     : std_logic_vector(31 downto 0);
  signal s_EX_RSA     : std_logic_vector(31 downto 0);
  signal s_EX_RTB     : std_logic_vector(31 downto 0);
  signal s_EX_Flush     : std_logic;
  signal s_EX_R2A     : std_logic_vector(31 downto 0);
  signal s_EX_Ovfl    : std_logic;
  signal s_EX_RSA32   : std_logic_vector(31 downto 0);
  signal s_EX_RTB32   : std_logic_vector(31 downto 0);
  signal s_EX_R2A32   : std_logic_vector(31 downto 0);

  --MEM stage
  signal s_MEM_B         : std_logic_vector(31 downto 0);
  signal s_MEM_r2        : std_logic_vector(31 downto 0);
  signal s_MEM_Lw        : std_logic;
  signal s_MEM_HoB       : std_logic;
  signal s_MEM_sign      : std_logic;
  signal s_MEM_MemWrite  : std_logic;
  signal s_MEM_MemtoReg  : std_logic;
  signal s_MEM_RegWrite  : std_logic;
  signal s_MEM_Final         : std_logic_vector(31 downto 0);
  signal s_MEM_WA        : std_logic_vector(4 downto 0);
  signal s_MEM_WD         : std_logic_vector(31 downto 0);
  signal s_MEM_PC4         : std_logic_vector(31 downto 0);
  signal s_MEM_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_MEM_Link  : std_logic;
  signal s_MEM_Halt         : std_logic;
  signal s_MEM_Ovfl    : std_logic;

  --WB stage
  signal s_WB_RegWrite         : std_logic;
  signal s_WB_WA        : std_logic_vector(4 downto 0);
  signal s_WB_WD         : std_logic_vector(31 downto 0);
  signal s_WB_PC4         : std_logic_vector(31 downto 0);
  signal s_WB_INSTRUCTION         : std_logic_vector(31 downto 0);
  signal s_WB_Link  : std_logic;
  signal s_WB_Halt         : std_logic;
  signal s_WB_Ovfl    : std_logic;

  --Forwarding Signals
  signal s_WB_EX3_RS         : std_logic;
  signal s_WB_EX3_RT         : std_logic;
  signal s_WB_EX3_R2         : std_logic;
  signal s_WB_EX2_RS         : std_logic;
  signal s_WB_EX2_RT         : std_logic;
  signal s_WB_EX2_R2         : std_logic;
  signal s_MEM_EX1_RS         : std_logic;
  signal s_MEM_EX1_RT         : std_logic;
  signal s_MEM_EX1_R2         : std_logic;
  signal s_MEM_EX1_RSLW       : std_logic;
  signal s_MEM_EX1_RTLW       : std_logic;
  signal s_MEM_EX1_R2LW       : std_logic;
  signal s_EX_WBWD            : std_logic_vector(31 downto 0);
  signal s_EX_WBWDRS            : std_logic_vector(31 downto 0);
  signal s_EX_WBWDRT            : std_logic_vector(31 downto 0);
  signal s_EX_WBWDR2            : std_logic_vector(31 downto 0);
  signal s_WB_EX2or3_RS         : std_logic;
  signal s_WB_EX2or3_RT         : std_logic;
  signal s_WB_EX2or3_R2         : std_logic;


  --Stalling Signals 
  signal s_branch              : std_logic;  
  signal s_PC4_PC              : std_logic; 
  signal s_branchChoice        : std_logic;
  signal s_notBranchChoice        : std_logic;
  signal s_PCBRANCH4           : std_logic_vector(31 downto 0); 
  signal s_flush_IF_ID         : std_logic := '0';
  signal s_flush_ID_EX         : std_logic := '0';
  signal s_flush_EX_MEM        : std_logic := '0';
  signal s_stall_IF_ID         : std_logic := '0';
  signal s_stall_ID_EX         : std_logic := '0';
  signal s_stall_EX_MEM        : std_logic := '0';

  --Branch Prediction Signals
  signal s_branch_pred         : std_logic := '0';
  signal s_notBranch           : std_logic := '0';
  signal s_notBranch_pred      : std_logic := '0';
  signal s_ID_BranchEitherPred : std_logic := '0';
  signal s_branchChoicePred    : std_logic := '0';
  signal s_notBranchChoicePred : std_logic := '0';
  signal s_NEWPCJUMPJRJAL      : std_logic_vector(31 downto 0);

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
   port(
        i_jump          : in std_logic;
        i_branch        : in std_logic;
        i_branchne      : in std_logic;
        i_branchAddr    : in std_logic_vector(N-1 downto 0);
        i_return        : in std_logic;
        i_zero          : in std_logic;
        i_ra            : in std_logic_vector(N-1 downto 0);
        i_instruction25 : in std_logic_vector(25 downto 0);
        i_PC4           : in std_logic_vector(N-1 downto 0);
        o_JorBorJr      : out std_logic;
        o_branchChoice  : out std_logic;
        o_NEWPC         : out std_logic_vector(N-1 downto 0));
    end component;

    component IF_ID is 
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   	port(i_CLKs        : in std_logic;
	     i_Flush       : in std_logic; --this is the flush value
             i_Stall       : in std_logic; --this is the stall value
        
             i_PC4         : in std_logic_vector(N-1 downto 0);
             i_Inst        : in std_logic_vector(N-1 downto 0);
             o_PC4         : out std_logic_vector(N-1 downto 0);
             o_Inst        : out std_logic_vector(N-1 downto 0));
    end component;

    component ID_EX is
      generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  	port(
        i_CLKs        : in std_logic;
        i_Flush       : in std_logic; --this is the flush value
        i_Stall       : in std_logic; --this is the stall value


        i_Jump               : in std_logic;
        i_Branch             : in std_logic;
        i_BranchNE           : in std_logic;
        i_BranchAddr         : in std_logic_vector(N-1 downto 0);
        i_Return             : in std_logic;
        i_ALUnAddSub         : in std_logic;
        i_ALUout             : in std_logic_vector(2 downto 0);
        i_ShiftLorR          : in std_logic;
        i_ShiftArithmetic    : in std_logic;
        i_Unsigned           : in std_logic;
        i_Lui                : in std_logic;
        i_Lw                 : in std_logic;
        i_HoB                : in std_logic;
        i_Sign               : in std_logic;
        i_MemWrite           : in std_logic;
        i_MemtoReg           : in std_logic;
        i_RegWrite           : in std_logic;
        i_A        	     : in std_logic_vector(N-1 downto 0);
        i_B        	     : in std_logic_vector(N-1 downto 0);
        i_r2             : in std_logic_vector(N-1 downto 0);
        i_PC4        	     : in std_logic_vector(N-1 downto 0);
        i_Inst       	     : in std_logic_vector(N-1 downto 0);
        i_WA       	     : in std_logic_vector(4 downto 0);
        i_Link              : in std_logic;
        i_Halt               : in std_logic;
        o_Jump               : out std_logic;
        o_Branch             : out std_logic;
        o_BranchNE           : out std_logic;
        o_BranchAddr         : out std_logic_vector(N-1 downto 0);
        o_Return             : out std_logic;
        o_ALUnAddSub         : out std_logic;
        o_ALUout             : out std_logic_vector(2 downto 0);
        o_ShiftLorR          : out std_logic;
        o_ShiftArithmetic    : out std_logic;
        o_Unsigned           : out std_logic;
        o_Lui                : out std_logic;
        o_Lw                 : out std_logic;
        o_HoB                : out std_logic;
        o_Sign               : out std_logic;
        o_MemWrite           : out std_logic;
        o_MemtoReg           : out std_logic;
        o_RegWrite           : out std_logic;
        o_A        	     : out std_logic_vector(N-1 downto 0);
        o_B        	     : out std_logic_vector(N-1 downto 0);
        o_r2                 : out std_logic_vector(N-1 downto 0);
        o_PC4        	     : out std_logic_vector(N-1 downto 0);
        o_Inst        	     : out std_logic_vector(N-1 downto 0);
        o_WA       	     : out std_logic_vector(4 downto 0);
        o_Link              : out std_logic;
        o_Halt               : out std_logic
  );
   end component;

   component EX_MEM is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_CLKs               : in std_logic;
        i_Flush       : in std_logic; --this is the flush value
        i_Stall       : in std_logic; --this is the stall value
        i_Lw                 : in std_logic;
        i_HoB                : in std_logic;
        i_Sign               : in std_logic;
        i_MemWrite           : in std_logic;
        i_MemtoReg           : in std_logic;
        i_RegWrite           : in std_logic;
        i_B        	     : in std_logic_vector(N-1 downto 0);
        i_r2            : in std_logic_vector(N-1 downto 0);
        i_Final        	     : in std_logic_vector(N-1 downto 0);
        i_PC4        	     : in std_logic_vector(N-1 downto 0);
        i_Inst       	     : in std_logic_vector(N-1 downto 0);
        i_WA       	     : in std_logic_vector(4 downto 0);
        i_Link              : in std_logic;
        i_Halt        : in std_logic;
        i_Ovfl               : in std_logic;
        o_Lw                 : out std_logic;
        o_HoB                : out std_logic;
        o_Sign               : out std_logic;
        o_MemWrite           : out std_logic;
        o_MemtoReg           : out std_logic;
        o_RegWrite           : out std_logic;
        o_B        	     : out std_logic_vector(N-1 downto 0);
        o_r2            : out std_logic_vector(N-1 downto 0);
        o_Final        	     : out std_logic_vector(N-1 downto 0);
        o_PC4        	     : out std_logic_vector(N-1 downto 0);
        o_Inst       	     : out std_logic_vector(N-1 downto 0);
        o_WA       	     : out std_logic_vector(4 downto 0);
        o_Link              : out std_logic;
        o_Halt        : out std_logic;
        o_Ovfl               : out std_logic);
      end component;

      component MEM_WB is
        generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_CLKs               : in std_logic;
             i_Flush      	  : in std_logic; --this is the flush value
             i_Stall       	  : in std_logic; --this is the stall value
             i_RegWrite           : in std_logic;
             i_WD        	     : in std_logic_vector(N-1 downto 0);
             i_PC4        	     : in std_logic_vector(N-1 downto 0);
             i_Inst       	     : in std_logic_vector(N-1 downto 0);
             i_WA       	     : in std_logic_vector(4 downto 0);
             i_Link              : in std_logic;
             i_Halt        : in std_logic;
             i_Ovfl               : in std_logic;
             o_RegWrite           : out std_logic;
             o_WD        	     : out std_logic_vector(N-1 downto 0);
             o_PC4        	     : out std_logic_vector(N-1 downto 0);
	     o_Inst        	     : out std_logic_vector(N-1 downto 0);
             o_WA       	     : out std_logic_vector(4 downto 0);
             o_Link              : out std_logic;
             o_Halt        : out std_logic;
             o_Ovfl               : out std_logic);
     end component;

   component Reg32File is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_CLKs        : in std_logic;
        i_WE          : in std_logic;
        i_R           : in std_logic;
        i_WD          : in std_logic_vector(N-1 downto 0);
        i_WA          : in std_logic_vector(4 downto 0); 
        i_RS          : in std_logic_vector(4 downto 0);
        i_RT          : in std_logic_vector(4 downto 0);
        o_OUT1        : out std_logic_vector(N-1 downto 0);
        o_OUT0        : out std_logic_vector(N-1 downto 0));
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
        o_Branchne          : out  std_logic; 
        o_Return            : out  std_logic; 
        o_Link              : out  std_logic; 
        o_Jump              : out  std_logic; 

	      -- Halt	
        o_Halt              : out  std_logic; 

        -- ALU Operations
        o_ALUnAddSub        : out  std_logic; 
        o_ALUout            : out  std_logic_vector(2 downto 0); --3 bits to determine the type of operation
        o_ShiftLorR         : out  std_logic;
        o_ShiftArithemtic   : out  std_logic;
        o_Unsigned          : out  std_logic;
	      o_SHAMT             : out  std_logic;
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

    -- 2t1Mux
    component mux2t1_N is
    port(
        i_S             : in std_logic;
        i_D0            : in std_logic_vector(N-1 downto 0);
        i_D1            : in std_logic_vector(N-1 downto 0);
        o_O             : out std_logic_vector(N-1 downto 0)
    );
    end component;

    component AddSub is
      generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
      port(i_Cin        : in std_logic;
           i_AddSub     : in std_logic;
           i_ALUSrc     : in std_logic;  
           i_D1         : in std_logic_vector(N-1 downto 0);
           i_D0         : in std_logic_vector(N-1 downto 0);
           i_regWrite   : in std_logic_vector(N-1 downto 0);
           o_C          : out std_logic_vector(N-1 downto 0);
           o_S          : out std_logic_vector(N-1 downto 0));
    end component;

    component PC is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        i_WD         : in std_logic_vector(N-1 downto 0);
        i_WEN        : in std_logic; 
        i_CLKs       : in std_logic;
        i_R          : in std_logic;
        o_OUT        : out std_logic_vector(N-1 downto 0));
    end component;

    component ForwardingUnit is
   	port(   i_CLKs           : in std_logic;
		i_R              : in std_logic;
		i_WB_WA          : in std_logic_vector(4 downto 0);
       		i_MEM_WA         : in std_logic_vector(4 downto 0);  
       		i_EX_RS          : in std_logic_vector(4 downto 0);
        	i_EX_RT          : in std_logic_vector(4 downto 0);
		i_EX_ALUOUT      : in std_logic_vector(2 downto 0);
		i_EX_OPCODE      : in std_logic_vector(5 downto 0);
		i_MEM_OPCODE     : in std_logic_vector(5 downto 0);
      		i_MEM_RegWrite   : in std_logic; 	
		i_WB_RegWrite    : in std_logic;
        	o_WB_EX2_RS      : out std_logic;
		o_WB_EX2_RT      : out std_logic;
		o_WB_EX2_R2      : out std_logic;
        	o_MEM_EX1_RS     : out std_logic;
        	o_MEM_EX1_RT     : out std_logic;
 	        o_MEM_EX1_R2     : out std_logic;
        	o_MEM_EX1_RSLW   : out std_logic;
        	o_MEM_EX1_RTLW   : out std_logic;
 	        o_MEM_EX1_R2LW   : out std_logic);
    end component;

    component StallingUnit is
    	port(
        	--input signals for control hazards
        	i_EX_Jump           : in std_logic;
        	i_EX_Branch         : in std_logic;
        	i_branch_taken      : in std_logic;
        	i_branch_pred       : in std_logic; 
        	i_notBranch_pred    : in std_logic;
    
        	--input signals for data hazard
        	i_MEM_MemToReg      : in std_logic;
        	i_MEM_WA            : in std_logic_vector(4 downto 0);
        	i_EX_RS             : in std_logic_vector(4 downto 0);
        	i_EX_RT             : in std_logic_vector(4 downto 0);

        	--output signals for control hazards
        	o_flush_IF_ID       : out std_logic;
        	o_flush_ID_EX       : out std_logic
    	);
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

    component andg2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_C          : out std_logic);
    end component;

    component andg3 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             i_C          : in std_logic;
             o_C          : out std_logic);
    end component;

   component BranchPredictor is
   port(i_CLKs        	: in std_logic;
	i_R       	: in std_logic;
	i_branch_taken	: in std_logic;
	i_ex_branch    	: in std_logic;
	o_branch_pred   : out std_logic;
	o_notBranch_pred: out std_logic);

   end component;

begin

	

  -- /*--------------------------------------------------------------------------------------------------*/
  -- /*-------------------------------------------  HAZARDS  --------------------------------------------*/
  -- /*--------------------------------------------------------------------------------------------------*/

   FORWARD: ForwardingUnit
   port MAP(
                i_CLKs           => iCLK,
		i_R              => iRST,
		i_WB_WA          => s_WB_WA,
       		i_MEM_WA         => s_MEM_WA, 
       		i_EX_RS          => s_EX_INSTRUCTION(25 downto 21),
        	i_EX_RT          => s_EX_INSTRUCTION(20 downto 16),
		i_EX_OPCODE      => s_EX_INSTRUCTION(31 downto 26),
		i_EX_ALUOUT      => s_EX_ALUout(2 downto 0),
		i_MEM_OPCODE     => s_MEM_INSTRUCTION(31 downto 26),
		i_MEM_RegWrite   => s_MEM_RegWrite,
		i_WB_RegWrite    => s_WB_RegWrite,
        	o_WB_EX2_RS      => s_WB_EX2_RS,
		o_WB_EX2_RT      => s_WB_EX2_RT,
		o_WB_EX2_R2      => s_WB_EX2_R2,
        	o_MEM_EX1_RS     => s_MEM_EX1_RS,
        	o_MEM_EX1_RT     => s_MEM_EX1_RT,
        	o_MEM_EX1_R2     => s_MEM_EX1_R2,
        	o_MEM_EX1_RSLW   => s_MEM_EX1_RSLW,
        	o_MEM_EX1_RTLW   => s_MEM_EX1_RTLW,
        	o_MEM_EX1_R2LW   => s_MEM_EX1_R2LW);

  orBranchEX: org2
  port MAP(
            i_A       => s_EX_branch,
            i_B       => s_EX_BranchNE,
            o_C       => s_branch
          );

  orBranchID: org2
  port MAP(
            i_A       => s_ID_branch,
            i_B       => s_ID_BranchNE,
            o_C       => s_ID_BranchEither
          );

  notBranchEither: invg
	port MAP(
            i_A                  => s_ID_BranchEither,
            o_F                  => s_ID_BranchNeither
          );


  FLUSH_IF: org2
  port MAP(
            i_A       => s_flush_IF_ID,
            i_B       => iRST,
            o_C       => s_IF_Flush
          );

  FLUSH_ID: org2
  port MAP(
            i_A       => s_flush_ID_EX,
            i_B       => iRST,
            o_C       => s_ID_Flush
          );



  STALL: StallingUnit
  port MAP(
	--input signals for control hazards
	i_EX_Jump           => s_EX_Jump,
	i_EX_Branch         => s_branch ,
	i_branch_taken      => s_branchChoice,
        i_branch_pred       => s_branch_pred, 
        i_notBranch_pred    => s_notBranch_pred, 

	--input signals for data hazard
	i_MEM_MemToReg      => s_MEM_MemToReg,
	i_MEM_WA            => s_MEM_WA,
	i_EX_RS             => s_EX_INSTRUCTION(25 downto 21),
	i_EX_RT             => s_EX_INSTRUCTION(20 downto 16),

	--output signals for control hazards
	o_flush_IF_ID       => s_flush_IF_ID,
	o_flush_ID_EX       => s_flush_ID_EX
    );

  BRANCHPREDICT: BranchPredictor
  port MAP(i_CLKs        	=> iCLK,
	i_R       	=> iRST,
	i_branch_taken	=> s_branchChoice, 
	i_ex_branch    	=> s_branch, 
	o_branch_pred   => s_branch_pred,
	o_notBranch_pred=> s_notBranch_pred);

  -- /*--------------------------------------------------------------------------------------------------*/
  -- /*-------------------------------------------  IF STAGE  -------------------------------------------*/
  -- /*--------------------------------------------------------------------------------------------------*/

  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  --MUX for choosing between a given address or the return register address ($ra) for the SOURCE REGISTER
  MUX9_32: for i in 0 to 31 generate
  MUX9: mux2to1DF
  port MAP(i_D0      => s_PC(i),         
      i_D1      => iInstAddr(i),    
      i_S 	   => iInstLd,     
      o_O       => s_IF_PCINSTRUCTION(i));
  end generate MUX9_32;

  --MUX for choosing branch into the instruction memory
  BranchMUX_32: for i in 0 to 31 generate
  BranchMUX: mux2to1DF
  port MAP(i_D0      => s_IF_PCINSTRUCTION(i),         
      i_D1      => s_ID_BranchAddr(i),    
      i_S 	=> s_ID_BranchEitherPred,     
      o_O       => s_NextInstAddr(i));
  end generate BranchMUX_32; 

  IMem: mem
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

  add4: AddSub
  port MAP(
            i_Cin        => '0',
            i_AddSub     => '0',
            i_ALUSrc     => '0', 
            i_D1         => s_PCBRANCH4,
            i_D0         => "00000000000000000000000000000100",
            i_regWrite   => "00000000000000000000000000000000",
            o_C          => s_null,
            o_S          => s_PC4
    );


  -- 2t1Mux
  MUX16 : mux2t1_N 
  port map (
      i_S             => s_ID_BranchEitherPred,
      i_D0            => s_PC,
      i_D1            => s_ID_BranchAddr,
      o_O             => s_PCBRANCH4
  );


  -- 2t1Mux
  MUX15 : mux2t1_N 
  port map (
      i_S             => s_notBranchChoicePred,
      i_D0            => s_PCJUMPJRJAL,
      i_D1            => s_PC4,
      o_O             => s_NEWPCJUMPJRJAL
  );

  -- 2t1Mux
  MUX14 : mux2t1_N 
  port map (
      i_S             => s_branchChoicePred,
      i_D0            => s_NEWPCJUMPJRJAL,
      i_D1            => s_ID_BranchAddr,
      o_O             => s_NEWPC
  );

  -- 2t1Mux
  MUX13 : mux2t1_N 
  port map (
      i_S             => s_IF_PCNEW,
      i_D0            => s_PC4,
      i_D1            => s_NEWPC,
      o_O             => s_MUX13OUT
  );


  notBranchChoice: invg
	port MAP(
            i_A                  => s_branchChoicePred,
            o_F                  => s_notBranchChoice
          );

  and2a: andg2
	port MAP(
            i_A                  => s_notBranchChoice,
            i_B                  => s_branch,
            o_C                  => s_PC4_PC
          );

  IDPREDICT: andg2
	port MAP(
            i_A                  => s_branch_pred,
            i_B                  => s_ID_BranchEither,
            o_C                  => s_ID_BranchEitherPred
          );

  CHOICEPREDICT: andg2
	port MAP(
            i_A                  => s_branch_pred,
            i_B                  => s_branchChoice,
            o_C                  => s_branchChoicePred
          );

  NOTCHOICEPREDICT: andg3
	port MAP(
            i_A                  => s_notBranch_pred,
            i_B                  => s_notBranch,
            i_C                  => s_branch,
            o_C                  => s_notBranchChoicePred
          );

  notBranch: invg
	port MAP(
            i_A                  => s_branchChoice,
            o_F                  => s_notBranch
          );

  or2a: org2
	port MAP(
            i_A                  => s_PC4_PC,
            i_B                  => s_JorBorJr,
            o_C                  => s_IF_PCNEW
          );


  PC4 : PC  
  port MAP(
            i_WD         => s_MUX13OUT,
            i_WEN        => '1',
            i_CLKs       => iCLK,
            i_R          => iRST,
            o_OUT        => s_PC
  );

  s_IF_PC4 <= s_PC4;
  s_IF_INSTRUCTION <= s_Inst;
  
  IFID: IF_ID
  port MAP(
        i_CLKs            => iCLK,
	i_Flush       	  => s_IF_FLUSH,
        i_Stall           => '0',
        i_PC4             => s_IF_PC4,
        i_Inst            => s_IF_INSTRUCTION,
        o_PC4             => s_ID_PC4,
        o_Inst            => s_ID_INSTRUCTION
  );

  -- /*--------------------------------------------------------------------------------------------------*/
  -- /*-------------------------------------------  ID STAGE  -------------------------------------------*/
  -- /*--------------------------------------------------------------------------------------------------*/

  CL: ControlLogic
	port MAP(
        i_Opcode            => s_ID_INSTRUCTION(31 downto 26),
        i_Funct             => s_ID_INSTRUCTION(5 downto 0), 
        o_RegDst            => s_RegDst,
        o_RegWrite          => s_ID_RegWrite,
        o_MemWrite          => s_ID_MemWrite, 
        o_MemRead           => s_MemRead, --this signal is useless
        o_MemToReg          => s_ID_MemToReg, 
        o_ALUsrc            => s_ALUSrc, --used in creating s_A and s_B
        o_lw                => s_ID_lw, 
        o_HoB               => s_ID_HoB, 
        o_sign              => s_ID_sign,
        o_Halt              => s_ID_Halt,
        o_Branch            => s_ID_Branch, 
        o_Branchne          => s_ID_BranchNE,
        o_Return            => s_ID_Return,
        o_Link              => s_ID_Link,
        o_Jump              => s_ID_Jump,
        o_ALUnAddSub        => s_ID_ALUnAddSub, 
        o_ALUout            => s_ID_ALUout,
        o_ShiftLorR         => s_ID_ShiftLorR, 
        o_ShiftArithemtic   => s_ID_ShiftArithemtic,
        o_Unsigned          => s_ID_Unsigned,
	o_SHAMT             => s_SHAMT, --used in creating s_A and s_B
        o_Lui               => s_ID_Lui);


  s_SHAMT32(4 downto 0) <= s_ID_INSTRUCTION(10 downto 6); 

  s_RS <= s_ID_INSTRUCTION(25 downto 21); 

  s_RT <= s_ID_INSTRUCTION(20 downto 16); 

  REG: Reg32File 
  	port MAP(
        i_CLKs        => iCLK,
        i_WE          => s_RegWr,
        i_R           => iRST,
        i_WD          => s_RegWrData,
        i_WA          => s_RegWrAddr, 
        i_RS          => s_RS,
        i_RT          => s_RT,
        o_OUT1        => s_R1,
        o_OUT0        => s_ID_R2);

  s_RegWr <= s_r_WB_RegWrite;
  s_RegWrAddr <= s_r_WB_WA;
  s_RegWrData <= s_r_WB_WD;

  --MUX for choosing between an I-Type or R-Type for the write address
  MUX6_32: for i in 0 to 4 generate
  MUX6: mux2to1DF
  port MAP(i_D0      => s_ID_INSTRUCTION(i+16),         
        i_D1      => s_ID_INSTRUCTION(i+11),    
        i_S 	   => s_RegDst,     
        o_O       => s_MUX6OUT(i));
  end generate MUX6_32;

  --MUX for choosing between a given address or the return register address ($ra) for the WRITE ADDRESS
  MUX7_32: for i in 0 to 4 generate
      MUX7: mux2to1DF
  port MAP(i_D0      => s_MUX6OUT(i),         
          i_D1      => '1',    
          i_S 	   => s_ID_link,     
          o_O       => s_ID_WA(i));
  end generate MUX7_32;

  --MUX for choosing between the R1 and R2 as the source for the i_A into the ALU for Shift operations
  MUX10_32: for i in 0 to 31 generate
  MUX10: mux2to1DF
  port MAP(i_D0      => s_R1(i),         
        i_D1      => s_ID_R2(i),    
        i_S 	   => s_SHAMT,     
        o_O       => s_ID_A(i));
  end generate MUX10_32;

  --MUX for choosing the s_ID_B value for the mux
  MUX1_32: for i in 0 to 31 generate
  MUX1: mux4to1DF 
	port MAP(
	      i_D3      => s_SHAMT32(i),    
        i_D2      => s_R1(i),	
        i_D1      => s_immediate(i),    
        i_D0      => s_ID_R2(i),         
        i_S0      => s_ALUSrc,
        i_S1      => s_SHAMT, 
	      o_O       => s_ID_B(i)); 
  end generate MUX1_32;

  --16 bit extender for the immediate value
  EXTEND: extender16_32
  port MAP(
        i_data       => s_ID_INSTRUCTION(15 downto 0), 
        i_sign       => s_ID_sign,
        o_OUT        => s_immediate);

 
  s_ID_INSTRUCTION16(15 downto 0)  <= s_ID_INSTRUCTION(15 downto 0); 
  s_ID_INSTRUCTION16(31 downto 16) <= "0000000000000000";


  --Shifting the branch address left by two
  SHIFTLEFT2_2: for i in 0 to 29 generate
        s_ID_BranchVal(i+2)     <= s_ID_INSTRUCTION16(i);  
  end generate SHIFTLEFT2_2;

  s_ID_BranchVal(0) <= '0';
  s_ID_BranchVal(1) <= '0';

  ALU2: AddSub
	port MAP(i_Cin        => '0',
       	         i_AddSub     => '0',
                 i_ALUSrc     => '0', 
                 i_D1         => s_ID_PC4,
                 i_D0         => s_ID_BranchVal,
                 i_regWrite   => "00000000000000000000000000000000",
                 o_C          => s_null,
                 o_S          => s_ID_BranchAddr);

  IDEX: ID_EX
  port MAP(
        i_CLKs            => iCLK,
	i_Flush       	  => s_ID_FLUSH,
        i_Stall           => '0',
        i_Jump            => s_ID_Jump,
        i_Branch          => s_ID_Branch,
        i_BranchNE        => s_ID_BranchNE,
        i_BranchAddr      => s_ID_BranchAddr,
        i_Return          => s_ID_Return,
        i_ALUnAddSub      => s_ID_ALUnAddSub,
        i_ALUout          => s_ID_ALUout,             
        i_ShiftLorR       => s_ID_ShiftLorR,
        i_ShiftArithmetic => s_ID_ShiftArithemtic,
        i_Unsigned        => s_ID_Unsigned,
        i_Lui             => s_ID_Lui,
        i_Lw              => s_ID_Lw,
        i_HoB             => s_ID_HoB,
        i_Sign            => s_ID_Sign,
        i_MemWrite        => s_ID_MemWrite,
        i_MemtoReg        => s_ID_MemtoReg,
        i_RegWrite        => s_ID_RegWrite,
        i_A               => s_ID_A,
        i_B               => s_ID_B,
        i_r2              => s_ID_r2,
        i_PC4             => s_ID_PC4,
        i_Inst            => s_ID_INSTRUCTION,
        i_Link            => s_ID_Link,
        i_WA              => s_ID_WA,
        i_Halt            => s_ID_Halt,
        o_Jump            => s_EX_Jump,
        o_Branch          => s_EX_Branch,
        o_BranchNE        => s_EX_BranchNE,
        o_BranchAddr      => s_EX_BranchAddr,
        o_Return          => s_EX_Return,
        o_ALUnAddSub      => s_EX_ALUnAddSub,
        o_ALUout          => s_EX_ALUout,
        o_ShiftLorR       => s_EX_ShiftLorR,
        o_ShiftArithmetic => s_EX_ShiftArithemtic,
        o_Unsigned        => s_EX_Unsigned,
        o_Lui             => s_EX_Lui,
        o_Lw              => s_EX_Lw,
        o_HoB             => s_EX_HoB,
        o_Sign            => s_EX_Sign,
        o_MemWrite        => s_EX_MemWrite,
        o_MemtoReg        => s_EX_MemtoReg,
        o_RegWrite        => s_EX_RegWrite,
        o_A               => s_EX_A,
        o_B               => s_EX_B,
        o_r2              => s_EX_r2,
        o_PC4             => s_EX_PC4,
        o_Inst            => s_EX_INSTRUCTION,
        o_WA              => s_EX_WA,
        o_Link            => s_EX_Link,
        o_Halt            => s_EX_Halt
  );

    -- /*--------------------------------------------------------------------------------------------------*/
    -- /*-------------------------------------------  EX STAGE  -------------------------------------------*/
    -- /*--------------------------------------------------------------------------------------------------*/

  --16 bit instruction for Fetch Logic
  INSTRUCTION16: for i in 0 to 15 generate
	s_instruction16(i) 	<= s_EX_INSTRUCTION(i);	
  end generate INSTRUCTION16;


  FETCH: FetchLogic
	port MAP(
        i_jump              => s_EX_Jump,
        i_branch            => s_EX_Branch,
        i_branchne          => s_EX_BranchNE,
        i_branchAddr        => s_EX_BranchAddr,
        i_return            => s_EX_Return,
        i_zero              => s_zero,
        i_ra                => s_EX_RSA,
        i_instruction25     => s_EX_INSTRUCTION(25 downto 0),
        i_PC4               => s_EX_PC4,
        o_branchChoice      => s_branchChoice,
        o_JorBorJr          => s_JorBorJr,
        o_NEWPC             => s_PCJUMPJRJAL);

  --MUX for choosing the s_EX_RSA value for the mux
  RSA_32: for i in 0 to 31 generate
  RSA: mux4to1DF 
	port MAP(
	i_D3      => s_MEM_Final(i),    
        i_D2      => s_WB_WD(i),	
        i_D1      => s_MEM_Final(i),    
        i_D0      => s_EX_A(i),         
        i_S0      => s_MEM_EX1_RS,
        i_S1      => s_WB_EX2_RS, 
	o_O       => s_EX_RSA32(i)); 
  end generate RSA_32;

  --MUX for choosing the s_EX_RTB value for the mux
  RTB_32: for i in 0 to 31 generate
  RTB: mux4to1DF 
	port MAP(
	i_D3      => s_MEM_Final(i),    
        i_D2      => s_WB_WD(i),	
        i_D1      => s_MEM_Final(i),    
        i_D0      => s_EX_B(i),         
        i_S0      => s_MEM_EX1_RT,
        i_S1      => s_WB_EX2_RT, 
	o_O       => s_EX_RTB32(i)); 
  end generate RTB_32;

  --MUX for choosing the s_R2 value for ex
  R2A_32: for i in 0 to 31 generate
  R2A: mux4to1DF 
	port MAP(
	i_D3      => s_MEM_Final(i),    
        i_D2      => s_WB_WD(i),	
        i_D1      => s_MEM_Final(i),    
        i_D0      => s_EX_r2(i),         
        i_S0      => s_MEM_EX1_R2,
        i_S1      => s_WB_EX2_R2, 
	o_O       => s_EX_R2A32(i)); 
  end generate R2A_32;

  RSALW: for i in 0 to 31 generate
  MUXWBRS: mux2to1DF
  port MAP(i_D0      => s_EX_RSA32(i),         
        i_D1      => s_MEM_WD(i),    
        i_S 	   => s_MEM_EX1_RSLW,     
        o_O       => s_EX_RSA(i));
  end generate RSALW;

  RTBLW: for i in 0 to 31 generate
  MUXWBRT: mux2to1DF
  port MAP(i_D0      => s_EX_RTB32(i),         
        i_D1      => s_MEM_WD(i),    
        i_S 	   => s_MEM_EX1_RTLW,     
        o_O       => s_EX_RTB(i));
  end generate RTBLW;

  R2ALW: for i in 0 to 31 generate
  MUXWBRT: mux2to1DF
  port MAP(i_D0      => s_EX_R2A32(i),         
        i_D1      => s_MEM_WD(i),    
        i_S 	   => s_MEM_EX1_R2LW,     
        o_O       => s_EX_R2A(i));
  end generate R2ALW;

  A: ALU
	port MAP(
        i_A                 => s_EX_RSA, 
        i_B                 => s_EX_RTB, 
        i_ALUout            => s_EX_ALUout, 
        i_nAdd_Sub          => s_EX_ALUnAddSub,
        i_ShiftArithemtic   => s_EX_ShiftArithemtic, 
        i_ShiftLorR         => s_EX_ShiftLorR, 
        i_Unsigned          => s_EX_Unsigned, 
        i_Lui               => s_EX_Lui, 
        o_Final             => s_EX_final, 
        o_Carry_Out         => s_carryOut,
        o_Zero              => s_zero,
        o_Negative          => s_negative, 
        o_Overflow          => s_EX_Ovfl); 

  EXMEM: EX_MEM
  port MAP(
        i_CLKs            => iCLK,
	i_Flush       	  => iRST,
        i_Stall           => '0',
        i_Lw              => s_EX_lw,
        i_HoB             => s_EX_HoB,
        i_Sign            => s_EX_Sign,
        i_MemWrite        => s_EX_MemWrite,
        i_MemtoReg        => s_EX_MemtoReg,
        i_RegWrite        => s_EX_RegWrite,
        i_B               => s_EX_RTB,
        i_r2              => s_EX_R2A,
        i_Final           => s_EX_Final,
        i_PC4             => s_EX_PC4,
        i_Inst            => s_EX_INSTRUCTION,
        i_WA              => s_EX_WA,
        i_Link            => s_EX_Link,
        i_Halt            => s_EX_Halt,
        i_Ovfl            => s_EX_Ovfl,
        o_Lw              => s_MEM_lw,
        o_HoB             => s_MEM_HoB,
        o_Sign            => s_MEM_Sign,
        o_MemWrite        => s_MEM_MemWrite,
        o_MemtoReg        => s_MEM_MemtoReg,
        o_RegWrite        => s_MEM_RegWrite,
        o_B               => s_MEM_B,
        o_r2              => s_MEM_r2,
        o_Final           => s_MEM_Final,
        o_PC4             => s_MEM_PC4,
        o_Inst            => s_MEM_INSTRUCTION,
        o_WA              => s_MEM_WA,
        o_Link            => s_MEM_Link,
        o_Halt            => s_MEM_Halt,
	o_Ovfl            => s_MEM_Ovfl
  );

      -- /*---------------------------------------------------------------------------------------------------*/
      -- /*-------------------------------------------  MEM STAGE  -------------------------------------------*/
      -- /*---------------------------------------------------------------------------------------------------*/


  s_DMemAddr <= s_MEM_final;
  s_DMemData <= s_MUXnumOUT; 
  s_DMemWr   <= s_MEM_MemWrite;


  -- 2t1Mux
  MUXnum : mux2t1_N 
  port map (
      i_S             => s_MEM_MemWrite,
      i_D0            => s_MEM_B,
      i_D1            => s_MEM_r2,
      o_O             => s_MUXnumOUT
  );

  DMem: mem
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  MEMWB: MEM_WB
  port MAP(
        i_CLKs            => iCLK,
	i_Flush           => iRST, 
        i_Stall           => '0',
        i_RegWrite        => s_MEM_RegWrite, 
        i_WD              => s_MEM_WD, 
        i_PC4             => s_MEM_PC4,
        i_Inst            => s_MEM_INSTRUCTION,
        i_WA              => s_MEM_WA,
        i_Link            => s_MEM_Link,
        i_Halt            => s_MEM_Halt,
	i_Ovfl            => s_MEM_Ovfl, 
        o_RegWrite        => s_WB_RegWrite,
        o_WD              => s_WB_WD,
        o_PC4             => s_WB_PC4,
        o_Inst            => s_WB_INSTRUCTION,
        o_WA              => s_WB_WA,
        o_Link            => s_WB_Link,
        o_Halt            => s_WB_Halt,
	o_Ovfl            => s_WB_Ovfl
  );

      -- /*--------------------------------------------------------------------------------------------------*/
      -- /*-------------------------------------------  WB STAGE  -------------------------------------------*/
      -- /*--------------------------------------------------------------------------------------------------*/

  --MUX for the output of DMEM
  MUX2_32: for i in 0 to 31 generate
        MUX2: mux2to1DF
	port MAP(i_D0      => s_MEM_final(i),         
            i_D1      => s_DMemOut(i),    
            i_S 	   => s_MEM_MemtoReg,     
            o_O       => s_MUX2OUT(i));
  end generate MUX2_32;

  --Unsigned extender for the byte
  UB: for i in 0 to 7 generate
	s_unsignedByte(i) 	<= s_MUX11OUT(i);	
  end generate UB;

  --Unsigned extender for the halfword
  UH: for i in 0 to 15 generate
	s_unsignedHalfword(i) 	<= s_MUX12OUT(i);	
  end generate UH;

  --Signed extender for the byte
  SB: for i in 8 to 31 generate
	s_signedByte(i) 	<= s_unsignedByte(7);	
  end generate SB;

  SBS: for i in 0 to 7 generate
	s_signedByte(i) 	<= s_MUX11OUT(i);	
  end generate SBS;

  --Signed extender for the halfword
  SH: for i in 16 to 31 generate
	s_signedHalfword(i) 	<= s_unsignedHalfword(15);
	s_signedHalfword(i-16) 	<= s_MUX12OUT(i-16);	
  end generate SH;

  --MUX for the lh, lhu, lb, lbu
  MUX3_32: for i in 0 to 31 generate
  	MUX3: mux4to1DF 
	port MAP(
	i_D3      => s_signedHalfword(i),    
        i_D2      => s_signedByte(i),	
        i_D1      => s_unsignedHalfword(i),    
        i_D0      => s_unsignedByte(i),         
        i_S0      => s_MEM_HoB,
        i_S1      => s_MEM_Sign, 
	o_O       => s_MUX3OUT(i)); 
  end generate MUX3_32;

  --MUX for lw vs lhu, lh, lb, lbu (lw when s_MEM_lw = 0)
  MUX4_32: for i in 0 to 31 generate
        MUX4: mux2to1DF
	port MAP(i_D0      => s_MUX2OUT(i),         
            i_D1      => s_MUX3OUT(i),    
            i_S 	   => s_MEM_lw,     
            o_O       => s_MEM_WD(i));
  end generate MUX4_32;

  --MUX for write data
  MUX5_32: for i in 0 to 31 generate
        MUX5: mux2to1DF
	port MAP(i_D0      => s_WB_WD(i),         
            i_D1      => s_WB_PC4(i),    
            i_S 	   => s_WB_Link,     
            o_O       => s_r_WB_WD(i));
  end generate MUX5_32;

  s_r_WB_WA <= s_WB_WA;
  s_r_WB_RegWrite <= s_WB_RegWrite;

  --MUX for the lb offsets
  MUX11_32: for i in 0 to 31 generate
  	MUX11: mux4to1DF 
	port MAP(
	      i_D3      => s_byte3(i),    
        i_D2      => s_byte2(i),	
        i_D1      => s_byte1(i),    
        i_D0      => s_byte0(i),         
        i_S0      => s_MEM_final(0),
        i_S1      => s_MEM_final(1), 
	      o_O       => s_MUX11OUT(i)); 
  end generate MUX11_32;

  --MUX for the lh offsets 
  MUX12_32: for i in 0 to 31 generate
        MUX12: mux2to1DF
	port MAP(i_D0      => s_half0(i),         
            i_D1      => s_half1(i),    
            i_S 	   => s_MEM_final(1),     
            o_O       => s_MUX12OUT(i));
  end generate MUX12_32;

  s_byte0(7 downto 0) <= s_MUX2OUT(7 downto 0); 
  s_byte1(7 downto 0) <= s_MUX2OUT(15 downto 8); 
  s_byte2(7 downto 0) <= s_MUX2OUT(23 downto 16); 
  s_byte3(7 downto 0) <= s_MUX2OUT(31 downto 24); 

  s_half0(15 downto 0)  <= s_MUX2OUT(15 downto 0); 
  s_half1(15 downto 0)  <= s_MUX2OUT(31 downto 16); 



  -- /*-------------------------------------------  END STAGE  -------------------------------------------*/


  s_Halt <= s_WB_Halt;

  s_Ovfl <= s_WB_Ovfl; 

  OUTPUT: for i in 0 to 31 generate
	oALUOut(i) 	<= s_EX_final(i);
  end generate OUTPUT;
end structure; 
