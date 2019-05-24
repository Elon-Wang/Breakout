library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ploscad is
	Generic(  
			screen_w:integer := 640; 
			screen_h:integer := 480;
			ploscad_w:integer := 80;
			ploscad_h:integer := 28
	);
   Port ( clk_i : in  STD_LOGIC;
          reset_i : in  STD_LOGIC;
			 enable_i : in  STD_LOGIC;
			 screen_x : in STD_LOGIC_VECTOR (9 downto 0);
			 screen_y : in STD_LOGIC_VECTOR (9 downto 0);
			 moving_i : in  STD_LOGIC;
			 -- keyboard
          smer_levo : in  STD_LOGIC;
          smer_desno : in  STD_LOGIC;
			 -- barve
			 red_out : out STD_LOGIC_VECTOR (2 downto 0);
			 green_out : out STD_LOGIC_VECTOR (2 downto 0);
			 blue_out : out STD_LOGIC_VECTOR (1 downto 0)
	);
end ploscad;

architecture Behavioral of ploscad is

component RAM32x80 
    Port ( clk_i 		: in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (4 downto 0);
           data_o 	: out  STD_LOGIC_VECTOR (0 to 79));
end component;
----------------------------------------------------------

signal RAM_addrOUT_i: STD_LOGIC_VECTOR (4 downto 0);
signal RAM_data_o: STD_LOGIC_VECTOR (0 to 79);

signal position_x_in: STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(280, 10);
signal position_y_in: STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(450, 10);
signal RAM_index_in: STD_LOGIC_VECTOR (9 downto 0);

signal red_in: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal green_in: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal blue_in: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

signal b :std_logic_vector (9 downto 0);
begin

   Ploscad: RAM32x80
   port map (
		clk_i => clk_i,
	   addrOUT_i => RAM_addrOUT_i,
	   data_o => RAM_data_o
	);
-------------------------------------

	red_out <= red_in;
	green_out <= green_in;
	blue_out <= blue_in;

	DRAW: process(clk_i)
	begin
		if clk_i'event and clk_i = '1' then
			RAM_addrOUT_i <= conv_std_logic_vector(0, 5);
			red_in <= conv_std_logic_vector(0, 3);
			green_in <= conv_std_logic_vector(0, 3);
			blue_in <= conv_std_logic_vector(0, 2);
		
			if(screen_x >= position_x_in and screen_x <= (position_x_in + ploscad_w)) then
				if(screen_y >= position_y_in and screen_y <= (position_y_in + ploscad_h)) then
				    b<= screen_y - position_y_in;
					RAM_addrOUT_i <= b(4 downto 0);
					RAM_index_in <= screen_x - position_x_in;
			
					if(RAM_data_o(conv_integer(RAM_index_in)) = '1') then
						red_in <= red_in or conv_std_logic_vector(7, 3);
					end if;
				end if;
			end if;
		end if;
	end process;
	
	MOVE: process(clk_i)
	begin
		if clk_i'event and clk_i = '1' then
			if(reset_i = '1') then
				position_x_in <= conv_std_logic_vector(280, 10);
				position_y_in <= conv_std_logic_vector(450, 10);
			end if;
			if(enable_i = '1') then
				if(moving_i = '1') then
					if(smer_levo = '1') then
						if(position_x_in > 2) then
							position_x_in <= position_x_in - 1;
						end if;
					elsif(smer_desno = '1') then
						if((position_x_in + ploscad_w) < (screen_w-2)) then
							position_x_in <= position_x_in + 1;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;	
	
end Behavioral;