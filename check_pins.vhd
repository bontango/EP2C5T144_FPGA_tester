--*****************************************************************************
--
--  Title   : check IOs on EP2C5 FPGA
--
--  File    : check_pins.vhd
--
--  Author  : bontango
--
-- v0.9
-- without internal pull-ups
--
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity check_pins is
  port( 
		  clk     : in  std_logic;        
		  		  
		  board_sw   : in  std_logic; -- switch on EP2C5 board
		  		  
		  display:	out string(1 to 4);		
		
		  check_pin:	out integer range 0 to 100;
		  
		  EP2C5PINS		: in std_logic_vector(1 to 49) -- pins to check
		  
        );
end check_pins;

architecture fsm of check_pins is

type CHPINUSED is array (1 to 49) of integer range 0 to 100;
			constant CHPINS_INT : CHPINUSED := ( 
			45,45,45,
			43,43,43,43,
			41,41,41,41,
			74,74,74,74,
			72,72,72,72,
			70,70,70,70,
			67,67,67,67,
			64,64,64,
			60,60,60,
			58,58,58,58,
			55,55,55,55,
			52,52,52,52,
			48,48,48,48
			);
			
type CHPINS is array (1 to 49) of string (1 to 4);
			constant CHPINS_STR : CHPINS := ( 
		"   4", 			"   8", 			"  18",	--PIN_45
		"  21",		"  22",		"  24", 		"  25", --PIN_43
		"  28", 		"  30", 		"  31", 		"  32", --PIN_41
		"  86", 		"  87", 		"  88",		"  89", --PIN_74
		"  90",		"  91",		"  92", 		"  93", --PIN_72
		"  94", 		"  96", 		"  97", 		"  99", --PIN_70
		" 100", 		" 101", 		" 103", 		" 104", --PIN_67
 		" 112", 		" 113", 		" 114", --PIN_64
		" 115", 		" 118", 		" 119", --PIN_60
		" 120", 		" 121", 		" 122", 		" 125", --PIN_58
		" 126", 		" 129", 		" 132", 		" 133", --PIN_55
		" 134", 		" 135", 		" 136", 		" 137", --PIN_52
		" 139", 		" 141", 		" 142", 		" 143"  --PIN_48
			);

      --   FSM states
  type state_t is ( st_start, st_start0, st_start1, st_start2,st_start3,st_start4,st_start5,st_start6,
							st_done, st_wait_start, st_wait_start_2, st_wait_start_3, st_wait_sw, st_wait_low,
							st_wait_high, st_wait_restart, st_wait_restart_sw,
							st_check_low, st_low_error, st_check_low_end, st_check_low_prepare,
							st_set_high, st_check_high, st_high_error, st_check_high_end  
	);
  signal state : state_t := st_start;

  signal pin_no : integer range 0 to 50 := 0;
  signal error_cnt : integer range 0 to 120 := 0;
  signal wait_cnt : integer range 0 to 50000000;
  
  constant WAIT_TIME : integer := 5000;
  constant SHOW_SEG_TIME : integer := 15000;
  constant WAIT_START_TIME : integer := 40000;
  constant PREPARE_TIME : integer := 200;
	
