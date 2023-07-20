library ieee;
use ieee.std_logic_1164.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

entity Logic_Processor is


port ( --declaring input and output variables


	logic_in0, logic_in1: in std_logic_vector(3 downto 0);
	logic_select									: in std_logic_vector(1 downto 0);
	logic_out 										: out std_logic_vector(3 downto 0) -- The hex output

);
  
  
  
end  Logic_Processor;



architecture process_logic of Logic_Processor is

begin

--for the multyiplexing of four hex input busses
with logic_select(1 downto 0) select
--assigning the variable of each of the logic operations 
logic_out <= logic_in0 AND logic_in1 when"00",
				logic_in0 OR logic_in1 when "01",
				logic_in0 XOR logic_in1 when "10",
				logic_in0 XNOR logic_in1 when "11";


--logic_in0 AND logic_in1 when"11",
				--logic_in0 OR logic_in1 when "10",
				--logic_in0 XOR logic_in1 when "01",
				--logic_in0 XNOR logic_in1 when "00";

		
			
							
end process_logic;