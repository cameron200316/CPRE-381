library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_StallingUnit is
 generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_StallingUnit;


architecture mixed of tb_StallingUnit is


-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component StallingUnit is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
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
end component;


-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := "00000" just make all the signals start at an initial value of zero
signal CLK : std_logic := '0';


signal s_EX_Jump       : std_logic := '0';
signal s_EX_Branch     : std_logic := '0';
signal s_branch_taken  : std_logic := '0';
signal s_MEM_MemToReg  : std_logic := '0';
signal s_MEM_WA        : std_logic_vector(4 downto 0)  := "00000";
signal s_EX_RS         : std_logic_vector(4 downto 0)  := "00000";
signal s_EX_RT         : std_logic_vector(4 downto 0)  := "00000";
signal s_flush_IF_ID   : std_logic := '0';
signal s_flush_ID_EX   : std_logic := '0';
signal s_stall_IF_ID   : std_logic := '0';
signal s_stall_ID_EX   : std_logic := '0';
signal s_stall_EX_MEM  : std_logic := '0';
signal s_flush_EX_MEM  : std_logic := '0';

begin

 -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
 -- input or output. Note that DUT0 is just the name of the instance that can be seen
 -- during simulation. What follows DUT0 is the entity name that will be used to find
 -- the appropriate library component during simulation loading.
 DUT0: StallingUnit
  port MAP(
        i_EX_Jump       => s_EX_Jump,
        i_EX_Branch     => s_EX_Branch,
        i_branch_taken  => s_branch_taken,
        i_MEM_MemToReg  => s_MEM_MemToReg,
        i_MEM_WA        => s_MEM_WA,
        i_EX_RS         => s_EX_RS,
        i_EX_RT         => s_EX_RT,
        o_flush_IF_ID   => s_flush_IF_ID,
        o_flush_ID_EX   => s_flush_ID_EX,
        o_stall_IF_ID   => s_stall_IF_ID,
        o_stall_ID_EX   => s_stall_ID_EX,
        o_stall_EX_MEM  => s_stall_EX_MEM,
        o_flush_EX_MEM  => s_flush_EX_MEM
  );


  --This first process is to setup the clock for the test bench
 P_CLK: process
 begin
   CLK <= '1';         -- clock starts at 1
   wait for gCLK_HPER; -- after half a cycle
   CLK <= '0';         -- clock becomes a 0 (negative edge)
   wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
 end process;
  -- Assign inputs for each test case.
 -- TODO: add test cases as needed.
 P_TEST_CASES: process
 begin
   wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

        -- Test case 1: No hazards
        s_EX_Jump       <= '0';
        s_EX_Branch     <= '0';
        s_branch_taken  <= '0';
        s_MEM_MemToReg  <= '0';
        s_MEM_WA        <= "00000";
        s_EX_RS         <= "00000";
        s_EX_RT         <= "00000";
        wait for gCLK_HPER;

        -- Test case 2: Control Hazard (Flush IF_ID and Flush ID_EX)
        s_EX_Jump       <= '1';
        s_EX_Branch     <= '0';
        s_branch_taken  <= '0';
        s_MEM_MemToReg  <= '0';
        s_MEM_WA        <= "00000";
        s_EX_RS         <= "00000";
        s_EX_RT         <= "00000";
        wait for gCLK_HPER;

        -- Test case 3: Control Hazard (Flush IF_ID)
        s_EX_Jump       <= '0';
        s_EX_Branch     <= '1';
        s_branch_taken  <= '0';
        s_MEM_MemToReg  <= '0';
        s_MEM_WA        <= "00000";
        s_EX_RS         <= "00000";
        s_EX_RT         <= "00000";
        wait for gCLK_HPER;

        -- Test case 4: Control Hazard (Flush ID_EX)
        s_EX_Jump       <= '0';
        s_EX_Branch     <= '1';
        s_branch_taken  <= '1';
        s_MEM_MemToReg  <= '0';
        s_MEM_WA        <= "00000";
        s_EX_RS         <= "00000";
        s_EX_RT         <= "00000";
        wait for gCLK_HPER;

        -- Test case 5: Data Hazard (Stall IF_ID and ID_EX)
        s_EX_Jump       <= '0';
        s_EX_Branch     <= '0';
        s_branch_taken  <= '0';
        s_MEM_MemToReg  <= '1';
        s_MEM_WA        <= "01010";
        s_EX_RS         <= "01010";
        s_EX_RT         <= "01010";
        wait for gCLK_HPER;

   wait;
 end process;


end mixed;
