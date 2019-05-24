library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Game is
   Port ( 
			clk_i : in STD_LOGIC;    --The global clock frequency of the board is 100Mhz.
		   cmd:in std_logic_vector (7 downto 0);
		   cmd_in:in std_logic;
			HSYNC_O : out  STD_LOGIC;
		   VSYNC_O : out STD_LOGIC;
		   red : out  STD_LOGIC_VECTOR (2 downto 0);
		   green : out  STD_LOGIC_VECTOR (2 downto 0);
		   blue : out  STD_LOGIC_VECTOR (1 downto 0)
	);
end Game;

architecture Behavioral of Game is

    component VGA_driver is
      Port (clk_i: in std_logic;  -- 50MHz
            reset_i: in std_logic;
            hsync_o: out std_logic;
            vsync_o: out std_logic;
            houtput: out std_logic;
            voutput: out std_logic;
            colum: out std_logic_vector( 9 downto 0);
            row: out std_logic_vector( 9 downto 0)
             );
    end component;
	
	component timer
		Generic( 
			data_width:integer := 25;
			maxValue:integer := 500000
		);
		Port ( clk_i: in STD_LOGIC; 
				 reset_i: in STD_LOGIC;
				 enable_i: in STD_LOGIC;
				 count_o: out STD_LOGIC
		);
	end component;
	
	component ploscad
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
	end component;
	
	component main_ball
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
	end component;
	
	component block_module
		Generic(  
				block_w:integer := 60;
				block_h:integer := 20
		);
		Port ( clk_i : in STD_LOGIC;
            reset_i : in STD_LOGIC;
			   screen_x : in STD_LOGIC_VECTOR (9 downto 0);
				screen_y : in STD_LOGIC_VECTOR (9 downto 0);
				position_x_in: in STD_LOGIC_VECTOR (9 downto 0);
				position_y_in: in STD_LOGIC_VECTOR (9 downto 0);
				trk_i : in STD_LOGIC;
			   red_out : out STD_LOGIC_VECTOR (2 downto 0)
			  );
	end component;
	
	-- vga
	signal hvid: STD_LOGIC;
	signal vvid: STD_LOGIC;
	signal rwc: STD_LOGIC;
	signal colData: STD_LOGIC_VECTOR(9 downto 0);
	signal rowData: STD_LOGIC_VECTOR(9 downto 0);
	signal red_i: STD_LOGIC_VECTOR(2 downto 0);
	signal green_i: STD_LOGIC_VECTOR(2 downto 0);
	signal blue_i: STD_LOGIC_VECTOR(1 downto 0);
	--keyboard
	signal smer_levo: STD_LOGIC;
	signal smer_desno: STD_LOGIC;
	
	--glavni signali
	signal gameONoff: STD_LOGIC := '1';
	signal game_over: STD_LOGIC;
	
	signal ploscad_moving: STD_LOGIC;
	signal ploscad_enable: STD_LOGIC := '1';
	signal ploscad_timer: STD_LOGIC := '1';
	signal ploscad_red: STD_LOGIC_VECTOR(2 downto 0);
	signal ploscad_green: STD_LOGIC_VECTOR(2 downto 0);
	signal ploscad_blue: STD_LOGIC_VECTOR(1 downto 0);
	
	signal ball_moving: STD_LOGIC;
	signal ball_enable: STD_LOGIC := '1';
	signal ball_timer: STD_LOGIC := '1';
	signal rob_in: STD_LOGIC_VECTOR (2 downto 0);
	signal ball_red: STD_LOGIC_VECTOR(2 downto 0);
	signal ball_green: STD_LOGIC_VECTOR(2 downto 0);
	signal ball_blue: STD_LOGIC_VECTOR(1 downto 0);
	
	-- blocks
	signal trk1: STD_LOGIC := '0'; signal trk2: STD_LOGIC := '0';
	signal trk3: STD_LOGIC := '0'; signal trk4: STD_LOGIC := '0';
	signal trk5: STD_LOGIC := '0'; signal trk6: STD_LOGIC := '0';
	signal trk7: STD_LOGIC := '0'; signal trk8: STD_LOGIC := '0';
	signal trk9: STD_LOGIC := '0'; signal trk10: STD_LOGIC := '0';
	signal trk11: STD_LOGIC := '0'; signal trk12: STD_LOGIC := '0';
	signal trk13: STD_LOGIC := '0'; signal trk14: STD_LOGIC := '0';
	signal trk15: STD_LOGIC := '0'; signal trk16: STD_LOGIC := '0';
	signal block_red1: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red2: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red3: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red4: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red5: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red6: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red7: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red8: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red9: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red10: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red11: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red12: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red13: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red14: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red15: STD_LOGIC_VECTOR (2 downto 0);
	signal block_red16: STD_LOGIC_VECTOR (2 downto 0);
    signal reset :  STD_LOGIC;
    signal pause :  STD_lOGIC;
