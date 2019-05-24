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

entity main_ball is
	Generic(  
			ploscad_w:integer := 80;
			ploscad_h:integer := 28;
			ball_w:integer := 40;
			ball_h:integer := 32
	);
   Port ( clk_i : in  STD_LOGIC;
          reset_i : in  STD_LOGIC;
			 enable_i : in  STD_LOGIC;
			 screen_x : in STD_LOGIC_VECTOR (9 downto 0);
			 screen_y : in STD_LOGIC_VECTOR (9 downto 0);
			 moving_i : in STD_LOGIC;
			 -- ploscad
			 pl_red : in STD_LOGIC_VECTOR (2 downto 0);
			 -- block
			 trk_in1 : in STD_LOGIC;
			 trk_in2 : in STD_LOGIC;
			 trk_in3 : in STD_LOGIC;
			 trk_in4 : in STD_LOGIC;
			 trk_in5 : in STD_LOGIC;
			 trk_in6 : in STD_LOGIC;
			 trk_in7 : in STD_LOGIC;
			 trk_in8 : in STD_LOGIC;
			 trk_in9 : in STD_LOGIC;
			 trk_in10 : in STD_LOGIC;
			 trk_in11 : in STD_LOGIC;
			 trk_in12 : in STD_LOGIC;
			 trk_in13 : in STD_LOGIC;
			 trk_in14 : in STD_LOGIC;
			 trk_in15 : in STD_LOGIC;
			 trk_in16 : in STD_LOGIC;			 
			 -- rob
			 rob : in STD_LOGIC_VECTOR (2 downto 0);
			 -- barve
			 red_out : out STD_LOGIC_VECTOR (2 downto 0);
			 green_out : out STD_LOGIC_VECTOR (2 downto 0);
			 blue_out : out STD_LOGIC_VECTOR (1 downto 0)
	);
end main_ball;

architecture Behavioral of main_ball is

component ram_ball
    Port ( clk_i 		: in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (4 downto 0);
           data_o 	: out  STD_LOGIC_VECTOR (0 to 39));
end component;

signal RAM_addrOUT_i: STD_LOGIC_VECTOR (4 downto 0);
signal RAM_data_o: STD_LOGIC_VECTOR (0 to 39);

signal position_x_in: STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(360, 10);
signal position_y_in: STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(220, 10);
signal RAM_index_in: STD_LOGIC_VECTOR (9 downto 0);

signal goRight: STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(2, 10);
signal goLeft:  STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(0, 10);
signal goUp:    STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(0, 10);
signal goDown:  STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(1, 10);

signal robGD: STD_LOGIC_VECTOR (9 downto 0);
signal robLD: STD_LOGIC_VECTOR (9 downto 0);
signal dotikRoba: STD_LOGIC;

signal red_in: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal green_in: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal blue_in: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

signal trk1: STD_LOGIC := '1'; signal trk2: STD_LOGIC := '1';
signal trk3: STD_LOGIC := '1'; signal trk4: STD_LOGIC := '1';
signal trk5: STD_LOGIC := '1'; signal trk6: STD_LOGIC := '1';
signal trk7: STD_LOGIC := '1'; signal trk8: STD_LOGIC := '1';
signal trk9: STD_LOGIC := '1'; signal trk10: STD_LOGIC := '1';
signal trk11: STD_LOGIC := '1'; signal trk12: STD_LOGIC := '1';
signal trk13: STD_LOGIC := '1'; signal trk14: STD_LOGIC := '1';
signal trk15: STD_LOGIC := '1'; signal trk16: STD_LOGIC := '1';

signal b :std_logic_vector (9 downto 0);

begin

	BALL : ram_ball
	port map
	(
		clk_i => clk_i,
		addrOUT_i => RAM_addrOUT_i,
		data_o => RAM_data_o
	);
