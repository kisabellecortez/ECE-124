library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--declaring inputs and outputs for 1bit comparator 
entity Energy_monitor is port (
   
	AGTB, AEQB, ALTB, vacation_mode, MC_test_mode, window_open, door_open: in  std_logic;  --inputs
   furnace, at_temp, AC, blower, window, door, vacation, run, increase, decrease :  out std_logic  --outputs -- MIGHT NEED TO SWITCH ORDER

);
end Energy_monitor;


architecture monitor of Energy_monitor IS 



---SIGNALS GO HERE IF WE NEED THEM
--

---vacation_mode, MC_test_mode, window_open, door_open:



---COMPONENTS




signal mux_temp2: std_logic;
signal current_temp2: std_logic;




begin 

Eng_Monitor: PROCESS (window_open, door_open, MC_TEST_mode) is
begin

	if (vacation_mode = '1') then 
		vacation <= '1';
	else
		vacation <= '0';
	end if;
	
	if (window_open = '1') then 
		window <= '1';
	else 
		window <= '0';
	end if;
	
	
		
	if (door_open = '1') then 
		door <= '1';
	else 
		door <= '0';
	end if;
	
	
	if (AGTB = '1') then 
		furnace <= '1';
		
	else 
		furnace <= '0';
		
	end if;
	
	
	if (AEQB = '1') then 
		at_temp <= '1';
		
	else 
		at_temp <= '0';
		
	end if;
	
	if (ALTB = '1') then 
		AC <= '1';
		
	else 
		AC <= '0';
		
	end if;
	
	
	
	
	

	--if (AEQB = '1') then
	--	run = '0';
	--end if;

	if ((window_open = '0') AND (door_open = '0') AND (MC_TEST_mode = '0') AND (AEQB = '0')) then 
		run <= '1'; 
		blower <= '1';
		
		if (AGTB = '1') then 
				increase <= '1';
				
			elsif (ALTB = '1') then
				decrease <= '1';
				
		end if;

	else  
		blower <= '0';
		run <= '0';
		increase <= '0';
		decrease <= '0';

	end if; 
	
	
	
	


	


	
			
			



	

	
	
END PROCESS; 


end monitor;
		
