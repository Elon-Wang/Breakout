library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity block_module is
		Generic(  
				block_w:integer := 60;
				block_h:integer := 20
		);
		Port ( clk_i : in  STD_LOGIC;
            reset_i : in  STD_LOGIC;
			   screen_x : in STD_LOGIC_VECTOR (9 downto 0);
				screen_y : in STD_LOGIC_VECTOR (9 downto 0);
				position_x_in: in STD_LOGIC_VECTOR (9 downto 0);
				position_y_in: in STD_LOGIC_VECTOR (9 downto 0); 
				trk_i: in STD_LOGIC;
			   red_out : out STD_LOGIC_VECTOR (2 downto 0)
			  );
end block_module;

architecture Behavioral of block_module is

component ram_block 
    Port ( clk_i 		: in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (4 downto 0);
           data_o 	: out  STD_LOGIC_VECTOR (0 to 59));
end component;

signal RAM_addrOUT_i: STD_LOGIC_VECTOR (4 downto 0);
signal RAM_data_o: STD_LOGIC_VECTOR (0 to 59);
signal RAM_index_in: STD_LOGIC_VECTOR (9 downto 0);
signal red_in: STD_LOGIC_VECTOR (2 downto 0);
signal b: std_logic_vector(9 downto 0);
begin

	ram_32x40: ram_block
   port map (
		clk_i => clk_i,
	   addrOUT_i => RAM_addrOUT_i,
	   data_o => RAM_data_o
	);
-------------------------------------

	red_out <= red_in;

	DRAW: process(clk_i)
	begin
		if clk_i'event and clk_i = '1' then
			RAM_addrOUT_i <= conv_std_logic_vector(0, 5);
			red_in <= conv_std_logic_vector(0, 3);
		
		   if(trk_i = '0') then	
				if(screen_x >= position_x_in and screen_x <= (position_x_in + block_w)) then
					if(screen_y >= position_y_in and screen_y <= (position_y_in + block_h)) then
						b<= screen_y - position_y_in;
                        RAM_addrOUT_i <= b(4 downto 0);
						RAM_index_in <= screen_x - position_x_in;
						if(RAM_data_o(conv_integer(RAM_index_in)) = '1') then
							red_in <= "111";
						end if;
					end if;
				end if;
			elsif(trk_i = '1') then
				if(screen_x >= position_x_in and screen_x <= (position_x_in + block_w)) then
					if(screen_y >= position_y_in and screen_y <= (position_y_in + block_h)) then
						b<= screen_y - position_y_in;
                        RAM_addrOUT_i <= b(4 downto 0);
						RAM_index_in <= screen_x - position_x_in;
						if(RAM_data_o(conv_integer(RAM_index_in)) = '1') then
							red_in <= "000";
						end if;
					end if;
				end if;
			end if;
			
		end if;
	end process;

end Behavioral;