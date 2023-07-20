library ieee;
use ieee.std_logic_1164.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

entity vacation_mux is


port ( --declaring inpput and output variables


	desired_temp, vacation_temp : in std_logic_vector(3 downto 0);
	vacation_mode								: in std_logic;
	mux_temp									: out std_logic_vector(3 downto 0) -- The hex output
);

end  vacation_mux;



architecture mux_logic of vacation_mux is

begin

--for the multyiplexing of four hex input busses
--
with vacation_mode select
		--assigning the variable of each of the logic operations 
mux_temp <= desired_temp when '0',
				vacation_temp when  '1';
end mux_logic;