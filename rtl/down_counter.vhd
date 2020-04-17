library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity down_counter is
	port (
		clk : in std_logic;
		rst : in std_logic;
		en  : in std_logic;
		--	level: in std_logic_vector (1 downto 0);
		o_en       : out std_logic;
		o_down_cnt : out std_logic_vector (3 downto 0)
	);
end down_counter;

architecture behav of down_counter is
	signal count_reg : std_logic_vector (3 downto 0);
begin

	count : process(clk,rst,count_reg)
	begin
		if rst = '1' then
			count_reg <= "1001";
			o_en      <= '0';
		elsif Rising_edge(clk) then
			if (en = '1') then
				if (count_reg = "0000") then
					o_en <= '1';
				else
					count_reg <= count_reg-1;
				end if;
			end if;
		end if;
	end process;
	o_down_cnt <= count_reg;
end architecture behav; 