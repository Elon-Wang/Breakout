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

entity timer is
	 Generic( 
			data_width:integer := 25;
			maxVrednost:integer := 250000
		);
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
			  count_o : out  STD_LOGIC
			 );
end timer;

architecture Behavioral of timer is

signal count:std_logic_vector(data_width - 1 downto 0);
signal enable:std_logic;

begin

	count_o <= enable;
	
	process(clk_i)
		begin
			if(clk_i'event and clk_i = '1') then
					if(reset_i = '1') then
						count <= (others => '0');
						enable <= '0';
					end if;
					if(count = (maxVrednost-1)) then
						count <= (others => '0');
						enable <= '1';
					else
						count <= count + 1;	
						enable <= '0';
					end if;
		     end if;
	end process;

end Behavioral;
