library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Compx4 is port (
   
   input_A2, input_B2	   					 :  in  std_logic_vector(3 downto 0);  --inputs
   out_greater2, out_equal2, out_lesser2   :  out std_logic   --outputs
);
end Compx4;



architecture comparator2 of Compx4 is 

	signal AGTB 			: std_logic_vector(3 downto 0); 
	signal AEQB				: std_logic_vector(3 downto 0); 
	signal ALTB				: std_logic_vector(3 downto 0); 
	
	
component Compx1 port( --importing Compx1 components 

	input_A, input_B 								: in std_logic; 
	greater_A,  out_equal, greater_B  : out std_logic 
); 
end component Compx1; 

BEGIN 




	INST1: Compx1 port map (input_A2(0), input_B2(0), AGTB(0), AEQB(0), ALTB(0)); 
	INST2: Compx1  port map(input_A2(1), input_B2(1), AGTB(1), AEQB(1), ALTB(1)); 
	INST3: Compx1  port map(input_A2(2), input_B2(2), AGTB(2), AEQB(2), ALTB(2)); 
	INST4: Compx1  port map(input_A2(3), input_B2(3), AGTB(3), AEQB(3), ALTB(3)); 


out_equal2 <= AEQB(3) AND AEQB(2) AND AEQB(1) AND AEQB(0);
out_greater2 <= AGTB(3) OR (AEQB(3) AND AGTB(2)) OR (AEQB(3) AND AEQB(2) AND AGTB(1)) OR (AEQB(3) AND AEQB(2) AND AEQB(1) AND AGTB(0));
out_lesser2 <= ALTB(3) OR (AEQB(3) AND ALTB(2)) OR (AEQB(3) AND AEQB(2) AND ALTB(1)) OR (AEQB(3) AND AEQB(2) AND AEQB(1) AND ALTB(0)); 

END;









