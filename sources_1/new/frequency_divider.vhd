library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity frequency_divider is
    Port (clk: in std_logic;
          rst: in std_logic;
          clk_low: out std_logic
          );
end frequency_divider;

architecture Behavioral of frequency_divider is
    signal clk16_next, clk16_reg: std_logic_vector (5 downto 0);
    constant DVSR: integer := 3;--651 for real board; -- this constant is relative to baud rate and your clk frequency; TODO: should be constimize;
begin
    process(clk,rst) is
begin 
    if rst='1' then
        clk16_reg <= (others =>'0');
    elsif(clk'event and clk='1') then
        clk16_reg <= clk16_next;
    end if;
end process;

    clk16_next <= (others => '0') when clk16_reg = (DVSR-1)  
                                else clk16_reg +1;         
    clk_low <= '1' when clk16_reg = 0 
                   else '0';

end Behavioral;
