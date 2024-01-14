-- message on FPGA Test Display
-- alphanumeric version
-- bontango 05.2022
--
-- v 1.0


LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

    entity boot_message is        
        port(
				-- input (display data)
			   display			: in  string (1 to 4);
				-- input (check pin)
				check_pin	: integer range 0 to 100;
				--output (display control)
			  seg1   : out  std_logic_vector(6 downto 0);
			  seg2   : out  std_logic_vector(6 downto 0);
			  seg3   : out  std_logic_vector(6 downto 0);
			  seg4   : out  std_logic_vector(6 downto 0)	  
            );
    end boot_message;
    ---------------------------------------------------
    architecture Behavioral of boot_message is
		type RomGottFA1 is array (32 to 103) of std_logic_vector (6 downto 0);
			constant GTB_Char : RomGottFA1 := ( 
	"1111111", -- (space) 
	"1111001", -- ! 	
	"1011101", -- " 
	"0000001", -- # 
	"0010010", -- $ 
	"0101101", -- % 
	"0111001", -- & 
	"1011111", -- ' 	
	"1010110", -- ( 
	"1110100", -- ) 
	"1011110", -- * 
	"0001111", -- + 
	"1101111", -- , 
	"0111111", -- - 
	"1111111", -- . 
	"0101101", -- / 
	"1000000", -- 0 
	"1111001", -- 1 
	"0100100", -- 2 
	"0110000", -- 3 
	"0011001", -- 4 
	"0010010", -- 5 
	"0000010", -- 6 
	"1111000", -- 7 
	"0000000", -- 8 
	"0010000", -- 9 
	"1110110", -- : 
	"1110010", -- ; 
	"0011110", -- < 
	"0110111", -- = 
	"0111100", -- > 
	"0101100", -- ? 
	"0100000", -- @ 
	"0001000", -- A 
	"0000011", -- B 
	"1000110", -- C 
	"0100001", -- D 
	"0000110", -- E 
	"0001110", -- F 
	"1000010", -- G 
	"0001001", -- H 
	"1001111", -- I 
	"1100001", -- J 
	"0001010", -- K 
	"1000111", -- L 
	"1101010", -- M 
	"1001000", -- N 
	"1000000", -- O 
	"0001100", -- P 
	"0010100", -- Q 
	"1001100", -- R 
	"0010010", -- S 
	"0000111", -- T 
	"1000001", -- U 
	"1000001", -- V 
	"1010101", -- W 
	"0001001", -- X 
	"0010001", -- Y 
	"0100100", -- Z 	
	"1111111", -- 91
	"1111111", -- 92
	"1111111", -- 93
	"1111111", -- 94
	"1111111", -- 95
	"1111111", -- 96
	"1111110", -- a (segment)
	"1111101", -- b
	"1111011", -- c
	"1110111", -- d
	"1101111", -- e
	"1011111", -- f
	"0111111" -- g
	);		  
begin	
  boot_message: process (display, check_pin)
    begin
	  if ( check_pin = 0) then
			seg1 <= GTB_Char( character'pos(display( 1) ));
			seg2 <= GTB_Char( character'pos(display( 2) ));
			seg3 <= GTB_Char( character'pos(display( 3) ));
			seg4 <= GTB_Char( character'pos(display( 4) ));
		elsif 	( check_pin = 45) then
			seg1 <= "1111101"; 
			seg2 <= "1111111";
			seg3 <= "1111111";
			seg4 <= "1111111";		
		elsif 	( check_pin = 43) then
			seg1 <= "1111011"; 
			seg2 <= "1111111";
			seg3 <= "1111111";
			seg4 <= "1111111";		
		elsif 	( check_pin = 41) then
			seg1 <= "1101111"; 
			seg2 <= "1111111";
			seg3 <= "1111111";
			seg4 <= "1111111";					
		elsif 	( check_pin = 74) then
			seg1 <= "1111111"; 
			seg2 <= "1111111";
			seg3 <= "1111111";
			seg4 <= "1111011";			
		elsif 	( check_pin = 72) then
			seg1 <= "1111111"; 
			seg2 <= "1111111";
			seg3 <= "1111111";
			seg4 <= "1110111";					
		elsif 	( check_pin = 70) then
			seg1 <= "1111111"; 
			seg2 <= "1111111";
			seg3 <= "1111111";
			seg4 <= "1011111";								
		elsif 	( check_pin = 67) then
			seg1 <= "1111111"; 
			seg2 <= "1111111";
			seg3 <= "1111101";
			seg4 <= "1111111";								
		elsif 	( check_pin = 64) then
			seg1 <= "1111111"; 
			seg2 <= "1111111";
			seg3 <= "1111011";
			seg4 <= "1111111";								
		elsif 	( check_pin = 60) then
			seg1 <= "1111111"; 
			seg2 <= "1111111";
			seg3 <= "1101111";
			seg4 <= "1111111";								
		elsif 	( check_pin = 58) then
			seg1 <= "1111111"; 
			seg2 <= "1111110";
			seg3 <= "1111111";
			seg4 <= "1111111";								
		elsif 	( check_pin = 55) then
			seg1 <= "1111111"; 
			seg2 <= "0111111";
			seg3 <= "1111111";
			seg4 <= "1111111";								
		elsif 	( check_pin = 52) then
			seg1 <= "1111111"; 
			seg2 <= "1110111";
			seg3 <= "1111111";
			seg4 <= "1111111";								
		elsif 	( check_pin = 48) then
			seg1 <= "1111111"; 
			seg2 <= "1011111";
			seg3 <= "1111111";
			seg4 <= "1111111";		
		else
			seg1 <= "1111111";
			seg2 <= "1111111";
			seg3 <= "1111111";
			seg4 <= "1111111";
		end if;
		end process;
  end Behavioral;	 	