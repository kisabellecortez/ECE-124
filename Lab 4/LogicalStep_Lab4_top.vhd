--Author: Group 13, Lakshana Kathirkamaranjan, Isabelle Cortez
--July 21, 2023
--Lab 4

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS

	--creating inputs and outputs for LogicalStep_Lab4_top function 
    PORT(
		clkin_50		: in std_logic;						-- The 50 MHz FPGA Clockinput
		rst_n			: in std_logic;						-- The RESET input (ACTIVE LOW)
		pb_n			: in std_logic_vector(3 downto 0); 	-- The push-button inputs (ACTIVE LOW)
 		sw   			: in std_logic_vector(7 downto 0); 	-- The switch inputs
   		leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details on the corresponding leds

	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   		seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
		seg7_char1 		: out std_logic;					-- seg7 digi selectors
		seg7_char2  	: out std_logic						-- seg7 digi selectors

	);

END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

	--callng instances of functions, inputs and outputs
	component segment7_mux port (

        clk        		: in  std_logic := '0'; 			--internal clock 
		DIN2 			: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
		DIN1 			: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
		DOUT			: out std_logic_vector(6 downto 0); --ouput on the 7 segment
		DIG2			: out std_logic; 					--right 7 segment
		DIG1			: out std_logic 					--left 7 segment 

	);

   end component;

   component clock_generator port (

		sim_mode			: in boolean; 		-- simulation mode
		reset				: in std_logic;		-- reset signal changes to state  0
		clkin      			: in std_logic; 	--internal global clock input  -- input used for counter and register clocking
		sm_clken			: out std_logic; 	-- output used to enable the sm to advance by 1 clk.
		blink		  		: out std_logic 	-- output used for blink signal (1/4 the rate of the sm_clken)

  );

	end component;


	--component for inverting values to active low to high
   component pb_inverters port (

		rst_n					: in std_logic;						--input originally at active low (used as a reset value to clear holding register)
		rst						: out std_logic;					-- inverted reset value (active high)
		pb_n					: in std_logic_vector(3 downto 0);	--inputs of the buttons (active low)	
		pb			  			: out std_logic_vector(3 downto 0)	--inverted values of the buttons (active low to active high)

  );

   end component;

	component synchronizer port(

		clk					: in std_logic; --internal gloabl clock input
		reset				: in std_logic; --reset function to turn value to 
		din					: in std_logic; --input of the first DFF
		dout				: out std_logic --output of the (shift register)

	);

   end component;
	
	component holding_register port (

		clk					: in std_logic; --internal global clock input
		reset				: in std_logic; -- reset is also used as a clearing signal; if value is '1' then it turns output of  DFF to '0'
		register_clr		: in std_logic; --signal used to clear the holding register
		din					: in std_logic; --input of first DFF
		dout				: out std_logic --output of last DFF

  );

  end component;
  
  -- component used to remove "cross-talk noise glitches" on the pb_n and rst_n inputs
	component PB_filters port (

		clkin				: in std_logic; 						--internal global clock input 
		rst_n				: in std_logic; 						-- input of the reset signal
		rst_n_filtered		: out std_logic; 						--output of filtered reset signal 
		pb_n				: in std_logic_vector (3 downto 0);  	--input of push buttons pins on board
		pb_n_filtered		: out std_logic_vector(3 downto 0)		--outputted push button signal

		); 

	end component;

	component state_machine_moore  Port(

		clk_input																	: in std_logic; 					--global clock value; 
		enable																		: in std_logic; 					--signal to store reset
		reset																		: in std_logic; 					--signal to store the sm_clken value
		blink_sig																	: in std_logic; 					--makes green lights blink
		NSrequest, EWrequest														: in std_logic; 					--requests for pedestrian crossings -- used to store the value to indicate whether to turn on 
																														--	leds (0) or (2) for when the lights are solid green for
																														-- NS and WS respectfully.
		greenNS, yellowNS, redNS													: out std_logic; 					--states of traffic lights ('1' if on, '0' if off) -NS
		greenEW, yellowEW, redEW													: out std_logic; 					--states of traffic lights ('1' if on, '0' if off) -EW
		NS_CROSSINGS, EW_CROSSINGS													: out std_logic; 					--state of the led(1) and led(3) ('1' if on, '0' if off) - on if pedestrian request 
		NSREGISTER_CLEAR, EWREGISTER_CLEAR											: out std_logic; 					--clears request for pedestrian crossing
		stateout 																	: out std_logic_vector(3 downto 0) 	--variables used to store binary values of state numbers 
																														--to turn on corresponding leds

	);

	end component;
  
  
--				
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode							: boolean := FALSE; -- set to FALSE for LogicalStep board downloads
	                                                     				-- set to TRUE for SIMULATIONS

