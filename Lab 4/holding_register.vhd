--Lakshana Kathirkamaranjan
--Isabelle Cortez

library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port ( --creating input and output variables 

	clk					: in std_logic;
	reset				: in std_logic;
	register_clr		: in std_logic;
	din					: in std_logic;
	dout				: out std_logic

);

end holding_register;
 
architecture circuit of holding_register is

	Signal sreg				: std_logic; --temporary variable for the value inbetween th DFFs
	
BEGIN
	
	PROCESS(clk)

	BEGIN

		IF (rising_edge(clk)) THEN --changes when the clock is '1'

			IF (reset = '1') THEN --needs to be '1' to change sreg value to '0' 

				sreg <= '0'; 

			ELSE 

				sreg <= ((sreg OR din) AND NOT (register_clr OR reset)); --assigns feedback and output value

			END IF;

		END IF;

	END PROCESS;

		dout <= sreg; --value of sreg = dout 
	
END;