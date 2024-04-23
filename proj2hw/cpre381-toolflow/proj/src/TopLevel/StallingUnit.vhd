library IEEE;
use IEEE.std_logic_1164.all;


-- if jump in EX then flush both the IF_ID and ID_EX pipeliunes

-- if branch in EX then flush one of the IF_ID and ID_EX pipelines

-- if s_MemtoReg is 1 (load type instruction)
    -- if WA of MEM is == to the EX opcode 
        -- Stall IF_ID ID_EX
        -- Stall and Flush EX_MEM 

library IEEE;
use IEEE.std_logic_1164.all;

entity StallingUnit is
    generic( N : integer := 32 ); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        --input signals for control hazards
        i_EX_Jump           : in std_logic;
        i_EX_Branch         : in std_logic;
        i_branch_taken      : in std_logic;
    
        --input signals for data hazard
        i_MEM_MemToReg      : in std_logic;
        i_MEM_WA            : in std_logic_vector(4 downto 0);
        i_EX_RS             : in std_logic_vector(4 downto 0);
        i_EX_RT             : in std_logic_vector(4 downto 0);

        --output signals for control hazards
        o_flush_IF_ID       : out std_logic;
        o_flush_ID_EX       : out std_logic;

        --output signals for data hazard
        o_stall_IF_ID       : out std_logic;
        o_stall_ID_EX       : out std_logic;
        o_stall_EX_MEM      : out std_logic;
        o_flush_EX_MEM      : out std_logic
    );
end StallingUnit;

architecture structural of StallingUnit is

    component andg2_5bit is 
    port(
        i_A                 : in std_logic_vector(4 downto 0);
        i_B                 : in std_logic_vector(4 downto 0);
        o_C                 : out std_logic
    );
    end component; 

    component andg2 is
        port(
            i_A             : in std_logic;
            i_B             : in std_logic;
            o_C             : out std_logic
        );
    end component;

    component org2 is
        port(
            i_A             : in std_logic;
            i_B             : in std_logic;
            o_C             : out std_logic
        );
    end component;

    component invg is
        port(
            i_A          : in std_logic;
            o_F          : out std_logic
        );
    end component;

    -- Signals for Control Hazard
    signal flushFirstInst: std_logic;
    signal flushSecondInst: std_logic;
    signal s_branch_not_taken : std_logic;

    -- Signals for Data Hazard
    signal dataHazard: std_logic;
    signal s_Andg2_a: std_logic;
    signal s_Andg2_b: std_logic;
    signal s_Org2: std_logic;

begin

    -- Determine which inst needs to be flushed
    -- Flush signal assignment based on branch taken or jump ++
    branchHazardAndg2_a : andg2 port map(
        i_A      => i_EX_Branch,
        i_B      => s_branch_not_taken,
        o_C      => flushFirstInst
    ); 

    notg2: invg port MAP(
        i_A      => i_branch_taken, 
        o_F      => s_branch_not_taken
    );

    branchHazardAndg2_b : andg2 port map(
        i_A      => i_EX_Branch,
        i_B      => i_branch_taken,
        o_C      => flushSecondInst
    ); 

    control_hazard_org2_a : org2 port map(
        i_A      => flushSecondInst,
        i_B      => i_EX_Jump,
        o_C      => o_flush_IF_ID
    ); 

    control_hazard_org2_b : org2 port map(
        i_A      => flushFirstInst,
        i_B      => i_EX_Jump,
        o_C      => o_flush_ID_EX
    ); 



    -- Data Hazard Detection
    data_hazard_andg2_a : andg2_5bit port map(
        i_A      => i_MEM_WA,
        i_B      => i_EX_RT,
        o_C      => s_Andg2_a
    ); 

    data_hazard_andg2_b : andg2_5bit port map(
        i_A      => i_MEM_WA,
        i_B      => i_EX_RS,
        o_C      => s_Andg2_b
    ); 

    data_hazard_org2 : org2 port map(
        i_A      => s_Andg2_a,
        i_B      => s_Andg2_b,
        o_C      => s_Org2
    );

    data_hazard : andg2 port map(
        i_A      => i_MEM_MemToReg,
        i_B      => s_Org2,
        o_C      => dataHazard
    ); 
     
    --this will essentially cause a NOP to be inserted 
    o_stall_IF_ID <= dataHazard;
    o_stall_ID_EX <= dataHazard;
    o_stall_EX_MEM <= dataHazard;
    o_flush_EX_MEM <= dataHazard;

end structural;