-----------------------------------

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
		
			if(screen_x >= position_x_in and screen_x <= (position_x_in + ball_w)) then
				if(screen_y >= position_y_in and screen_y <= (position_y_in + ball_h)) then
					b<= screen_y - position_y_in;
                    RAM_addrOUT_i <= b(4 downto 0);
					RAM_index_in <= screen_x - position_x_in;
			
					if(RAM_data_o(conv_integer(RAM_index_in)) = '1') then
						blue_in <= blue_in or conv_std_logic_vector(3, 2);
					end if;
				end if;
			end if;
		end if;
	end process;
	
	BALL_LOGIC: process(clk_i)
	begin
		if clk_i'event and clk_i = '1' then
			if(reset_i = '1') then
				goUp <= conv_std_logic_vector(0, 10);
				goDown <= conv_std_logic_vector(1, 10);
				goLeft <= conv_std_logic_vector(0, 10);
				goRight <= conv_std_logic_vector(2, 10);
				position_x_in <= conv_std_logic_vector(360, 10);
				position_y_in <= conv_std_logic_vector(220, 10);
				dotikRoba <= '0';
				trk1 <= '1'; trk6 <= '1'; trk11 <= '1';
				trk2 <= '1'; trk7 <= '1'; trk12 <= '1';
				trk3 <= '1'; trk8 <= '1'; trk13 <= '1';
				trk4 <= '1'; trk9 <= '1'; trk14 <= '1';
				trk5 <= '1'; trk10 <= '1'; trk15 <= '1'; trk16 <= '1';
			end if;
		
			if(enable_i = '1') then
				dotikRoba <= '0';
				
				if(moving_i = '1') then
					position_x_in <= position_x_in + goRight - goLeft;
					position_y_in <= position_y_in + goDown - goUp;
				end if;
				
				if(blue_in > 0) then
					if(rob > 0 or pl_red > 0) then
						robLD <= screen_x;
						robGD <= screen_y;
						dotikRoba <= '1';
					else 
						dotikRoba <= '0';
					end if;
				end if;	
				
				if(dotikRoba = '1' or position_x_in > 1000 or position_y_in > 1000) then
					if(robLD < 2 or position_x_in > 1000) then
							goRight <= conv_std_logic_vector(2, 10);
							goLeft <= conv_std_logic_vector(0, 10);
						elsif(robLD > 638) then
							goLeft <= conv_std_logic_vector(2, 10);
							goRight <= conv_std_logic_vector(0, 10);
					end if;
					if(robGD < 2 or position_y_in > 1000) then
							goDown <= conv_std_logic_vector(1, 10);
							goUp <= conv_std_logic_vector(0, 10);
						elsif(robGD > 450) then
							goUp <= conv_std_logic_vector(1, 10);
							goDown <= conv_std_logic_vector(0, 10);
					end if;
				end if;
				
				-- ob trku z blokom
				if(trk1 = trk_in1) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk1 <= '0';
					dotikRoba <= '0';
				elsif(trk2 = trk_in2) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk2 <= '0';
					dotikRoba <= '0';	
				elsif(trk3 = trk_in3) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk3 <= '0';
					dotikRoba <= '0';	
				elsif(trk4 = trk_in4) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk4 <= '0';
					dotikRoba <= '0';
				elsif(trk5 = trk_in5) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk5 <= '0';
					dotikRoba <= '0';
				elsif(trk6 = trk_in6) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk6 <= '0';
					dotikRoba <= '0';
				elsif(trk7 = trk_in7) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk7 <= '0';
					dotikRoba <= '0';
				elsif(trk8 = trk_in8) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk8 <= '0';
					dotikRoba <= '0';
				elsif(trk9 = trk_in9) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk9 <= '0';
					dotikRoba <= '0';
				elsif(trk10 = trk_in10) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk10 <= '0';
					dotikRoba <= '0';
				elsif(trk11 = trk_in11) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk11 <= '0';
					dotikRoba <= '0';
				elsif(trk12 = trk_in12) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk12 <= '0';
					dotikRoba <= '0';
				elsif(trk13 = trk_in13) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk13 <= '0';
					dotikRoba <= '0';
				elsif(trk14 = trk_in14) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk14 <= '0';
					dotikRoba <= '0';	
				end if;
				elsif(trk15 = trk_in15) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk15 <= '0';
					dotikRoba <= '0';
				elsif(trk16 = trk_in16) then
					if(goDown = 0 and goRight = 0) then
						goRight <= conv_std_logic_vector(0, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(2, 10);
						goUp <= conv_std_logic_vector(0, 10);
					else 
						goRight <= conv_std_logic_vector(2, 10);
						goDown <= conv_std_logic_vector(1, 10);
						goLeft <= conv_std_logic_vector(0, 10);
						goUp <= conv_std_logic_vector(0, 10);
					end if;
					trk16 <= '0';
					dotikRoba <= '0';
			end if;
		
		end if;
	end process;	

end Behavioral;