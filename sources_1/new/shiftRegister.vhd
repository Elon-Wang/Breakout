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

entity shiftRegister is
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           input : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (8 downto 0));
end shiftRegister;

architecture Behavioral of shiftRegister is

	signal reg_output:STD_LOGIC_VECTOR(8 downto 0);

begin

	data_out <= reg_output;

	process(clk_i)
		begin
			if clk_i'event and clk_i = '1' then
				if(reset_i = '1') then
					reg_output <= (others => '0');
				else
					if(enable = '1') then
						reg_output(7 downto 0) <= reg_output(8 downto 1);
						reg_output(8) <= input;
					else
						reg_output <= reg_output;
					end if;
				end if;
			end if;
	end process;

end Behavioral;
