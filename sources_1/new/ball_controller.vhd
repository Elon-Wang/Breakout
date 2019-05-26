library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity ball_controller is
    Generic(
        screen_w: positive:=640;
        screen_h: positive:=480;
        BALL_RADIUS: positive := 5        
    );
  Port (clk_i:      in std_logic;
        rst_i:      in std_logic;
        pause_i:    in std_logic;
        pixel_x:    in std_logic_vector(9 downto 0);
        pixel_y:    in std_logic_vector(9 downto 0);
        strike:     in std_logic_vector(1 downto 0);
        ball_x:     out std_logic_vector(9 downto 0);
        ball_y:     out std_logic_vector(9 downto 0);
        blue_o:     out std_logic_vector(1 downto 0);
        game_Over:  out std_logic
         );
end ball_controller;

architecture Behavioral of ball_controller is
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
    signal movEnable:std_logic;
    signal blue: std_logic_vector(1 downto 0);
    signal pos_x,pos_y : std_logic_vector(9 downto 0);
    signal dir_x: std_logic:='0';  --'0' means left and '1' stands for right.
    signal dir_y: std_logic:='1';  --'0' means upward, '1' stands for downward
    signal gameOver :std_logic :='0';
begin
    blue_o <= blue;
    ball_x<=pos_x;
    ball_y <= pos_y;
    game_Over <= gameOver;
    
    frequency_divider:timer
    generic map (
        data_width => 25,
        maxValue => 300000
     )
    port map (
        clk_i => clk_i,
        reset_i => rst_i,
        enable_i=> pause_i,
        count_o => movEnable
    );
    
    show_proc: process(clk_i) 
    begin
        blue<= "00";
        if      unsigned(pixel_x) + to_unsigned(BALL_RADIUS,10)> unsigned(pos_x) 
            and unsigned(pixel_x) < unsigned(pos_x) + to_unsigned(BALL_RADIUS,10) 
            and unsigned(pixel_y) + to_unsigned(BALL_RADIUS,10) > unsigned(pos_y) 
            and unsigned(pixel_y) < unsigned(pos_y) + to_unsigned(BALL_RADIUS,10) then
            blue<= "11";
        end if;            
    end process; 
    
    move_and_change_dirc_proc:process(strike,rst_i,movEnable) is
    begin
        if(movEnable = '1') then
            if(dir_y ='0') then pos_y <= pos_y -1;
            else    pos_y <= pos_y + 1;
            end if;
            if(dir_x ='0') then pos_x <= pos_x - 1;
            else    pos_x <= pos_x + 1;
            end if;
        end if;    
        if(rst_i = '1') then
            pos_x <=conv_std_logic_vector(360, 10);
            pos_y <=conv_std_logic_vector(220, 10);
            dir_X<='0'; dir_y<= '1';
            gameOver<= '0';
        end if; 
        if(dir_x= '1' and unsigned(pos_X)+ to_unsigned(BALL_RADIUS,10) > to_unsigned(screen_w,10) ) then
            dir_x <= '0';
        end if;
        if(dir_x= '0' and unsigned(pos_X) - to_unsigned(BALL_RADIUS,10) <= 0 ) then
            dir_x <= '1';
        end if;
        if(dir_y= '1' and unsigned(pos_y) > to_unsigned(screen_h,10) ) then
            gameOver<= '1';
        end if;        
        if(dir_y= '0' and unsigned(pos_y) - to_unsigned(BALL_RADIUS,10) <= 0 ) then
            dir_y <= '1';
        end if;
        if strike = "10" then
            dir_y <= not dir_y;
        end if;
        if strike = "01" then
            dir_x <= not dir_x;
        end if;                           
    end process;
        
end Behavioral;
