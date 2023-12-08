library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;


component Compx4 port(
   input_A2, input_B2	   					 :  in  std_logic_vector(3 downto 0);  --inputs
   out_greater2, out_equal2, out_lesser2   :  out std_logic   --outputs

);
end component Compx4;


component Bidir_shift_reg PORT(
	 CLK				:IN std_logic := '0';
	 RESET			:IN std_logic := '0';
	 CLK_EN			:IN std_logic := '0';
	 LEFTTO_RIGHT1			:IN std_logic := '0';
	 REG_BITS			:OUT std_logic_vector(7 downto 0)
	 );
end component Bidir_shift_reg;



component U_D_Bin_Counter8bit  port(

	CLK :in std_logic;
	RESET : in std_logic;
	CLK_EN: in std_logic;
	UP1_DOWN0 : in std_logic;
	COUNTER_BITS: out std_logic_vector(7 downto 0)
);
end component U_D_Bin_Counter8bit;

component Energy_monitor port(
	AGTB, AEQB, ALTB, vacation_mode, MC_test_mode, window_open, door_open: in  std_logic;  --inputs
   furnace, at_temp, AC, blower, window, door, vacation, run, increase, decrease :  out std_logic  --outputs -- MIGHT NEED TO SWITCH ORDER
	--furnace, at_temp, AC, blower, window, door, vacation, decrease, increase,run :  out std_logic  --outputs -- MIGHT NEED TO SWITCH ORDER
	
);
end component Energy_monitor;


component Tester is port (
 MC_TESTMODE				: in  std_logic;
 I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
	
component HVAC 	port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
	);
end component;

component PB_Inverters port(
	pb_n: IN std_logic_vector(3 downto 0);
	v_m, mc_test, w_open, d_open: OUT std_logic
		
	);
END  component PB_Inverters;

component vacation_mux port(
	desired_temp, vacation_temp : in std_logic_vector(3 downto 0);
	vacation_mode								: in std_logic;
	mux_temp									: out std_logic_vector(3 downto 0) -- The hex output
	);
end component vacation_mux; 

------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------

------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);

signal pb : std_logic_vector (3 downto 0);

signal AGTB: std_logic;
signal AEQB: std_logic;
signal ALTB: std_logic;

signal mux_temp: std_logic_vector (3 downto 0);
signal current_temp: std_logic_vector (3 downto 0);
signal mt_7seg: std_logic_vector (6 downto 0);
signal ct_7seg: std_logic_vector (6 downto 0);
signal run:std_logic;
signal increase : std_logic;
signal decrease : std_logic;

signal vacation_mode : std_logic; 
signal MC_TEST_mode : std_logic; 
signal window_open : std_logic;
signal door_open : std_logic; 
signal desired_temp: std_logic_vector (3 downto 0);
signal vacation_temp: std_logic_vector (3 downto 0);




------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input


-- temp inputs hook-up to internal busses.
desired_temp <= sw(3 downto 0);
vacation_temp <= sw(7 downto 4);




INST1: sevensegment port map (hex_A, hexA_7seg);
INST2: sevensegment port map (hex_B, hexB_7seg);
INST3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
INST4: Compx4 port map (hex_A, hex_B, AGTB, AEQB, ALTB);
INST5: PB_Inverters port map (pb_n(3 downto 0), vacation_mode, MC_TEST_mode, window_open, door_open);
INST6: vacation_mux port map (desired_temp, vacation_temp, vacation_mode, hex_A); 
INST7: Energy_Monitor port map (AGTB, AEQB, ALTB, vacation_mode, MC_TEST_mode, window_open, door_open, leds(0), leds(1), leds(2), leds (3), leds(4), leds(5), leds (7), run, increase, decrease);
INST8: HVAC port map (HVAC_SIM, clkin_50, run, increase, decrease, hex_B);
INST9: Tester port map (MC_TEST_mode, AEQB, AGTB, ALTB, desired_temp, hex_B,leds(6));









--INST4: Compx4 port map (hex_A, hex_B, leds(2), leds(1), leds(0));
--INST5: Bidir_shift_reg port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
--INST6: U_D_Bin_Counter8bit port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));


--INST8: SevenSegment port map (mux_temp, mt_7seg);

--INST9: SevenSegment port map (current_temp, ct_7seg);

--INST12: segment7_mux port map (clkin_50, mt_7seg, ct_7seg, SEG7_DATA, SEG7_CHAR2, SEG7_CHAR1);




end design;

