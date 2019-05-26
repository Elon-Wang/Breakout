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

component hsync
		Port (  clk_i : in  STD_LOGIC;
				  reset_i : in  STD_LOGIC;
				  hsync_o : out  STD_LOGIC;
				  rowclk_o : out  STD_LOGIC;
				  hvidon_o : out  STD_LOGIC;
				  col_o : out  STD_LOGIC_VECTOR (9 downto 0)
		);
	end component;	

	component vsync
		Port (  clk_i : in  STD_LOGIC;
				  reset_i : in  STD_LOGIC;
				  rowclk_i : in  STD_LOGIC;
				  vsync_o : out  STD_LOGIC;
				  vvidon_o : out  STD_LOGIC;
				  row_o : out  STD_LOGIC_VECTOR (9 downto 0)
		);
	end component;
--    component VGA_driver is
--      Port (clk_i: in std_logic;  -- 50MHz
--            reset_i: in std_logic;
--            hsync_o: out std_logic;
--            vsync_o: out std_logic;
--            houtput: out std_logic;
--            voutput: out std_logic;
--            colum: out std_logic_vector( 9 downto 0);
--            row: out std_logic_vector( 9 downto 0)
--             );
--    end component;
	
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

    component paddle_controller is
        Generic(
            screen_w: positive:=640;
            screen_h: positive:=480;
            paddle_w: positive:= 80;
            paddle_h: positive:=28;
            BALL_RADIUS: positive := 5        
            );
      Port (clk_i:      in std_logic;
            rst_i:      in std_logic;
            pause_i:    in std_logic;
            pixel_x:    in std_logic_vector(9 downto 0);
            pixel_y:    in std_logic_vector(9 downto 0);
            ball_x:     in std_logic_vector(9 downto 0);
            ball_y:     in std_logic_vector(9 downto 0);
            disp:       in std_logic;
            cmd:        in std_logic_vector (1 downto 0);
            red_o:      out std_logic_vector(2 downto 0);
            strike:     out std_logic_vector(1 downto 0)                        
             );
    end component;
	
	component ball_controller is
        Generic(
            screen_w: positive:=640;
            screen_h: positive:=480;
            BALL_RADIUS: positive := 5        
        );
      Port (clk_i:      in std_logic;
            rst_i:      in std_logic;
            pause_i:    in std_logic;
            pixel_x:    in std_logic_vector(9 downto 0);
            pixel_y:    in std_logic_vector(9 downto 0);
            strike:     in std_logic_vector(1 downto 0);
            ball_x:     out std_logic_vector(9 downto 0);
            ball_y:     out std_logic_vector(9 downto 0);
            blue_o:     out std_logic_vector(1 downto 0);
            game_Over:  out std_logic
             );
    end component;
	
	component single_block is
        Generic( 
            pos_x: std_logic_vector(9 downto 0);
            pos_y: std_logic_vector(9 downto 0);        
            BLOCK_WIDTH: positive:=25;
            BLOCK_HEIGHT: positive:=440;
            BALL_RADIUS: positive := 5
        );
        Port (  clk_i:      in std_logic;
            rst_i:      in std_logic;
            ball_x:     in std_logic_vector(9 downto 0);
            ball_y:     in std_logic_vector(9 downto 0);
            pixel_x:    in std_logic_vector(9 downto 0);
            pixel_y:    in std_logic_vector(9 downto 0);
            disp:       in std_logic;
            strike:     out std_logic_vector(1 downto 0);
            red_o:      out std_logic_vector(2 downto 0)
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
	
	--ball
	signal ball_x,ball_y: std_logic_vector(9 downto 0);
	signal ball_strike: std_logic_vector(1 downto 0);
	signal ball_blue: std_logic_vector(1 downto 0);
	
	--paddle
	signal paddle1_controller: std_logic_vector(1 downto 0);
	signal paddle1_disp: std_logic;
	signal paddle1_red: std_logic_vector(2 downto 0);
	signal paddle1_strike :std_logic_vector(1 downto 0);
	
	--block
--	signal block1_disp: std_logic;
	signal block1_strike: std_logic_vector(1 downto 0);
	signal block1_red : std_logic_vector(2 downto 0);
	
	--game controller
	signal gameONoff: STD_LOGIC;
	signal game_over: STD_LOGIC;
    signal reset :  STD_LOGIC;
    signal pause :  STD_lOGIC;
begin
    
--    VGA_controller: vga_driver 
--        port map(
--            clk_i=> clk_i,
--            reset_i=>reset,
--            hsync_o =>HSYNC_O,
--            vsync_o =>VSYNC_O,
--            hOutput =>hvid,
--            vOutput =>vvid,
--            colum   =>colData,
--            row     =>rowData
--             );	
	Hsy : hsync
port map
(
    clk_i => clk_i,
    reset_i => reset,
    hsync_o => HSYNC_O,
    rowclk_o => rwc,
    hvidon_o => hvid,
    col_o => colData
);

Vsy : vsync
port map
(
    clk_i => clk_i,
    reset_i => reset,
    rowclk_i => rwc,
    vsync_o => VSYNC_O,
    vvidon_o => vvid,
    row_o => rowData
);
	
   paddle1: paddle_controller
       Port  map(clk_i => clk_i,
                 rst_i => reset,
                 pause_i=>gameOnOff,
                 pixel_x =>colData,
                 pixel_y =>rowData,
                 ball_x =>ball_x,
                 ball_y => ball_y,
                 disp   =>paddle1_disp,
                 cmd    =>paddle1_controller,
                 red_o  =>paddle1_red,
                 strike =>paddle1_strike
                 );
	
	balll: ball_controller 
        Port map(
            clk_i=>clk_i,
            rst_i=>reset,
            pause_i=>gameOnOff,
            pixel_x=>colData,
            pixel_y=>rowData,
            strike=>ball_strike,
            ball_x=>ball_x,
            ball_y=>ball_y,
            blue_o=>ball_blue,
            game_Over=> game_over
            );
        
	-------------------------------------------------------
--creat blocks	
    block1: single_block 
    generic map( 
        pos_x => conv_std_logic_vector(120,10),
        pos_y => conv_std_logic_vector(20,10) )
    Port map (  clk_i => clk_i,
        rst_i => reset,
        ball_x=>ball_x,
        ball_y=>ball_y,
        pixel_x=>colData,
        pixel_y=>rowData,
        disp=> '1',
        strike => block1_strike,
        red_o => block1_red
    );
	
	-------------------------------------------------------
	reset <= '1' when cmd = 120 else '0';
    pause <= '1' when cmd = 112 else '0';
    gameONoff <= '0' when (game_over = '1' or pause = '1') else '1';
    
    paddle1_controller <= "10" when (cmd = 108 and cmd_in = '0')else
                          "01" when (cmd = 114 and cmd_in = '0')else
                           "00";
	ball_strike <= paddle1_strike;
	
	red <= red_i;
	green <= green_i;
	blue <= blue_i;
	
--	-- ball zgresi ploscad
--	process(clk_i,ball_blue,rowData)
--		begin
--		   if(clk_i'event and clk_i = '1') then	
--				if(reset = '1') then
--					game_over <= '0';
--				elsif(ball_blue > 0 and rowData > 480) then
--					game_over <= '1';
--				end if;
--			end if;	
--	end process;	
	
	-- VGA color output
	process(clk_i,vvid,hvid,colData,rowData)
		begin
		  if(clk_i'event and clk_i = '1') then	
			if(vvid = '1' and hvid = '1') then
				red_i <= paddle1_red or block1_red;-- or block1_red;
				green_i <= "000";
				blue_i <= ball_blue;	
			else
				red_i <= (others => '0');
				green_i <= (others => '0');
				blue_i <= (others => '0');
			end if;
		end if;	
	end process;

end Behavioral;	