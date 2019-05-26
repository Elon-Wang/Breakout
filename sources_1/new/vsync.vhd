----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:07:46 02/14/2017 
-- Design Name: 
-- Module Name:    vsync - Behavioral 
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

entity vsync is
    Port ( 
			clk_i : in  STD_LOGIC;
			reset_i : in  STD_LOGIC;
			rowclk_i : in  STD_LOGIC;
			vsync_o : out  STD_LOGIC;
			vvidon_o : out  STD_LOGIC;
			row_o : out  STD_LOGIC_VECTOR (9 downto 0)
	  );
end vsync;

architecture Behavioral of vsync is

	component counter
		Generic ( 
				data_width:integer := 10;
				value:integer := 525
		);
		Port (
				clk_i : in  STD_LOGIC;
				reset_i : in  STD_LOGIC;
				enable_i : in  STD_LOGIC;
				count_o : out  STD_LOGIC_VECTOR (data_width-1 downto 0)
		);
	end component;
	
	signal counter2:STD_LOGIC_VECTOR(9 downto 0);

begin

	stevec : counter
	generic map
	(
		data_width => 10,
		value => 521
	)
	port map
	(
		clk_i => clk_i,
		reset_i => reset_i,
		enable_i => rowclk_i,
		count_o => counter2
	);
	
	row_o <= counter2;
	
	process(counter2)
		begin			
			--vvidon
			if( counter2 < 480 ) then
				vvidon_o <= '1';
			else
				vvidon_o <= '0';
			end if;
	end process;
	
	process(counter2)
		begin
			--vsync
			if ( counter2 > 489 AND counter2 < 492 ) then
				vsync_o <= '0';
			else
				vsync_o <= '1';
			end if;			
	end process;

end Behavioral;