begin
    
    VGA_controller: vga_driver 
        port map(
            clk_i=> clk_i,
            reset_i=>reset,
            hsync_o =>HSYNC_O,
            vsync_o =>VSYNC_O,
            hOutput =>hvid,
            vOutput =>vvid,
            colum   =>colData,
            row     =>rowData
             );	
	
	PLOSCAD_time : timer
	generic map (
		data_width => 25,
		maxValue => 500000
	 )
	port map (
		clk_i => clk_i,
		reset_i => reset,
		enable_i => ploscad_timer,
		count_o => ploscad_moving
	);
	
	BALL_time : timer
	generic map (
		data_width => 25,
		maxValue => 250000 	
	 )
	port map (
		clk_i => clk_i,
		reset_i => reset,
		enable_i => ball_timer,
		count_o => ball_moving
	);
	
	GAMING_PLOSCAD : ploscad
	port map (
		clk_i => clk_i,
		reset_i => reset,
		enable_i => ploscad_enable,
		screen_x => colData,
		screen_y => rowData,
		moving_i => ploscad_moving,
		smer_levo => smer_levo,
	   smer_desno => smer_desno,
		red_out => ploscad_red,
	   green_out => ploscad_green,
		blue_out => ploscad_blue
	);
	
	GAMING_BALL : main_ball
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   enable_i => ball_enable,
	   screen_x => colData,
	   screen_y => rowData,
		moving_i => ball_moving,
		pl_red => ploscad_red,
		trk_in1 => trk1,
		trk_in2 => trk2,
		trk_in3 => trk3,
		trk_in4 => trk4,
		trk_in5 => trk5,
		trk_in6 => trk6,
		trk_in7 => trk7,
		trk_in8 => trk8,
		trk_in9 => trk9,
		trk_in10 => trk10,
		trk_in11 => trk11,
		trk_in12 => trk12,
		trk_in13 => trk13,
		trk_in14 => trk14,
		trk_in15 => trk15,
		trk_in16 => trk16,
		rob => rob_in,
		red_out => ball_red,
		green_out => ball_green,
		blue_out => ball_blue
	);
	
	-------------------------------------------------------
	
	GAMING_BLOCK1: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(50, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk1,
		red_out => block_red1
	);
	
	GAMING_BLOCK2: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(120, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk2,
		red_out => block_red2
	);
	
	GAMING_BLOCK3: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(190, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk3,
		red_out => block_red3
	);
	
	GAMING_BLOCK4: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(260, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk4,
		red_out => block_red4
	);
	
	GAMING_BLOCK5: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(330, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk5,
		red_out => block_red5
	);
	
	GAMING_BLOCK6: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(400, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk6,
		red_out => block_red6
	);
	
	GAMING_BLOCK7: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(470, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk7,
		red_out => block_red7
	);
	
	GAMING_BLOCK8: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(540, 10),
		position_y_in => conv_std_logic_vector(10, 10),
		trk_i => trk8,
		red_out => block_red8
	);
	
	GAMING_BLOCK9: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(50, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk9,
		red_out => block_red9
	);
	
	GAMING_BLOCK10: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(120, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk10,
		red_out => block_red10
	);
	
	GAMING_BLOCK11: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(190, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk11,
		red_out => block_red11
	);
	
	GAMING_BLOCK12: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(260, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk12,
		red_out => block_red12
	);
	
	GAMING_BLOCK13: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(330, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk13,
		red_out => block_red13
	);
	
	GAMING_BLOCK14: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(400, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk14,
		red_out => block_red14
	);
	
	GAMING_BLOCK15: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(470, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk15,
		red_out => block_red15
	);
	
	GAMING_BLOCK16: block_module
	port map (
		clk_i => clk_i,
	   reset_i => reset,
	   screen_x => colData,
	   screen_y => rowData,
		position_x_in => conv_std_logic_vector(540, 10),
		position_y_in => conv_std_logic_vector(35, 10),
		trk_i => trk16,
		red_out => block_red16
	);
	
	-------------------------------------------------------
	reset <= '1' when cmd = 120 else '0';
    pause <= '1' when cmd = 112 else '0';
    
	smer_levo <= '1' when (cmd = 108 and cmd_in = '0') else '0';
	smer_desno <= '1' when (cmd = 114 and cmd_in = '0') else '0';
	rob_in <= "111" when (colData>638 OR colData<2 OR rowData<2) else "000";
	
	gameONoff <= '0' when (game_over = '1' or pause = '1') else '1';
	ploscad_enable <= gameONoff;
	ball_enable <= gameONoff;
	ploscad_timer <= gameONoff;
	ball_timer <= gameONoff;
	
	red <= red_i;
	green <= green_i;
	blue <= blue_i;
	
	-- ball hits block
	process(clk_i)
		begin
		   if(clk_i'event and clk_i = '1') then
				if(reset = '1') then
					trk1 <= '0'; trk6 <= '0'; trk11 <= '0'; trk16 <= '0';
					trk2 <= '0'; trk7 <= '0'; trk12 <= '0';
					trk3 <= '0'; trk8 <= '0'; trk13 <= '0';
					trk4 <= '0'; trk9 <= '0'; trk14 <= '0';
					trk5 <= '0'; trk10 <= '0'; trk15 <= '0';
				end if;
				if(ball_blue > 0 and block_red1 > 0) then
					trk1 <= '1';
				elsif(ball_blue > 0 and block_red2 > 0) then
					trk2 <= '1';
				elsif(ball_blue > 0 and block_red3 > 0) then
					trk3 <= '1';
				elsif(ball_blue > 0 and block_red4 > 0) then
					trk4 <= '1';
				elsif(ball_blue > 0 and block_red5 > 0) then
					trk5 <= '1';
				elsif(ball_blue > 0 and block_red6 > 0) then
					trk6 <= '1';
				elsif(ball_blue > 0 and block_red7 > 0) then
					trk7 <= '1';
				elsif(ball_blue > 0 and block_red8 > 0) then
					trk8 <= '1';
				elsif(ball_blue > 0 and block_red9 > 0) then
					trk9 <= '1';
				elsif(ball_blue > 0 and block_red10 > 0) then
					trk10 <= '1';
				elsif(ball_blue > 0 and block_red11 > 0) then
					trk11 <= '1';	
				elsif(ball_blue > 0 and block_red12 > 0) then
					trk12 <= '1';
				elsif(ball_blue > 0 and block_red13 > 0) then
					trk13 <= '1';
				elsif(ball_blue > 0 and block_red14 > 0) then
					trk14 <= '1';
				elsif(ball_blue > 0 and block_red15 > 0) then
					trk15 <= '1';
				elsif(ball_blue > 0 and block_red16 > 0) then
					trk16 <= '1';		
				end if;
			end if;	
	end process;
	
	-- ball zgresi ploscad
	process(clk_i,ball_blue,rowData)
		begin
		   if(clk_i'event and clk_i = '1') then	
				if(reset = '1') then
					game_over <= '0';
				elsif(ball_blue > 0 and rowData > 480) then
					game_over <= '1';
				end if;
			end if;	
	end process;	
	
	-- izris
	process(clk_i,vvid,hvid,colData,rowData)
		begin
		  if(clk_i'event and clk_i = '1') then	
			if(vvid = '1' and hvid = '1') then
			   --if(smer_desno = '1') then
				--	if(colData = 400 AND rowData = 300) then
						red_i <= ploscad_red or block_red1 or block_red2 or block_red3 or block_red4
									or block_red5 or block_red6 or block_red7 or block_red8 or block_red9 or block_red10 
									or block_red11 or block_red12 or block_red13 or block_red14 or block_red15 or block_red16;
						green_i <= rob_in or block_red1 or block_red2 or block_red3 or block_red4
									or block_red5 or block_red6 or block_red7 or block_red8 or block_red9 or block_red10
									or block_red11 or block_red12 or block_red13 or block_red14 or block_red15 or block_red16;
						blue_i <= ball_blue;
					--else
					--	red <= "000";
					--	green <= "000";
				--		blue <= "11";
				--	end if;
				--end if;		
			else
				red_i <= (others => '0');
				green_i <= (others => '0');
				blue_i <= (others => '0');
			end if;
		end if;	
	end process;

end Behavioral;	