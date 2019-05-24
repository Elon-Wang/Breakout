library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ball_controller is
  Port (clk_i:      in std_logic;
        rst_i:      in std_logic;
        pause_i:    in std_logic;
        pixel_x:    in std_logic_vector(9 downto 0);
        pixel_y:    in std_logic_vector(9 downto 0);
        strike:     in std_logic_vector(1 downto 0);
        ball_x:     out std_logic_vector(9 downto 0);
        ball_y:     out std_logic_vector(9 downto 0);
        blue_o:     out std_logic_vector(1 downto 0)
         );
end ball_controller;

architecture Behavioral of ball_controller is

begin


end Behavioral;
