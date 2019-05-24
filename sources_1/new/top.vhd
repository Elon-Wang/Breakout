library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity top is
    port(
        clk,rst: in std_logic;
        bt_signal: in std_logic;
        idle_light: out std_logic;
        output : out std_logic_vector (7 downto 0);
        hsync: out std_logic;
        vsync: out std_logic;
        red: out std_logic_vector(2 downto 0);
        green : out std_logic_vector(2 downto 0);
        blue: out std_logic_vector(1 downto 0));
end top;

architecture Behavioral of top is
    component uart_receiver is
    generic(clk_ratio:integer);
    port(
        clk,rst: in std_logic;
        rx: in std_logic;
        rx_flag: out std_logic;
        pout: out std_logic_vector (7 downto 0));
    end component;
    
    component Game is
       Port ( 
                clk_i : in STD_LOGIC;
               cmd:in std_logic_vector;
               cmd_in:in std_logic;
                HSYNC_O : out  STD_LOGIC;
               VSYNC_O : out STD_LOGIC;
               red : out  STD_LOGIC_VECTOR (2 downto 0);
               green : out  STD_LOGIC_VECTOR (2 downto 0);
               blue : out  STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;
    
    component clk_wiz_0 is
      Port ( 
        clk_out1 : out STD_LOGIC;
        reset : in STD_LOGIC;
        locked : out STD_LOGIC;
        clk_in1 : in STD_LOGIC
      );  
    end component;
    
     signal cmd: std_logic_vector(7 downto 0);
     signal cmd_in: std_logic;
     signal clk_50M: std_logic;
begin
    frequency_divider: clk_wiz_0 port map(clk_in1 => clk, reset=>rst , clk_out1 => clk_50M);
    game0: Game port map(clk_i=> clk_50M ,cmd=>cmd, cmd_in => cmd_in , HSYNC_O=> hsync,VSYNC_O => vsync,red => red,blue => blue,green=> green);
    controller: uart_receiver generic map(clk_ratio => 651) port map(clk => clk ,rst =>rst,rx => bt_signal,rx_flag=> cmd_in ,pout => cmd);
    output <= cmd;
    idle_light <= not cmd_in;
end Behavioral;