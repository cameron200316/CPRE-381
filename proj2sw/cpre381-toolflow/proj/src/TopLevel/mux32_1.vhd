-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux32_1 is
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(
       i_MUX31         : in std_logic_vector(N-1 downto 0);
       i_MUX30         : in std_logic_vector(N-1 downto 0);
       i_MUX29         : in std_logic_vector(N-1 downto 0);
       i_MUX28         : in std_logic_vector(N-1 downto 0);
       i_MUX27         : in std_logic_vector(N-1 downto 0);
       i_MUX26         : in std_logic_vector(N-1 downto 0);
       i_MUX25         : in std_logic_vector(N-1 downto 0);
       i_MUX24         : in std_logic_vector(N-1 downto 0);
       i_MUX23         : in std_logic_vector(N-1 downto 0);
       i_MUX22         : in std_logic_vector(N-1 downto 0);
       i_MUX21         : in std_logic_vector(N-1 downto 0);
       i_MUX20         : in std_logic_vector(N-1 downto 0);
       i_MUX19         : in std_logic_vector(N-1 downto 0);
       i_MUX18         : in std_logic_vector(N-1 downto 0);
       i_MUX17         : in std_logic_vector(N-1 downto 0);
       i_MUX16         : in std_logic_vector(N-1 downto 0);
       i_MUX15         : in std_logic_vector(N-1 downto 0);
       i_MUX14         : in std_logic_vector(N-1 downto 0);
       i_MUX13         : in std_logic_vector(N-1 downto 0);
       i_MUX12         : in std_logic_vector(N-1 downto 0);
       i_MUX11         : in std_logic_vector(N-1 downto 0);
       i_MUX10         : in std_logic_vector(N-1 downto 0);
       i_MUX9          : in std_logic_vector(N-1 downto 0);
       i_MUX8          : in std_logic_vector(N-1 downto 0);
       i_MUX7          : in std_logic_vector(N-1 downto 0);
       i_MUX6          : in std_logic_vector(N-1 downto 0);
       i_MUX5          : in std_logic_vector(N-1 downto 0);
       i_MUX4          : in std_logic_vector(N-1 downto 0);
       i_MUX3          : in std_logic_vector(N-1 downto 0);
       i_MUX2          : in std_logic_vector(N-1 downto 0);
       i_MUX1          : in std_logic_vector(N-1 downto 0);
       i_MUX0          : in std_logic_vector(N-1 downto 0);
       i_WA            : in std_logic_vector(4 downto 0);
       o_OUT           : out std_logic_vector(N-1 downto 0));

end mux32_1;

architecture structural of mux32_1 is

begin  

  with i_WA select
   o_OUT <= i_MUX31 when "11111",
	    i_MUX30 when "11110",
	    i_MUX29 when "11101",
	    i_MUX28 when "11100",
	    i_MUX27 when "11011",
	    i_MUX26 when "11010",
	    i_MUX25 when "11001",
	    i_MUX24 when "11000",
	    i_MUX23 when "10111",
	    i_MUX22 when "10110",
	    i_MUX21 when "10101",
	    i_MUX20 when "10100",
	    i_MUX19 when "10011",
	    i_MUX18 when "10010",
	    i_MUX17 when "10001",
	    i_MUX16 when "10000",
	    i_MUX15 when "01111",
	    i_MUX14 when "01110",
	    i_MUX13 when "01101",
	    i_MUX12 when "01100",
	    i_MUX11 when "01011",
	    i_MUX10 when "01010",
	    i_MUX9  when "01001",
	    i_MUX8  when "01000",
	    i_MUX7  when "00111",
	    i_MUX6  when "00110",
	    i_MUX5  when "00101",
	    i_MUX4  when "00100",
	    i_MUX3  when "00011",
	    i_MUX2  when "00010",
	    i_MUX1  when "00001",
	    i_MUX0  when "00000",
            "00000000000000000000000000000000" when others;
  
end structural;
