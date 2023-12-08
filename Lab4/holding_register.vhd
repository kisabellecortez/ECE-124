library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic;
	
BEGIN
	
	
	PROCESS(clk)
	BEGIN

		
		---D<= ((register_clr NOR reset) AND  (din OR sreg));
		IF (rising_edge(clk)) THEN
			IF (reset = '1') THEN
				sreg <= '0';
			ELSE 
				sreg <= ((sreg OR din) AND NOT (register_clr OR reset));
			END IF;

		END IF;
	END PROCESS;
		 dout <= sreg;
	
END;