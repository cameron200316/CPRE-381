library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.my_package.all;

entity Nbit_mux_32to1 is
    port (
        i_Regs : in t_bus_32x32;
        i_S : in std_logic_vector(5-1 downto 0);
        o_O : out std_logic_vector(32-1 downto 0)
    );
end Nbit_mux_32to1;

architecture dataflow of Nbit_mux_32to1 is
    begin   
        o_O <= i_Regs(to_integer(unsigned(i_S)));
end dataflow;