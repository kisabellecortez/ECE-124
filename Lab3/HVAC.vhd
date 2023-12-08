LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- clk input is the logicalstep 50MHz clock input


--initial default value must start at mid-scale(Hex 7)

entity HVAC is

	port
	(
		HVAC_SIM : IN boolean; --temp out changes at a rate 1 degree every 330 msec ; used to direct the HVAC operation for simulation HVAC_SIM:=TRUE
		clk : in std_logic;
		run : in std_logic; -- HVAC will only turn on when run is active
		increase, decrease : in std_logic;
		temp : out std_logic_vector(3 downto 0) --changes according to which of two qualifier signals (increase or decrease) is active with run also being active
	
		--limits of temp 0000 and 1111
	);
	
end entity;
	
architecture rtl of HVAC is  --Heating, Ventilation and Air Conditioning 
	signal clk_2hz : std_logic;
	signal HVAC_clock : std_logic;
	signal digital_counter : std_logic_vector(23 downto 0);
	
	
	
begin


--clk_divider process generates a 2Hz Clck from the 50 Mhz clk
	clk_divider: process (clk)
		variable counter: unsigned(23 downto 0);
		
		begin
		
		--Synchronously update counter
			if (rising_edge (clk)) then
						counter := counter + 1;
			end if;
			
			
			digital_counter <= std_logic_vector(counter);
			
			
	end process;
		

	clk_2hz <= digital_counter(23);

	clk_mux: process (HVAC_SIM)

	begin 
		if (HVAC_SIM) then
		
				HVAC_clock <= clk;
				
		else
				HVAC_clock <= clk_2hz;
				
		end if;
		
	end process;
	
	
	
counter: process (HVAC_clock)

	variable cnt : unsigned(3 downto 0) := "0111";
	begin
	
	
	--synchronously update counter 
		IF ((rising_edge(HVAC_clock))	AND (run = '1')) then 
			IF ((increase = '1') AND (cnt <	"1111"))	then 
			cnt := cnt + 1 ;
			
			ELSIF ((decrease = '1')AND (cnt > "0000")) then
			cnt := cnt - 1 ;
			
			END IF; 
		END IF;
		
	
	
	--Output the current count
		temp <= std_logic_vector(cnt);
	
	end process;
	
end rtl;