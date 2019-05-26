----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:11 01/30/2017 
-- Design Name: 
-- Module Name:    hsync - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hsync is
    Port ( 
			clk_i : in  STD_LOGIC;
			reset_i : in  STD_LOGIC;
			hsync_o : out  STD_LOGIC;
			rowclk_o : out  STD_LOGIC;
			hvidon_o : out  STD_LOGIC;
			col_o : out  STD_LOGIC_VECTOR (9 downto 0)
	);
end hsync;

architecture Behavioral of hsync is

	component PSzaCounter
		Generic ( 
				data_width:integer:= 2; 
				value:integer:= 2			 
		);
		Port (
				clk_i: in STD_LOGIC; 
				reset_i: in STD_LOGIC;
				enable_o: out STD_LOGIC
		);
	end component;
	
	component counter
		Generic ( 
				data_width:integer:= 10;
				value:integer:= 800
		);
		Port ( 
				clk_i : in  STD_LOGIC;
				reset_i : in  STD_LOGIC;
				enable_i : in  STD_LOGIC;
				count_o : out  STD_LOGIC_VECTOR(data_width-1 downto 0)
		);
	end component;
	
	signal counter1: STD_LOGIC_VECTOR (9 downto 0);
	signal rwc : STD_LOGIC := '0';
	signal enableSignal: STD_LOGIC := '0';

begin

	prescaler : PSzaCounter
	generic map (
		data_width => 2,
		value => 2 -- (25MHz)
	)
	port map (
		clk_i => clk_i,
		reset_i => reset_i,
		enable_o => enableSignal
	);
	
	stevec : counter
	generic map
	(
		data_width => 10,
		value => 800
	)
	port map
	(
		clk_i => clk_i,
		reset_i => reset_i,
		enable_i => enableSignal,
		count_o => counter1
	);

	col_o <= counter1;
	rowclk_o <= rwc;
	
	process(counter1,enableSignal)
		begin
			--rowclk
			if( counter1 = 799 and enableSignal = '1') then
				rwc <= '1';
			else
				rwc <= '0';
			end if;
	end process;
			
	process(counter1)
		begin
			--hvidon
			if( counter1 < 640 ) then
				hvidon_o <= '1';
			else
				hvidon_o <= '0';
			end if;
	end process;		
			
	process(counter1)
		begin		
			--hsync
			if( counter1 > 655 AND counter1 < 752 ) then
				hsync_o <= '0';
			else
				hsync_o <= '1';
			end if;
	end process;
	
end Behavioral;