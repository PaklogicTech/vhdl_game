library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_game is
	port (
		clk : in std_logic;
		rst: in std_logic;
		en : in std_logic;
		row : in std_logic_vector (3 downto 0);
		col: out std_logic_vector (3 downto 0);
		seg_level: out std_logic_vector (6 downto 0);
		seg_life: out std_logic_vector (6 downto 0);
		seg_score: out std_logic_vector (6 downto 0);
		seg_cnt_dwn: out std_logic_vector (6 downto 0);
		seg_rand_nmb: out std_logic_vector (6 downto 0)
	);
end top_game;	
architecture behav of top_game is

component down_counter is
	port (
		clk : in std_logic;
		rst: in std_logic;
		en: in std_logic;
	--	level: in std_logic_vector (1 downto 0);
		o_en: out std_logic;
		o_down_cnt: out std_logic_vector (3 downto 0)
	);
end component down_counter;

component 
seg_display is
    Port (
        i_hex : in STD_LOGIC_VECTOR (6 downto 0);      -- input in hex to display 
        o_display : out STD_LOGIC_VECTOR (6 downto 0) -- output to display on seven_seg
    );
end component seg_display;
component lfsr is
  port (
    clk : in std_logic;
    rst : in std_logic;
    --  syn_rst : in  std_logic;
    --  i_lfsr       : in  std_logic_vector (3 downto 0);
    en     : in  std_logic;
    o_lsfr : out std_logic_vector (3 downto 0));
end component lfsr;
component ring_counter is
	Port (
		clk     : in  std_logic;                    -- input clock from fpga 
		rst     : in  std_logic;                    -- active high reset
		en     : in  std_logic;                    -- enable signal
		o_count : out STD_LOGIC_VECTOR (3 downto 0) -- output ring counter value
	);
end component ring_counter;
component control_logic is
	port (
		clk     : in  std_logic;
		rst     : in  std_logic;
		en 		: in std_logic;
		i_lfsr  : in  std_logic_vector (3 downto 0);
		i_col   : in  std_logic_vector (3 downto 0);
		o_life  : out std_logic_vector (1 downto 0);
		o_level : out std_logic_vector (3 downto 0);
		o_score : out std_logic_vector (2 downto 0)

	);
end component control_logic;
------------------------------------------------------------------------------------------
signal o_down_cnt: std_logic_vector(3 downto 0);
signal o_en: std_logic;
signal o_lsfr: std_logic_vector(3 downto 0);
signal o_level:std_logic_vector(3 downto 0);
signal o_life : std_logic_vector (1 downto 0);
signal o_score: std_logic_vector (2 downto 0);
signal o_life_cat: std_logic_vector(3 downto 0);
signal o_score_cat: std_logic_vector(3 downto 0);
----------------------------------------------------------------------------------------
begin
	cat : process( o_life,o_score )
	begin
	o_life_cat  <= "00" & o_life;
	o_score_cat <= '0' & o_score;	
	end process ; -- cat
	

	strt_cntr :entity work.down_counter
		port map (
			clk        => clk,
			rst        => rst,
			en 		=> en,	
			o_en       => o_en,
			o_down_cnt => o_down_cnt
		);

	lfsr_inst : entity work.lfsr
		port map (
			clk    => clk,
			rst    => rst,
			en     => o_en,
			o_lsfr => o_lsfr
		);

	ring_counter_inst : entity work.ring_counter
		port map (
			clk     => clk,
			rst     => rst,
			en 		=> o_en,
			o_count => col
		);

	dwn_cntr : entity work.seg_display
		port map (
			i_hex     => o_down_cnt,
			o_display => seg_cnt_dwn
		);

	rand_nmbr : entity work.seg_display
		port map (
			i_hex     => o_lsfr,
			o_display => seg_rand_nmb
		);

	cu : entity work.control_logic
		port map (
			clk     => clk,
			rst     => rst,
				en 	=> o_en,
			i_lfsr  => o_lsfr,
			i_col   => row,
			o_life  => o_life,
			o_level => o_level,
			o_score => o_score
		);



	level : entity work.seg_display
		port map (
			i_hex     => o_level,
			o_display => seg_level 
		);

	score : entity work.seg_display
		port map (
			i_hex     => o_score_cat,
			o_display => seg_score
		);
	life : entity work.seg_display
		port map (
			i_hex     => o_life_cat,
			o_display => seg_life
		);


	
end architecture behav;

