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
       i_EX_Jump           : in std_logic;
       i_EX_Branch         : in std_logic;
       i_EX_MemToReg       : in std_logic;
       i_EX_RT             : in std_logic_vector(4 downto 0);
       i_ID_RS             : in std_logic_vector(4 downto 0);
       i_ID_RT             : in std_logic_vector(4 downto 0);


       o_stall             : out std_logic;
       o_flush             : out std_logic
   );
end component;


-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK : std_logic := '0';


signal s_EX_Jump : std_logic;
signal s_EX_Branch : std_logic;
signal s_EX_MemToReg : std_logic;
signal s_EX_RT : std_logic_vector(4 downto 0);
signal s_ID_RS : std_logic_vector(4 downto 0);
signal s_ID_RT : std_logic_vector(4 downto 0);
signal s_stall : std_logic;
signal s_flush : std_logic;

begin

 -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
 -- input or output. Note that DUT0 is just the name of the instance that can be seen
 -- during simulation. What follows DUT0 is the entity name that will be used to find
 -- the appropriate library component during simulation loading.
 DUT0: StallingUnit
  port MAP(
    i_EX_Jump => s_EX_Jump,
    i_EX_Branch => s_EX_Branch,
    i_EX_MemToReg => s_EX_MemToReg,
    i_EX_RT => s_EX_RT,
    i_ID_RS => s_ID_RS,
    i_ID_RT => s_ID_RT,
    o_stall => s_stall,
    o_flush => s_flush
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

    -- Load word instruction detected in the execution stage
    s_EX_Jump <= '0';
    s_EX_Branch <= '0';
    s_EX_MemToReg <= '1';     -- Set to 1 to indicate a load word instruction
    s_EX_RT <= "00001";      -- Assuming the load word instruction writes to register 1
    s_ID_RS <= "00100";      
    s_ID_RT <= "00000";      

    -- Wait for a clock cycle to observe outputs
    wait for gCLK_HPER;

    -- Branch instruction detected 
    s_EX_Jump <= '0';
    s_EX_Branch <= '1';    -- Set to 1 to indicate a branch instruction
    s_EX_MemToReg <= '0';
    s_EX_RT <= (others => '0');
    s_ID_RS <= (others => '0');
    s_ID_RT <= (others => '0');

    -- Wait for a clock cycle to observe outputs
    wait for gCLK_HPER;

    -- Jump instruction detected 
    s_EX_Jump <= '1';    -- Set to 1 to indicate a jump instruction
    s_EX_Branch <= '0';
    s_EX_MemToReg <= '0';
    s_EX_RT <= (others => '0');
    s_ID_RS <= (others => '0');
    s_ID_RT <= (others => '0');

    -- Wait for a clock cycle to observe outputs
    wait for gCLK_HPER;

   wait;
 end process;


end mixed;
