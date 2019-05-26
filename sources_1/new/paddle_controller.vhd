library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.numeric_std.all;

entity paddle_controller is
    Generic(
        screen_w: positive:=640;
        screen_h: positive:=480;
        paddle_w: positive:= 80;
        paddle_h: positive:=28;
        BALL_RADIUS: positive := 5        
        );
  Port (clk_i:      in std_logic;
        rst_i:      in std_logic;
        pause_i:    in std_logic;
        pixel_x:    in std_logic_vector(9 downto 0);
        pixel_y:    in std_logic_vector(9 downto 0);
        ball_x:     in std_logic_vector(9 downto 0);
        ball_y:     in std_logic_vector(9 downto 0);
        disp:       in std_logic;
        cmd:        in std_logic_vector (1 downto 0);
        red_o:      out std_logic_vector(2 downto 0);
        strike:     out std_logic_vector(1 downto 0)                        
         );
end paddle_controller;

architecture Behavioral of paddle_controller is
    component timer is
	   Generic( 
			data_width:integer := 25;
			maxValue:integer := 250000
		);
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           enable_i: in  std_logic;
			  count_o : out  STD_LOGIC
	   		 );
    end component;
    signal movEnable: std_logic;
    signal paddle_x: std_logic_vector(9 downto 0) := conv_std_logic_vector(280,10);
    signal paddle_y: std_logic_vector(9 downto 0) := conv_std_logic_vector(400,10);
    signal red: std_logic_vector(2 downto 0);
begin

    frequency_divider:timer
	generic map (
		data_width => 25,
		maxValue => 200000
	 )
	port map (
		clk_i => clk_i,
		reset_i => rst_i,
		enable_i => pause_i,
		count_o => movEnable
	);
    
    show_proc: process(clk_i) 
    begin
        red<= "000";
        if (disp = '1') then
            if (unsigned(pixel_x) > unsigned(paddle_x) 
                and unsigned(pixel_x) < (unsigned(paddle_x)+ to_unsigned(paddle_w,10)) 
                and unsigned(pixel_y) > unsigned(paddle_y) 
                and unsigned(pixel_y) < (unsigned(paddle_y)+ to_unsigned(paddle_h,10)) )then
                red<= "111";
            end if;            
        end if;  
    end process;    
    
    
    mov_proc:process(movEnable,rst_i) is
    begin 
        if ( rst_i = '1' )then
            paddle_x <= conv_std_logic_vector(280,10);
            paddle_y <= conv_std_logic_vector(280,10);
        end if;
        if movEnable='1' then
            if cmd = "01" then
                paddle_x <= paddle_x+1;
            elsif cmd="10" then
                paddle_x <= paddle_x-1;                
            else
                paddle_x <= paddle_x;
            end if;
        end if;
    end process;
    
    strike_proc:process(clk_i) is
    begin
        strike<="00";
        if (disp ='1') then
            if (    unsigned(ball_x) + to_unsigned(BALL_RADIUS,10) > unsigned(paddle_x) 
                and unsigned(ball_x) < (unsigned(paddle_x)+ to_unsigned(paddle_w,10)) + to_unsigned(BALL_RADIUS,10)
                and unsigned(ball_y) + to_unsigned(BALL_RADIUS,10)> unsigned(paddle_y) 
                and unsigned(ball_y) < (unsigned(paddle_y)+ to_unsigned(paddle_h,10)) - to_unsigned(BALL_RADIUS,10) )then
                strike<= "10" ;
            end if; 
        end if;
    end process;
end Behavioral;
