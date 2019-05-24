library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity baud is
    generic(b_temp:integer:=651);
    port(clk:in std_logic;
          bclk:out std_logic);
end baud;
architecture behavior of baud is
begin
    process(clk)
    variable cnt:integer range 0 to b_temp;
    begin
        if clk'event and clk='1' then
            if cnt=b_temp then cnt:=0;bclk<='1';
            else cnt:=cnt+1;bclk<='0';
            end if;
        end if;
    end process;
end behavior;