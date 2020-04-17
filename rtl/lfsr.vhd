library ieee;
use ieee.std_logic_1164.all;
entity lfsr is
  port (
    clk : in std_logic;
    rst : in std_logic;
    en     : in  std_logic;
    o_lsfr : out std_logic_vector (3 downto 0));
end lfsr;
architecture behav of lfsr is
  signal r_lfsr : std_logic_vector (4 downto 1);
begin
  o_lsfr <= r_lfsr(4 downto 1);
  p_lfsr : process (clk,rst)
  begin
    if (rst = '0') then
      r_lfsr <= (others => '1');
    elsif rising_edge(clk) then
      if (en = '1') then
        r_lfsr(4) <= r_lfsr(1);
        r_lfsr(3) <= r_lfsr(4) xor r_lfsr(1);
        r_lfsr(2) <= r_lfsr(3);
        r_lfsr(1) <= r_lfsr(2);

      end if;
    end if;
  end process p_lfsr;
end architecture behav;