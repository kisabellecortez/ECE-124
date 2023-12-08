library ieee;
use ieee.std_logic_1164.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

entity hex_mux is


port ( --declaring inpput and output variables


	hex_num3,hex_num2,hex_num1,hex_num0 : in std_logic_vector(3 downto 0);
	mux_select									: in std_logic_vector(1 downto 0);
	hex_out 										: out std_logic_vector(3 downto 0) -- The hex output
);

end  hex_mux;



architecture mux_logic of hex_mux is

begin

--for the multyiplexing of four hex input busses
--
with mux_select(1 downto 0) select
--assigning the variable of each of the logic operations 
hex_out <= hex_num0 when"00",
				hex_num1 when "01",
				hex_num2 when "10",
				hex_num3 when "11";
				
				
end mux_logic;