--	
	--temporary variables to store output data from function instances 
	signal pb										:std_logic_vector(3 downto 0); -- pb(3) is used as an active-high reset for all registers
	signal sync_out 								:std_logic_vector ( 1 downto 0); -- signal used to store each value of the two holding register instances
	signal rst_n_fil								:std_logic; --signal used to store reset filtered value
	signal synch_rst								:std_logic; -- signal used to store synchronized reset value
	signal pb_filt									:std_logic_vector (3 downto 0);
	signal sm_clken									:std_logic; -- signal used to enable the sm to advance by 1 clk.
	signal blink_sig								:std_logic; -- signal used to create blinking green  light
	signal rst										:std_logic; --reset signal

	--state of light signals ('1' if on, '0' if off)
	-- NS
	signal gsolid									:std_logic;  -- for solid green light (signal to D segment on seven seg display)
	signal asolid									:std_logic;  -- for solid amber/yellow light (signal to G segment on seven seg display)
	signal rsolid									:std_logic; -- for red light (signal to A segment on seven seg display)
	--EW
	signal gsolidEW									:std_logic;  -- for solid green light (signal to D segment on seven seg display)
	signal asolidEW									:std_logic; -- for solid amber/yellow light (signal to G segment on seven seg display)
	signal rsolidEW									:std_logic;  -- for red light (signal to A segment on seven seg display)

	--variable to store concatination for 7 segment display digits 
	signal lightNS									:std_logic_vector (6 downto 0);  --used to store concatenated values for the seven segment display to decide which segments to turn on for digit 2
	signal lightEW									:std_logic_vector (6 downto 0); --used to store concatenated values for the seven segment display to decide which segments to turn on for digit 1

	signal NS_CROSSING, EW_CROSSING					:std_logic; --pedestrian crossing signal on led(0) (NS) and led(2) (EW)

	signal requestNS, requestEW 					:std_logic; --request for pedestrian crossings

	signal REGISTER_CLEARNS, REGISTER_CLEAREW   	:std_logic; --register clear value for holding register

	BEGIN

	--connects output values to leds
	--lights to indicate when lights are green 
	leds(0) <= NS_CROSSING;   --output value of whether NS is solid green to turn on led(0)
	leds(2) <= EW_CROSSING;  --output value of whether EW is solid green to turn on led(2)
	--lights to indicate request for pedestrian crossing
	leds(1) <= requestNS;  --output value of whether a request was made to use NS crossing
	leds(3) <= requestEW; --output value of whether a request was made to use EW crossing
	
	--concatinations for 7 segment display digits 
	--NS
	lightNS <=  asolid & "00" & gsolid & "00" & rsolid;
	--EW
	lightEW <=  asolidEW & "00" & gsolidEW & "00" & rsolidEW;

	----------------------------------------------------------------------------------------------------
	INST1:	pb_inverters		port map (rst_n_fil, rst, pb_filt, pb); --inverts pb from active low to active high

	INST2:	clock_generator 	port map (sim_mode, pb(3), clkin_50, sm_clken, blink_sig); -- instance to obtain values for the enable and blinking light signal

	INST3:	PB_filters port map (clkin_50, rst_n, rst_n_fil, pb_n, pb_filt); -- instance used to remove "cross-talk noise glitches" on pb_n and rst_n values

	INST4:	synchronizer port map( clkin_50, synch_rst, rst, synch_rst); -- synchronizer to set synch_rst value

	--outputs light on 7segment
	--NS (-- if push button is clicked during states 8 and 9, will skip to sate E/14)
	INST5:	synchronizer port map (clkin_50, synch_rst, pb(0), sync_out(0)); 							--digit 2 --used to obtain the value of whether push button 0 is pushed to pass value to holding register
	INST6:	holding_register port map( clkin_50, synch_rst, REGISTER_CLEARNS, sync_out(0), requestNS); 	-- holds value of inst 5 and holds it as a request to output for state machine
	
	--EW ( if push button is clicked at states 0, 1, will skip to 6)
	INST7:	synchronizer port map(clkin_50, synch_rst, pb(1), sync_out(1)); 							--digit 1  --used to obtain the value of whether push button 1 is pushed to pass value to holding register
	INST8:	holding_register port map (clkin_50, synch_rst, REGISTER_CLEAREW, sync_out(1), requestEW); 	-- holds value of inst 7 and holds it as a request to output for state machine

	-- instance used to obtain signals of which display should be turned on, and lights depending on the state number (will skip states if correct inputs are given)
	INST9:	state_machine_moore PORT MAP(clkin_50, synch_rst, sm_clken, requestNS , requestEW, blink_sig, gsolid, asolid, rsolid,  gsolidEW, asolidEW, rsolidEW,NS_CROSSING, REGISTER_CLEARNS, REGISTER_CLEAREW, EW_CROSSING, leds(7 downto 4)); 
	
	INST10:	segment7_mux port map(clkin_50, lightEW, lightNS , seg7_data (6 downto 0), seg7_char1, seg7_char2); --instance used to display corresposnding lights on segment display digits

END SimpleCircuit;
