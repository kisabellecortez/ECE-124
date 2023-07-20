library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Lakshana Kathirkamaranjan
--Isabelle Cortez

entity LogicalStep_Lab2_top is port ( 
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port ( --calling the functions of SevenSegment
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component segment7_mux port ( --calling the functions of segment7_mux
		clk 			:in std_logic := '0';
		DIN2 			:in std_logic_vector(6 downto 0);
		DIN1 			:in std_logic_vector(6 downto 0);
		DOUT 			:OUT std_logic_vector(6 downto 0);
		DIG2 			:OUT std_logic;
		DIG1 			:OUT std_logic
		);
	end component;

	
	component PB_Inverters port ( --calling the functions of PB_Inverters
		pb_n: IN std_logic_vector(3 downto 0);
		pb: OUT std_logic_vector(3 downto 0)
		);
	end component;
	
	
	component Logic_Processor port ( --calling the functions of Logic_Processor
			logic_in0, logic_in1: in std_logic_vector(3 downto 0);
			logic_select									: in std_logic_vector(1 downto 0);
			logic_out 										: out std_logic_vector(3 downto 0)
			);
	end component;
	
	component full_adder_4bit port --calling the functions of full_adder_4bit
	( 
		--declaring inputs 
		Carry_In 																				  : in  std_logic := '0';  
		BUS0_b3, BUS1_b3, BUS0_b2, BUS1_b2, BUS0_b1, BUS1_b1, BUS0_b0, BUS1_b0 : in std_logic; 
		
		--declaring outputs
		Carry_Out3 																				  : out std_logic;    
		Sum 																						  : out std_logic_vector(3 downto 0)
	);
	
	end component;
	
	component second_multi port
	(
		hex_num1_2,hex_num0_2 : in std_logic_vector(3 downto 0);
		mux2_select									: in std_logic;
		hex_out_2 										: out std_logic_vector(3 downto 0) -- The hex output
		);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--declaring 4bit signals
	signal hex_A		: std_logic_vector(3 downto 0);
	signal hex_B 		:std_logic_vector(3 downto 0);
	
	signal pb			: std_logic_vector(3 downto 0);
	signal hex_sum 		:std_logic_vector(3 downto 0);
	
	signal signal_C : std_logic_vector (3 downto 0);
	
--declaring 7bit signals
	signal seg7_A		: std_logic_vector(6 downto 0);
	signal seg7_B		: std_logic_vector(6 downto 0);

--declaring ouput variable of full_adder_4bit
	signal carry_out :std_logic;
	signal select_2to1 :std_logic;
	
	signal Operand_A : std_logic_vector (3 downto 0);
	signal Operand_B : std_logic_vector (3 downto 0);
	
	signal hex_out : std_logic_vector (3 downto 0);
	--signal hex_C		: std_logic_vector(3 downto 0);
	--signal hex_D 		:std_logic_vector(3 downto 0);

	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0); --connects switch inputs 0-3
	hex_B <= sw(7 downto 4); --connects switch inputs 4-7

	signal_C <= "000" & carry_out; --creates a 4bit signal

--COMPONENT HOOKUP 
--
--generate the seven segment coding 
	

	
	INST1: PB_Inverters port map(pb_n, pb);
	INST2: Logic_Processor port map(hex_A, hex_B, pb(1 downto 0), leds(3 downto 0)); 
	INST3: full_adder_4bit port map('0', hex_A(3), hex_B(3), hex_A(2), hex_B(2), hex_A(1), hex_B(1), hex_A(0), hex_B(0), carry_out, hex_sum); --initializes an instance of the full_adder_4bit 
	
	INST4: second_multi port map ( hex_B, signal_C, pb_n(2), Operand_A);
	INST5: second_multi port map ( hex_A, hex_sum, pb_n(2), Operand_B);
	INST6: SevenSegment port map(Operand_A, seg7_B); 
	INST7: SevenSegment port map(Operand_B, seg7_A); 
	INST8: segment7_mux port map(clkin_50, seg7_B, seg7_A, seg7_data (6 downto 0), seg7_char1, seg7_char2); 

	end SimpleCircuit;

