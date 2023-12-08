library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

entity full_adder_4bit is 


port ( --declaring inpput and output variables
   Carry_In 																				  : in  std_logic := '0';  
	BUS0_b3, BUS1_b3, BUS0_b2, BUS1_b2, BUS0_b1, BUS1_b1, BUS0_b0, BUS1_b0 : in std_logic; --inputs for inputA and inputB in the full_adder_1bit
   Carry_Out3 																				  : out std_logic;    
	Sum 																						  : out std_logic_vector(3 downto 0) --stores the sums from each of the full_adder_1bit iterations
	
); 
end full_adder_4bit;

architecture adder_4bit_logic of full_adder_4bit is
--
-- Components Used ---
------------------------------------------------------------------- 
component full_adder_1bit port --calling the functions of full_adder_1bit
( 

	input_B, input_A, carry_in : in std_logic;
	FULL_ADDER_CARRY_OUTPUT, FULL_ADDER_SUM_OUTPUT: out std_logic
	
); 
end component;
	

	

	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR

 signal Carry_Out0: std_logic; --initializing signals for the supplementary outputs
 signal Carry_Out1: std_logic;
 signal Carry_Out2: std_logic;
	
	
-- Here the circuit begins

begin


--COMPONENT HOOKUP 
--
--generate the seven segment coding 


	--creating instances that implement full_adder_1bit
	INST1: full_adder_1bit port map(BUS0_b0, BUS1_b0, Carry_In, Carry_Out0, Sum(0)); --initializing the imputs and outputs for each instance 
	INST2: full_adder_1bit port map(BUS0_b1, BUS1_b1, Carry_Out0, Carry_Out1, Sum(1));
	INST3: full_adder_1bit port map(BUS0_b2, BUS1_b2, Carry_Out1, Carry_Out2, Sum(2));
	INST4: full_adder_1bit port map(BUS0_b3, BUS1_b3, Carry_Out2, Carry_Out3, Sum(3));
	


	
	

	end adder_4bit_logic;