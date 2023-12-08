library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--declaring inputs and outputs for 1bit comparator 
entity Compx1 is port (
   
   input_A, input_B	   					 :  in  std_logic;  --inputs
	greater_A,  out_equal, greater_B  : out std_logic
);
end Compx1;


architecture comparator of Compx1 is

begin 

greater_A <= input_A AND (not(input_B));

out_equal <= input_A XNOR input_B;

greater_B <= input_B AND (not(input_A));

--


end comparator; 




