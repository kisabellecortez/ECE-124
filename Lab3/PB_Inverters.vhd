LIBRARY ieee;
USE ieee.std_logic_1164.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

ENTITY PB_Inverters IS

	PORT --declaring input and output variables
	(
		pb_n: IN std_logic_vector(3 downto 0);
		v_m, mc_test, w_open, d_open: OUT std_logic
		
		);
	END  PB_Inverters;
	
	ARCHITECTURE gates OF PB_Inverters IS
	
	
	BEGIN
	
	v_m <= not(pb_n(3)); 
	mc_test <= not(pb_n(2)); 
	w_open <= not(pb_n(1)); 
	d_open <= not(pb_n(0)); 
	
	END gates;