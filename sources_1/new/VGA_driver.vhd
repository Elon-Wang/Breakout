library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity VGA_driver is
  Port (clk_i: in std_logic;  -- 50MHz
        reset_i: in std_logic;
        hsync_o: out std_logic;
        vsync_o: out std_logic;
        houtput: out std_logic;
        voutput: out std_logic;
        colum: out std_logic_vector( 9 downto 0);
        row: out std_logic_vector( 9 downto 0)
         );
end VGA_driver;

architecture Behavioral of VGA_driver is
    component counter
        Generic ( 
                data_width:integer:= 10;
                value:integer:= 800
        );
        Port ( 
                clk_i : in  STD_LOGIC;
                reset_i : in  STD_LOGIC;
                count_o : out  STD_LOGIC_VECTOR(data_width-1 downto 0)
        );
    end component;
    
    signal clk_25Mhz: std_logic;
    signal counter1: std_logic_vector(1 downto 0);
    signal hcounter: std_logic_vector(9 downto 0);
    signal vcounter: std_logic_vector(9 downto 0);
    signal Row_cnt: std_logic;
begin

    H_total : counter
    generic map (
        data_width => 10,
        value => 800 )
    port map (
        clk_i => clk_25Mhz,
        reset_i => reset_i,
        count_o => hcounter
    );
    
    V_total: counter
    generic map(
        data_width=> 10,
        value=> 525)
    port map(
        clk_i=> Row_cnt,   --TODO: to varify the correctness;
        reset_i=>reset_i,
        count_o=> vcounter
        );
    
    frequency_divider:process(clk_i)
    begin
        if clk_i'event and clk_i = '1' then
            if(reset_i = '1') then
                counter1 <= (others => '0');
                clk_25Mhz <= '0';
            end if;
            if(counter1 = 1) then
                counter1 <= (others => '0');
                clk_25Mhz <= '1';
            else
                counter1 <= counter1 + 1;    
                clk_25Mhz <= '0';
            end if;
        end if;
    end process;

    process(hcounter)
		begin
			--rowclk
			if( hcounter = 799 ) then
				row_cnt <= '1';
			else
				row_cnt <= '0';
			end if;
	end process;
			
	process(hcounter)
		begin
			if( hcounter < 640 ) then
				houtput <= '1';
			else
				houtput <= '0';
			end if;
	end process;		
			
	process(hcounter)
		begin		
			--hsync
			if( hcounter > 655 AND hcounter < 752 ) then
				hsync_o <= '0';
			else
				hsync_o <= '1';
			end if;
	end process;

    row <= vCounter;
	
	process(vCounter)
		begin		
			if( vCounter < 480 ) then
				vOutput <= '1';
			else
				vOutput <= '0';
			end if;
	end process;
	
	process(vcounter)
		begin
			if ( vCounter > 489 AND vCounter < 492 ) then
				vsync_o <= '0';
			else
				vsync_o <= '1';
			end if;			
	end process;

end Behavioral;
