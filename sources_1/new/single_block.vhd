library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity single_block is
    Generic( 
        pos_x: std_logic_vector(9 downto 0);
        pox_y: std_logic_vector(9 downto 0);        
        SCREEN_WIDTH: positive:= 640;
        
        BLOCK_HEIGHT: positive:=440;
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
    constant BLOCK_WIDTH: positive:=25;
    type state_type is (show, hide);
    signal state: state_type:= show;
    signal red: std_logic_vector(2 downto 0);
begin
    red_o <= red;
    show_proc: process(clk_i) 
    begin
        red<= "000";
        if (disp = '1'and state= show) then
--            if (unsigned(pixel_x) > unsigned(pos_x) and unsigned(pixel_x) < (unsigned(pos_x)+ to_unsigned(BLOCK_WIDTH)) )then
                
--            end if;            
        end if;  
    end process;
--    state<= show when (unsigned(pixel_x) > unsigned(pos_x) and unsigned(pixel_x) < (unsigned(pos_x)+ to_unsigned(BLOCK_WIDTH))
--                else hide ; --????

end Behavioral;