begin  --  fsm 
  
  fsm_proc : process ( clk, board_sw)
  begin  --  process fsm_proc 
		if rising_edge( clk) then  -- Synchronous FSM
		   	 case state is
			    ---- Start show space
				 when st_start =>
					display <= "LISY"; 
					check_pin <= 0;
					pin_no <= 1;
					error_cnt <= 0;
					wait_cnt <= 0;										
					state <= st_wait_start;

				 ---- delay at start
				 when st_wait_start =>				   
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > WAIT_START_TIME ) then 
						wait_cnt <= 0;
						state <= st_start0;
						display <= "aaaa"; 
					end if;						
									 
				 when st_start0 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > SHOW_SEG_TIME ) then 
						wait_cnt <= 0;
						display <= "bbbb"; 
						state <= st_start1;
					end if;											
				 when st_start1 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > SHOW_SEG_TIME ) then 
						wait_cnt <= 0;
						display <= "cccc"; 
						state <= st_start2;
					end if;											
				 when st_start2 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > SHOW_SEG_TIME ) then 
						wait_cnt <= 0;
						display <= "dddd"; 
						state <= st_start3;
					end if;											
				 when st_start3 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > SHOW_SEG_TIME ) then 
						wait_cnt <= 0;
						display <= "eeee"; 
						state <= st_start4;
					end if;											
				 when st_start4 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > SHOW_SEG_TIME ) then 
						wait_cnt <= 0;
						display <= "ffff"; 
						state <= st_start5;
					end if;											
				 when st_start5 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > SHOW_SEG_TIME ) then 
						wait_cnt <= 0;
						display <= "gggg"; 
						state <= st_start6;
					end if;											
				 when st_start6 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > SHOW_SEG_TIME ) then 
						wait_cnt <= 0;
						display <= "8888"; 
						state <= st_wait_sw;
					end if;											
					
			    ---- wait for button to start test
				 when st_wait_sw =>
					if ( board_sw = '1' ) then 												
						state <= st_wait_start_3;
					end if;	
					
				 ---- delay at start two
				 when st_wait_start_3 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > WAIT_TIME ) then -- 0,5 seconds
						wait_cnt <= 0;
						state <= st_check_low_prepare;						
					end if;						
					
				 ---- State check low prepare
				 when st_check_low_prepare =>	
					check_pin <= CHPINS_INT(pin_no);
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > PREPARE_TIME ) then 
						wait_cnt <= 0;
						state <= st_check_low;						
					end if;						
				 				 
				 ---- State check low
				 when st_check_low =>	
					if ( EP2C5PINS(pin_no) = '1' ) then
						check_pin <= 0; -- display chars
						error_cnt <= error_cnt + 1;						
						display <= "L" & CHPINS_STR(pin_no)(2 to 4);						
						state <= st_low_error;
					else
						state <= st_check_low_end; --state OK next pin
					end if;

				 ---- State low error, show error pin until switch pressed
				 when st_low_error =>			
					if ( board_sw = '1' ) then 			
						display <= "    "; -- this will set all checkpins to low
						state <= st_wait_low;
					end if;					 														
					
				 when st_wait_low =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > WAIT_TIME ) then -- 0,5 seconds
						wait_cnt <= 0;
						state <= st_check_low_end;
					end if;						

				---- check if all low done
				 when st_check_low_end =>					
					if (pin_no < 49) then
						pin_no <= pin_no +1;					
						state <= st_check_low_prepare; --next round
					else
						state <= st_set_high; --done low check, set high
					end if;

			    ---- Start show "    "
				 when st_set_high =>
					check_pin <= 0; -- display chars
					display <= "    "; -- this will set all checkpins to high
					pin_no <= 1;					
					wait_cnt <= 0;										
					state <= st_wait_start_2;

				 ---- delay at start high check
				 when st_wait_start_2 =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > WAIT_TIME ) then -- 0,5 seconds
						wait_cnt <= 0;
						state <= st_check_high;
					end if;						

				 ---- State check high
				 when st_check_high =>			
					if ( EP2C5PINS(pin_no) = '0' ) then
						error_cnt <= error_cnt + 1;						
						display <= "H" & CHPINS_STR(pin_no)(2 to 4);
						state <= st_high_error;
					else
						state <= st_check_high_end; --state OK next pin
					end if;

				 ---- State high error, show error pin until switch pressed
				 when st_high_error =>			
					if ( board_sw = '1' ) then 			
						display <= "    "; -- this will set all checkpins to high
						state <= st_wait_high;
					end if;					 														
					
				 when st_wait_high =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > WAIT_TIME ) then -- 0,5 seconds
						wait_cnt <= 0;
						state <= st_check_high_end;
					end if;						

				---- check if all high done
				 when st_check_high_end =>					
					if (pin_no < 49) then
						pin_no <= pin_no +1;					
						state <= st_check_high; --next round
					else
						state <= st_done; --done
					end if;
					
				---- all done
				 when st_done =>							
					if ( error_cnt > 0) then
						display <= " ERR";
					else
						display <= "GOOD";
					end if;
					state <= st_wait_restart; 

				 when st_wait_restart =>
					wait_cnt <= wait_cnt +1;
					if ( wait_cnt > WAIT_TIME ) then -- 0,5 seconds
						wait_cnt <= 0;
						state <= st_wait_restart_sw;
					end if;						

				 when st_wait_restart_sw =>		
					if ( board_sw = '1' ) then 												
						state <= st_start;
					end if;					 
					
							
			end case;  --  state
		end if; -- rising_edge(clk)
  end process fsm_proc;
    
end fsm;
		