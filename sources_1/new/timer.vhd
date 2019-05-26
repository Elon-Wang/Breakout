library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timer is
	 Generic( 
			data_width:integer := 25;
			maxValue:integer := 250000
		);
    Port ( clk_i :   in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           enable_i: in  std_logic;
		   count_o : out  STD_LOGIC
			 );
end timer;

architecture Behavioral of timer is

signal count:std_logic_vector(data_width - 1 downto 0);
signal output:std_logic;

begin

	count_o <= output;
	
	process(clk_i)
		begin
			if(clk_i'event and clk_i = '1') then
				if(enable_i = '1') then	
					if(reset_i = '1') then
						count <= (others => '0');
						output <= '0';
					end if;
					if(count = (maxValue-1)) then
						count <= (others => '0');
						output <= '1';
					else
						count <= count + 1;	
						output <= '0';
					end if;
				else
				    output<='0';
				end if;	
		     end if;
	end process;

end Behavioral;
