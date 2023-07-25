--Author: Group 13, Lakshana Kathirkamaranjan, Isabelle Cortez
--July 21, 2023
--Lab 4

library ieee;
use ieee.std_logic_1164.all;

--declaring synchronizer input and output variables 
entity synchronizer is port (

	clk					: in std_logic; --internal global clock input
	reset				: in std_logic; --reset function to turn value to 
	din					: in std_logic; --input of the first DFF
	dout				: out std_logic --output of the (shift register)

);

end synchronizer;
 
architecture circuit of synchronizer is

	Signal sreg			: std_logic_vector(1 downto 0); --signal for the inbetween value of the DFFs

	BEGIN
	 	 
	process(clk) 
	
		begin 

	 		if (rising_edge(clk)) then --inputs changes when the clock turns '1'

				sreg(0) <= (not reset AND din); --output of first DFF
				sreg(1) <= (not reset AND sreg(0)); --output of second DFF
		
			end if;
		
	end process;

	dout <=  sreg(1); --sreg = dout, feedback value is the output value 
	 
end;
