--Author: Group 13, Lakshana Kathirkamaranjan, Isabelle Cortez
--July 21, 2023
--Lab 4

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine_moore IS Port(

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

END ENTITY;
 

 Architecture SM of State_Machine_moore is
 
 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9,S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values

 


 SIGNAL current_state, next_state	:  STATE++_NAMES;     	-- signals of type STATE_NAMES



 BEGIN

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS 
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (reset = '1') THEN
			current_state <= S0;
		ELSIF (reset = '0' AND enable = '1') THEN -- AND enable = 1
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS 

Transition_Section: PROCESS ( EWrequest, NSrequest, current_state) 

BEGIN
  CASE current_state IS

        WHEN S0 =>

			IF (EWrequest ='1' AND NSrequest ='0' ) then --if pedestrian crossing for EW is on then skips to state 6
				next_state <= S6;

			else --not pressed, continues to next state
				next_state <= S1;

			end if;
					
         WHEN S1 =>	

					IF (EWrequest ='1' AND NSrequest ='0') then --if pedestrian crossing for EW is on then skips to state 6
						next_state <= S6;

					else --not pressed, continues to next state
						next_state <= S2;

					end if;

		--states 2-7 just continue to the next state
         WHEN S2 =>		
				next_state <= S3;
		
         WHEN S3 =>		
				next_state <= S4;
			
         WHEN S4 =>		
				next_state <= S5;

         WHEN S5 =>		
				next_state <= S6;
				
         WHEN S6 =>		
				next_state <= S7;
				
         WHEN S7 =>		
				next_state <= S8;
					
		WHEN S8 =>
			
			IF (NSrequest ='1' AND EWrequest ='0'  ) then --if pedestrian crossing for NS is on then skips to state 14
				next_state <= S14;

			else --not pressed, continues to next state 
				next_state <= S9;

			end if;
				
				
			WHEN S9 => 
				IF (NSrequest ='1' AND EWrequest ='0'  ) then --if pedestrian crossing for NS is on then skips to state 14
					next_state <= S14;

				else --not pressed, continues to next state 
					next_state <= S10;

				end if;
			
			--states 10-14 just continue to the next state
			WHEN S10 => 
				next_state <= S11;
				
			WHEN S11 => 
				next_state <= S12;
				
			WHEN S12 => 
				next_state <= S13;
				
			WHEN S13 => 
				next_state <= S14; 
				
			WHEN S14 => 
				next_state <= S15;
			
			--state 15 is the last state so it restarts
			WHEN S15 => 
				next_state <= S0;
			
			--precaution state, restarts the states
			WHEN OTHERS =>
				next_state <= S0;

	  END CASE;

 END PROCESS;
 

-- DECODER SECTION PROCESS 

Decoder_Section: PROCESS (blink_sig, current_state) 

BEGIN

	NSREGISTER_CLEAR<= '0';
	EWREGISTER_CLEAR<= '0';
    	
	CASE current_state IS
		
		--sets values for lights, crossing, and hexadecimal number depending on state
        WHEN S0 =>
				
			--states of traffic lgihts ('0' = off, '1' = on)
			--NS, flashing green for states 0-1
			greenNS  <= blink_sig; 
			yellowNS <= '0';
			redNS <= '0'; 
			--EW, red for states 
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1'; 
			
			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0'; 
				
			stateout <= "0000"; --hexadecimal representation of state number for leds
				
         WHEN S1 =>		
			
			--states of traffic lights ('0' = off, '1' = on)
			--NS, flashing green for states 0-1
			greenNS  <= blink_sig; 
			yellowNS <= '0';
			redNS <= '0';
			--EW, red for states 0-7
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';
			
			stateout <= "0001"; --hexadecimal respresntation of state number for leds 
			
         WHEN S2 =>		
			
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, green for states 2-5
			greenNS  <= '1';
			yellowNS <= '0';
			redNS <= '0';
			--EW, red for states 0-7
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '1';
			EW_CROSSINGS <= '0';
		
			stateout <= "0010"; --hexadecimal representation of state number for leds
			
         WHEN S3 =>		
			
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, green for states 2-5
			greenNS  <= '1';
			yellowNS <= '0';
			redNS <= '0';
			--EW, red for states 0-7			
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '1';
			EW_CROSSINGS <= '0';
			
			stateout <= "0011"; --hexadecimal representation of state number for leds
			
         WHEN S4 =>		
		
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, green for states 2-5
			greenNS  <= '1';
			yellowNS <= '0';
			redNS <= '0';
			--EW, red for states 0-7		
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '1';
			EW_CROSSINGS <= '0';
			
			
			stateout <= "0100"; --hexadecimal representation of state number for leds

         WHEN S5 =>		
			 
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, green for states 2-5
			greenNS  <= '1';
			yellowNS <= '0';
			redNS <= '0';
			--EW, red for states 0-7		 
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '1';
			EW_CROSSINGS <= '0';
					
			
			stateout <= "0101"; --hexadecimal representation of state number for leds
			
         WHEN S6 =>		
		
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, yellow for states 6-7
			greenNS  <= '0';
			yellowNS <= '1';
			redNS <= '0';
			--EW, red for states 0-7		
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1';
			
			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';

			--pedestrian crossing for EW jumps to state 6, clears request value 
			NSREGISTER_CLEAR<='1';
			EWREGISTER_CLEAR<= '0';

			stateout <= "0110"; --hexadecimal representation of state number for leds
				
         WHEN S7 =>		
		
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, yellow for states 6-7
			greenNS  <= '0';
			yellowNS <= '1';
			redNS <= '0';
			--EW, red for states 0-7
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '1'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';
		
			stateout <= "0111"; --hexadecimal representation of state number for leds
			
		WHEN S8 =>		
	
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
	 		--EW, blinking green for states 8-9
			greenEW  <= blink_sig;
			yellowEW <= '0';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';
			
			stateout <= "1000"; --hexadecimal representation of state number for leds
			
		WHEN S9 =>		
	
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
			--EW, blinking green for states 8-9
			greenEW  <= blink_sig;
			yellowEW <= '0';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';
	
			stateout <= "1001"; --hexadecimal representation of state number for leds
			
		WHEN S10 =>		
		
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
		 	--EW, green for states 10-13
			greenEW  <= '1';
			yellowEW <= '0';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '1';
	
			stateout <= "1010"; --hexadecimal representation of state number for leds
			
		WHEN S11 =>		

			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
			--EW, green for states 10-13
			greenEW  <= '1';
			yellowEW <= '0';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '1';
		
			stateout <= "1011"; --hexadecimal representation of state number for leds
			
		WHEN S12 =>		
		
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
			--EW, green for states 10-13
			greenEW  <= '1';
			yellowEW <= '0';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '1';
		
			stateout <= "1100"; --hexadecimal representation of state number for leds
			
			
			
		WHEN S13=>		

			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
			--EW, green for states 10-13
			greenEW  <= '1';
			yellowEW <= '0';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '1';
	
			stateout <= "1101"; --hexadecimal representation of state number for leds
			
		WHEN S14 =>		

			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
			--EW, yellow for states 14-15
			greenEW  <= '0';
			yellowEW <= '1';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';

			--pedestrian crossing for NS jumps to state 14, clears request value 
			NSREGISTER_CLEAR<= '0';
			EWREGISTER_CLEAR<= '1';

			stateout <= "1110"; --hexadecimal representation of state number for leds
			
		WHEN S15 =>		
		
			--states of traffic lights ('0' = off, '1' = on), 
			--NS, red for states 8-15
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '1';
	 		--EW, yellow for states 14-15
			greenEW  <= '0';
			yellowEW <= '1';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';
	
			stateout <= "1111"; --hexadecimal representation of state number for leds
		
		--precaution state, sets everything back to 0
         WHEN others =>		
 			
			--states of traffic lights ('0' = off, '1' = on), 
			--NS
			greenNS  <= '0';
			yellowNS <= '0';
			redNS <= '0';
			--ES
			greenEW  <= '0';
			yellowEW <= '0';
			redEW <= '0'; 

			--states for pedestrian crossing ('0' = off, '1' = on)
			NS_CROSSINGS <= '0';
			EW_CROSSINGS <= '0';
	
			
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
