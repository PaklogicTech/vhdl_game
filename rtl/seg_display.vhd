library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seg_display is
    Port (
        i_hex : in STD_LOGIC_VECTOR (3 downto 0);      -- input in hex to display 
        o_display : out STD_LOGIC_VECTOR (6 downto 0) -- output to display on seven_seg
    );
end seg_display;

architecture behavior of seg_display is

begin
    process(i_hex)
    begin
        case i_hex is
            when "0000" => o_display <= "0000001"; -- "0"     
            when "0001" => o_display <= "1001111"; -- "1" 
            when "0010" => o_display <= "0010010"; -- "2" 
            when "0011" => o_display <= "0000110"; -- "3" 
            when "0100" => o_display <= "1001100"; -- "4" 
            when "0101" => o_display <= "0100100"; -- "5" 
            when "0110" => o_display <= "0100000"; -- "6" 
            when "0111" => o_display <= "0001111"; -- "7" 
            when "1000" => o_display <= "0000000"; -- "8"     
            when "1001" => o_display <= "0000100"; -- "9" 
            when others => o_display <= "0000001"; --  0
        end case;
    end process;
end architecture behavior;
