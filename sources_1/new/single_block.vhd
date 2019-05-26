library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity single_block is
    Generic( 
        pos_x: std_logic_vector(9 downto 0);
        pos_y: std_logic_vector(9 downto 0);        
        BLOCK_WIDTH: positive:=25;
        BLOCK_HEIGHT: positive:=20;
        BALL_RADIUS: positive := 5
    );
    Port (  clk_i:      in std_logic;
        rst_i:      in std_logic;
        ball_x:     in std_logic_vector(9 downto 0);
        ball_y:     in std_logic_vector(9 downto 0);
        pixel_x:    in std_logic_vector(9 downto 0);
        pixel_y:    in std_logic_vector(9 downto 0);
        disp:       in std_logic;
        strike:     out std_logic_vector(1 downto 0);
        red_o:      out std_logic_vector(2 downto 0)
    );
end single_block;

architecture Behavioral of single_block is

    type state_type is (show, hide);
    signal be_striked: std_logic_vector(1 downto 0) := "00";
    signal state: state_type:= show;
    signal red: std_logic_vector(2 downto 0);
begin
    strike<= be_striked;
    red_o <= red;
    
    show_proc: process(clk_i) 
    begin
        red<= "000";
        if (disp = '1'and state= show) then
            if (unsigned(pixel_x) > unsigned(pos_x) 
            and unsigned(pixel_x) < (unsigned(pos_x)+ to_unsigned(BLOCK_WIDTH,10)) 
            and unsigned(pixel_y) > unsigned(pos_y) 
            and unsigned(pixel_y) < (unsigned(pos_y)+ to_unsigned(BLOCK_HEIGHT,10)) )then
                red<= "111";
            end if;            
        end if;  
    end process;
    
    strike_proc: process (clk_i,rst_i) is
    begin
        be_striked<= "00";
        if(rst_i ='1')then
            state<= show;
        end if;
            
        if (state= show and disp ='1') then
            if(     unsigned(ball_x) + to_unsigned(BALL_RADIUS,10) > unsigned(pos_x) 
                and unsigned(ball_x) <unsigned(pos_x) + to_unsigned(BLOCK_WIDTH,10) + to_unsigned(BALL_RADIUS,10)
                and unsigned(ball_y) + to_unsigned(BALL_RADIUS,10) > unsigned(pos_y) 
                and unsigned(ball_y) < unsigned(pos_y)+ to_unsigned(BLOCK_HEIGHT,10) +to_unsigned(BALL_RADIUS,10) )then
                
                state <= hide;
                if unsigned(ball_x) < unsigned(pos_X) or unsigned(ball_x) > unsigned(pos_X) + to_unsigned(BLOCK_WIDTH,10) then
                    be_striked <="01";
                else
                    be_striked <="10";
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;