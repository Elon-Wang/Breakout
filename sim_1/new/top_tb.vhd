library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
end top_tb;

architecture Behavioral of top_tb is
    component top is
    port(
        clk,rst: in std_logic;
        bt_signal: in std_logic;
        idle_light: out std_logic;
        output : out std_logic_vector (7 downto 0));
    end component;
    signal clk,rst:  std_logic;
    signal btSig: std_logic;
    signal idle_light: std_logic;
    signal output: std_logic_vector(7 downto 0);
begin
    UUT: top port map(clk=> clk, rst=> rst, bt_signal =>btSig, idle_light=> idle_light, output=> output);
    
    clk_proc: process is 
    constant PERIOD:time := 300ps;
    begin
        clk <= '1'; wait for PERIOD/2;
        clk <= '0'; wait for PERIOD/2;
    end process;
    
    bt_signal_proc: process is
    constant PERIOD:time := 300ps;
    begin
        btSig <= '1'; wait for 850ps;
        
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 160*PERIOD;
        
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 160*PERIOD;        
        
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 160*PERIOD;
        
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 160*PERIOD;
        
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;        
        btSig <= '1'; wait for 160*PERIOD;
        
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '1'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '0'; wait for 48*PERIOD;
        btSig <= '1'; wait for 160*PERIOD;
    end process; 
    
    rst_proc: process is
    begin
        rst <= '1'; wait for 550ps;
        rst <= '0'; wait;
    end process;
end Behavioral;
