-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- ControlLogic.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlLogic is
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
	o_SHAMT             : out  std_logic;
        o_Unsigned          : out  std_logic;
        o_Lui               : out  std_logic);
end entity ControlLogic;

architecture structural of ControlLogic is

    -- Component 


begin
    -- Component Instantiation


    -- Logic for determining control signals based on opcode and funct
    process(i_Opcode, i_Funct)
    begin
        if i_Opcode = "000000" then
            -- R-Type instruction
            if i_Funct = "100000" then
                -- add instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "010"; -- for add operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '1';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "100001" then
                -- addu instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "010"; -- for add operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "100100" then
                -- and instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "000"; -- for and operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "100111" then
                -- nor instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "101"; -- for nor operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "100110" then
                -- xor instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
 		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "100"; -- for '0'or operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "100101" then
                -- or instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "001"; -- for or operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "101010" then
                -- slt instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '1';
                o_ALUout <= "111"; -- for slt operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "000000" then
                -- sll instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '1';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "110"; -- for sll operation
                o_ShiftLorR <= '1'; -- shift left
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '1';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "000010" then
                -- srl instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '1';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "110"; -- for srl operation
                o_ShiftLorR <= '0'; -- shift right
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '1';
                o_Lui <= '0';
	    	o_Halt <= '0';
            
            elsif i_Funct = "000011" then
                -- sra instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '1';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "110"; -- for sra operation
                o_ShiftLorR <= '0'; -- shift right
                o_ShiftArithemtic <= '1';
                o_Unsigned <= '0';
                o_SHAMT <= '1';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "100010" then
                -- sub instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '1';
                o_ALUout <= "011"; -- for sub operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '1';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "100011" then
                -- subu instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '1';
                o_ALUout <= "011"; -- for subu operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "001000" then
                -- jr instruction, set control signals accordingly
                o_RegDst <= '0';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '1';
                o_Link <= '0';
                o_Jump <= '1'; -- jump
                o_ALUnAddSub <= '0';
                o_ALUout <= "000"; -- for jr operation
                o_ShiftLorR <= '0';
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '0';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "000100" then
                -- sllv instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "110"; -- for sllv operation
                o_ShiftLorR <= '1'; -- shift left
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '1';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "000110" then
                -- srlv instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "110"; -- for srlv operation
                o_ShiftLorR <= '0'; -- shift right
                o_ShiftArithemtic <= '0';
                o_Unsigned <= '0';
                o_SHAMT <= '1';
                o_Lui <= '0';
	    	o_Halt <= '0';

            elsif i_Funct = "000111" then
                -- srav instruction, set control signals accordingly
                o_RegDst <= '1';
                o_RegWrite <= '1';
                o_MemWrite <= '0';
                o_MemRead <= '0';
                o_MemToReg <= '0';
                o_ALUsrc <= '0';
		o_lw <= '0';
		o_HoB <= '0';
		o_sign <= '0';
                o_Branch <= '0';
                o_Branchne <= '0';
                o_Return <= '0';
                o_Link <= '0';
                o_Jump <= '0';
                o_ALUnAddSub <= '0';
                o_ALUout <= "110"; -- for srav operation
                o_ShiftLorR <= '0'; -- shift right
                o_ShiftArithemtic <= '1'; -- arithmetic shift
                o_Unsigned <= '0';
                o_SHAMT <= '1';
                o_Lui <= '0';
	    	o_Halt <= '0';

            else 
                -- add other instructions if wanted 
            end if;
        elsif i_Opcode = "001000" then
            -- addi instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '1';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '1';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "010100" then
            -- halt instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '0';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '0';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "000"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '1';	

        elsif i_Opcode = "001001" then
            -- addiu instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '1';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';
         
        elsif i_Opcode = "001100" then
            -- andi instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "000"; -- for and operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "001111" then
            -- lui instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation (LUI is essentially an ADDI with immediate in the upper 16 bits)
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '1';
	    o_Halt <= '0';

        elsif i_Opcode = "100011" then
            -- lw instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '1'; -- read from memory
            o_MemToReg <= '1'; -- write to register
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "001110" then
            -- xori instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "100"; -- for xor operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "001101" then
            -- ori instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
        o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "001"; -- for or operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "001010" then
            -- slti instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
        o_sign <= '1';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '1';
            o_ALUout <= "111"; -- for slt operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "101011" then
            -- sw instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '0';
            o_MemWrite <= '1'; -- write to memory
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '1';
	    o_lw <= '0';
	    o_HoB <= '0';
        o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '1';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "000100" then
            -- beq instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '0';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '0';
	    o_lw <= '0';
	    o_HoB <= '0';
      	    o_sign <= '0';
            o_Branch <= '1'; -- branch
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '1';
            o_ALUout <= "011"; -- for subtract operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "000101" then
            -- bne instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '0';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '0';
	    o_lw <= '0';
	    o_HoB <= '0';
        o_sign <= '0';
            o_Branch <= '0'; -- branch
            o_Branchne <= '1';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '1';
            o_ALUout <= "011"; -- for subtract operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "000010" then
            -- j instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '0';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '0';
	    o_lw <= '0';
	    o_HoB <= '0';
        o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '1'; -- jump
            o_ALUnAddSub <= '0';
            o_ALUout <= "000"; -- for j operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "000011" then
            -- jal instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '0';
            o_MemToReg <= '0';
            o_ALUsrc <= '0';
	    o_lw <= '0';
	    o_HoB <= '0';
        o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '1'; -- link (store the return address in the link register)
            o_Jump <= '1'; -- jump
            o_ALUnAddSub <= '0';
            o_ALUout <= "000"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "100000" then
            -- lb instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '1'; -- read from memory
            o_MemToReg <= '1'; -- write to register
            o_ALUsrc <= '1';
	    o_lw <= '1';
	    o_HoB <= '0';
        o_sign <= '1';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "100001" then
            -- lh instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '1'; -- read from memory
            o_MemToReg <= '1'; -- write to register
            o_ALUsrc <= '1';
	    o_lw <= '1';
	    o_HoB <= '1';
        o_sign <= '1';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "100100" then
            -- lbu instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '1'; -- read from memory
            o_MemToReg <= '1'; -- write to register
            o_ALUsrc <= '1';
	    o_lw <= '1';
	    o_HoB <= '0';
        o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        elsif i_Opcode = "100101" then
            -- lhu instruction, set control signals accordingly
            o_RegDst <= '0';
            o_RegWrite <= '1';
            o_MemWrite <= '0';
            o_MemRead <= '1'; -- read from memory
            o_MemToReg <= '1'; -- write to register
            o_ALUsrc <= '1';
	    o_lw <= '1';
	    o_HoB <= '1';
            o_sign <= '0';
            o_Branch <= '0';
            o_Branchne <= '0';
            o_Return <= '0';
            o_Link <= '0';
            o_Jump <= '0';
            o_ALUnAddSub <= '0';
            o_ALUout <= "010"; -- for add operation
            o_ShiftLorR <= '0';
            o_ShiftArithemtic <= '0';
            o_Unsigned <= '0';
            o_SHAMT <= '0';
            o_Lui <= '0';
	    o_Halt <= '0';

        else
            -- add other instructions if wanted 
        end if;
    end process;

    -- Output data from register file



end structural;
