library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity paddle_controller is
  Port (clk_i:      in std_logic;
        rst_i:      in std_logic;
        pause_i:    in std_logic;
        pixel_x:    in std_logic_vector(9 downto 0);
        pixel_y:    in std_logic_vector(9 downto 0);
        ball_x:     in std_logic_vector(9 downto 0);
        ball_y:     in std_logic_vector(9 downto 0);
        red_o:      out std_logic_vector(2 downto 0);
        strike:     out std_logic_vector(1 downto 0)                        
         );
end paddle_controller;

architecture Behavioral of paddle_controller is

begin


end Behavioral;
