library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_logic is
	port (
		clk     : in  std_logic;
		rst     : in  std_logic;
		en      : in  std_logic;
		i_lfsr  : in  std_logic_vector (3 downto 0);
		i_col   : in  std_logic_vector (3 downto 0);
		o_life  : out std_logic_vector (1 downto 0);
		o_level : out std_logic_vector (3 downto 0);
		o_score : out std_logic_vector (2 downto 0)

	);
end control_logic;
architecture behav of control_logic is
	---------------------------------------------------------------------------------	
	signal o_inc       : std_logic;
	signal o_dec       : std_logic;
	signal o_score_reg : std_logic_vector ( 2 downto 0);
	signal o_level_reg : std_logic_vector (3 downto 0);
	signal o_life_reg  : std_logic_vector (1 downto 0);
---------------------------------------------------------------------------------	
begin
	compare : process (rst, clk, i_col,i_lfsr,en)
	begin
		if (rst = '1') then
			o_inc <= '0';
			o_dec <= '0';
		elsif (rising_edge(clk)) then
			if (en = '1') then
				if (i_lfsr = i_col) then
					o_inc <= '1';
					o_dec <= '1';
				else
					o_inc <= '0';
					o_dec <= '1';

				end if;
			end if;
		end if;
	end process compare;
	score : process (rst, clk)
	begin
		if (rst = '1') then
			o_score_reg <= "000";
			o_level_reg <= "0000";
		elsif (rising_edge(clk)) then
			if (o_score_reg = "101") then
				o_score_reg <= "000";
				o_level_reg <= o_level_reg+1;
			elsif (o_inc = '1' ) then
				o_score_reg <= o_score_reg+1;
			else
				o_score_reg <= o_score_reg;
			end if;
		end if;
	end process score;
	lif : process (rst, clk)
	begin
		if (rst = '1') then
			o_life_reg <= "11";
		elsif (rising_edge(clk)) then
			if (o_dec = '1') then
				o_life_reg <= o_life_reg-1;
			end if;
		end if;
	end process lif;
	o_life  <= o_life_reg;
	o_score <= o_score_reg;
	o_level <= o_level_reg;
end architecture behav;
