-- Nbit_8t1Mux.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity Nbit_8t1Mux is
    generic (N : integer := 32);

    --Port Declaration
    port (
        i_select        : in std_logic_vector(3-1 downto 0);
        i_A             : in std_logic_vector(N-1 downto 0);
        i_B             : in std_logic_vector(N-1 downto 0);
        i_C             : in std_logic_vector(N-1 downto 0);
        i_D             : in std_logic_vector(N-1 downto 0);
        i_E             : in std_logic_vector(N-1 downto 0);
        i_F             : in std_logic_vector(N-1 downto 0);
        i_G             : in std_logic_vector(N-1 downto 0);
        i_H             : in std_logic_vector(N-1 downto 0);
        o_Output        : out std_logic_vector(N-1 downto 0)
        );
end entity Nbit_8t1Mux;

architecture Structural of Nbit_8t1Mux is

    -- Component Declaration
    component mux2t1_N is
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Signal Declaration
    signal Stage1Mux0toMux4, Stage1Mux1toMux4 : std_logic_vector(N-1 downto 0);
    signal Stage1Mux2toMux5, Stage1Mux3toMux5 : std_logic_vector(N-1 downto 0);

    signal Stage2Mux4toMux6, Stage2Mux5toMux6 : std_logic_vector(N-1 downto 0);

begin

    -- Component Instantiation

   -- mux2t1_N Instantiation
   Mux0 : mux2t1_N
   port map ( 
       i_S             => i_select(0),
       i_D0             => i_A,
       i_D1           => i_B,
       o_O             => Stage1Mux0toMux4
   );

   Mux1 : mux2t1_N
   port map ( 
       i_S             => i_select(0),
       i_D0             => i_C,
       i_D1           => i_D,
       o_O             => Stage1Mux1toMux4
   );

   Mux2 : mux2t1_N
   port map ( 
       i_S             => i_select(0),
       i_D0             => i_E,
       i_D1           => i_F,
       o_O             => Stage1Mux2toMux5
   );

   Mux3 : mux2t1_N
   port map ( 
       i_S             => i_select(0),
       i_D0             => i_G,
       i_D1           => i_H,
       o_O             => Stage1Mux3toMux5
   );

   Mux4 : mux2t1_N
   port map ( 
       i_S             => i_select(1),
       i_D0             => Stage1Mux0toMux4,
       i_D1           => Stage1Mux1toMux4,
       o_O             => Stage2Mux4toMux6
   );

   Mux5 : mux2t1_N
   port map ( 
       i_S             => i_select(1),
       i_D0             => Stage1Mux2toMux5,
       i_D1           => Stage1Mux3toMux5,
       o_O             => Stage2Mux5toMux6
   );

   Mux6 : mux2t1_N
   port map ( 
       i_S             => i_select(2),
       i_D0             => Stage2Mux4toMux6,
       i_D1           => Stage2Mux5toMux6,
       o_O             => o_Output
   );


end Structural;