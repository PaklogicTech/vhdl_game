library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ring_counter is
	Port (
		clk     : in  STD_LOGIC;                    -- input clock from fpga 
		rst     : in  STD_LOGIC;                    -- active high reset
		en      : in  STD_LOGIC;                    -- enable signal
		o_count : out STD_LOGIC_VECTOR (3 downto 0) -- output ring counter value
	);
end ring_counter;

architecture Behavioral of ring_counter is
	signal count : std_logic_vector(3 downto 0) := "0000";
begin
	process(clk,rst)
	begin
		if rst = '1' then
			count <= "0001";
		elsif Rising_edge(clk) then
			if (en = '1') then
				count(1) <= count(0);
				count(2) <= count(1);
				count(3) <= count(2);
				count(0) <= count(3);
			end if;
		end if;
	end process;
	o_count <= count;
end Behavioral;
