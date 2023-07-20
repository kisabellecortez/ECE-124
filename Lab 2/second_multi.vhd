library ieee;
use ieee.std_logic_1164.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

entity second_multi is


port ( --declaring inpput and output variables


	hex_num1_2,hex_num0_2 : in std_logic_vector(3 downto 0);
	mux2_select									: in std_logic;
	hex_out_2 										: out std_logic_vector(3 downto 0) -- The hex output
);

end  second_multi;



architecture mux2_logic of second_multi is

begin

--for the multyiplexing of four hex input busses
--
with mux2_select select
		--assigning the variable of each of the logic operations 
hex_out_2 <= hex_num0_2 when '0',
				hex_num1_2 when  '1';
end mux2_logic;