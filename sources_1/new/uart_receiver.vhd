library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity uart_receiver is
    generic(clk_ratio:integer:=651);
    port(
        clk,rst: in std_logic;
        rx: in std_logic;
        rx_flag: out std_logic;
        pout: out std_logic_vector (7 downto 0));
end uart_receiver;

architecture Behavioral of uart_receiver is
    type state_type is (idle,start,data,stop);
    signal state_reg, state_next: state_type;
    signal s_reg, s_next: std_logic_vector (3 downto 0);
    signal n_reg, n_next: std_logic_vector (2 downto 0);
    signal b_reg, b_next: std_logic_vector(7 downto 0);
    signal bclk: std_logic;
begin  

    process(clk)
    variable cnt:integer range 0 to clk_ratio;
    begin
    if clk'event and clk='1' then
        if cnt=clk_ratio then 
            cnt:=0;
            bclk<='1';
        else 
            cnt:=cnt+1;
            bclk<='0';
        end if;
    end if;
    end process;
      
    --FSMD state &data registers
    process (clk,rst) is 
    begin
        if (rst ='1') then
            state_reg<= idle;
            s_reg <= (others => '0');
            n_reg <= (others => '0');
            b_reg <= (others => '0');
        elsif(clk'event and clk = '1') then
            state_reg<= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;             
        end if;
    end process;
    
    --next_state logic &data path functional units
    process(bclk,s_reg,n_reg,b_reg,state_reg) is
    begin
        s_next <=  s_reg;
        n_next <=  n_reg;
        b_next <=  b_reg;
        if (bclk'event and bclk = '1') then
            case state_reg is
                when idle=>
                    if rx= '0' then
                        state_next <= start;
                    else 
                        state_next <= idle;
                    end if;     
                    rx_flag <='0';               
                when start =>
                    if rx = '0' then
                        if s_reg = 7 then
                            state_next <= data;
                            s_next <= (others =>'0');
                        else
                            s_next <= s_reg +1;
                            state_next <= start;
                        end if;
                    else
                        state_next <= idle;
                    end if;
                when data =>
                    if s_reg = 15 then
                    b_next <=  rx &  b_reg (7 downto 1);
                        if n_reg =7 then
                            state_next <= stop;
                            n_next <= (others =>'0'); 
                        else
                            state_next <= data;
                            n_next <= n_reg + 1;                            
                        end if;
                        s_next <= (others =>'0');
                    else
                        state_next <= data;
                        s_next <= s_reg +1;
                    end if;
                when stop =>
                        if s_reg =15 then
                            state_next <= idle;
                            s_next <= (others => '0');
                        else 
                            state_next <= stop;
                            s_next <= s_reg +1;
                        end if;
                        pout<= b_reg;
                        rx_flag <= '1';
            end case;
        end if;
    end process;   
end Behavioral;
