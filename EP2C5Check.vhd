-- EP2C5 Check
-- Ralf Thelen 'bontango' 05.2022
-- www.lisy.dev
--
-- version 0.4


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity EP2C5Check is
	port(		
	   -- the FPGA board
		clk_50	: in std_logic; 	-- PIN17
		reset_l  : in std_logic; 	-- PIN144 --goes Low on reset(push)
		LED_0 	: out STD_LOGIC;	-- PIN3					
		LED_1 	: out STD_LOGIC;  -- PIN7
		LED_2 	: out STD_LOGIC;	-- PIN9
		
		-- 7 Segment
		Dis_7Seg1		: out std_logic_vector(6 downto 0);
		Dis_7Seg2		: out std_logic_vector(6 downto 0);
		Dis_7Seg3		: out std_logic_vector(6 downto 0);
		Dis_7Seg4		: out std_logic_vector(6 downto 0);
		
		-- other pins, all input		
		EP2C5PINS		: in std_logic_vector(1 to 49)
		);		
end;

architecture rtl of EP2C5Check is 


--internal signals via logic
signal reset_h		: 	std_logic;
signal reset_l_stable	:	std_logic; 
signal cpu_clk		: std_logic; -- 895 kHz CPU clock

signal	display:	string(1 to 4);

signal check_pin: integer range 0 to 100;

begin

-------------------------------

reset_h <= (not reset_l_stable); 

-- LEDs
LED_0 <= '0';
LED_1 <= '0';
LED_2 <= '0';



CHECKIT: entity work.check_pins
port map(
	clk => cpu_clk,
	board_sw => reset_h,
	
	display => display,
	
	check_pin => check_pin,
		
	EP2C5PINS => EP2C5PINS
	);



BM: entity work.boot_message
port map(
	-- input (display data)
	display	=>  display,
	check_pin => check_pin,
	-- output
	seg1(6) => Dis_7Seg1(2),
	seg1(5) => Dis_7Seg1(6),
	seg1(4) => Dis_7Seg1(5),
	seg1(3) => Dis_7Seg1(4),
	seg1(2) => Dis_7Seg1(3),
	seg1(1) => Dis_7Seg1(1),
	seg1(0) => Dis_7Seg1(0),
	seg2(6) => Dis_7Seg2(2),
	seg2(5) => Dis_7Seg2(6),
	seg2(4) => Dis_7Seg2(5),
	seg2(3) => Dis_7Seg2(4),
	seg2(2) => Dis_7Seg2(3),
	seg2(1) => Dis_7Seg2(1),
	seg2(0) => Dis_7Seg2(0),
	seg3(6) => Dis_7Seg3(2),
	seg3(5) => Dis_7Seg3(6),
	seg3(4) => Dis_7Seg3(5),
	seg3(3) => Dis_7Seg3(4),
	seg3(2) => Dis_7Seg3(3),
	seg3(1) => Dis_7Seg3(1),
	seg3(0) => Dis_7Seg3(0),
	seg4(6) => Dis_7Seg4(2),
	seg4(5) => Dis_7Seg4(6),
	seg4(4) => Dis_7Seg4(5),
	seg4(3) => Dis_7Seg4(4),
	seg4(2) => Dis_7Seg4(3),
	seg4(1) => Dis_7Seg4(1),
	seg4(0) => Dis_7Seg4(0)	
	);

-- cpu clock 892Khz
clock_gen: entity work.cpu_clk_gen 
port map(   
	clk_in => clk_50,
	cpu_clk_out	=> cpu_clk
);

	 
META1: entity work.Cross_Slow_To_Fast_Clock
port map(
   i_D => reset_l,
	o_Q => reset_l_stable,
   i_Fast_Clk => clk_50
	);

	
end rtl;


		