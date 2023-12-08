library ieee;
use ieee.std_logic_1164.all;


entity synchronizer is port (

			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0);

BEGIN

	--process(clk)
	--begin 
	 --if (rising_edge(clk)) then
		--if(reset = '1') then 
		--	dout<= '0'
		--else
		--	dout<= din;
		--end if;
	 --end if ;
	-- end process;
	 
	 
	 
	process(clk) 
	--begin 
	-- if (rising_edge(clk)) then
		--if(reset = '1' AND din = '0') then 
		--	sreg(1)<= '0';
	--	elsif (reset = '0' AND din = '1') then
	--		sreg(1)<= '1';
	--	end if;
		
		--if(reset = '1' AND sreg(1) = '0') then 
			--dout<= '0';
		--elsif (reset = '0' AND sreg(1) = '1') then
		--	dout<= '1';
		--end if;

--	end if ;
	
	begin 
	 if (rising_edge(clk)) then
	 
	 
	 
	sreg(0) <= (not reset AND din);
	sreg(1) <= (not reset AND sreg(0));
		

		
	end if;
	 
	 
		
	end process;
	dout <=  sreg(1); 
	 

end;