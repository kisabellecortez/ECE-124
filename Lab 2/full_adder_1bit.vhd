library ieee;
use ieee.std_logic_1164.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

entity full_adder_1bit is



port ( --declaring inpput and output variables


	input_B, input_A, carry_in : in std_logic;

	FULL_ADDER_CARRY_OUTPUT : out std_logic;
	FULL_ADDER_SUM_OUTPUT: out std_logic
);

end  full_adder_1bit;



architecture adder_logic of full_adder_1bit is

 signal HALF_ADDER_SUM_OUTPUT: std_logic;
 signal HALF_ADDER_CARRY_OUTPUT: std_logic;
 
 signal SECOND_AND: std_logic;
 

begin

--for the multyiplexing of four hex input busses
--assigning the variable of each of the logic operations 
	HALF_ADDER_SUM_OUTPUT <= input_B XOR input_A;
	HALF_ADDER_CARRY_OUTPUT <= input_B AND input_A;
	FULL_ADDER_SUM_OUTPUT <= HALF_ADDER_SUM_OUTPUT XOR carry_in;
	SECOND_AND <= carry_in AND HALF_ADDER_SUM_OUTPUT;
	FULL_ADDER_CARRY_OUTPUT <= HALF_ADDER_CARRY_OUTPUT OR SECOND_AND;

end adder_logic;

	
