library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX8 is
    generic (d_w: integer:= 4);
    Port ( I0,I1,I2,I3,I4,I5,I6,I7: in std_logic_vector(d_w - 1 downto 0);
    Sel: in std_logic_vector (2 downto 0);
    Y: out std_logic_vector(d_w - 1 downto 0)
    );
end MUX8;

architecture beh of MUX8 is

begin
mux8_proc: process (I0,I1,I2,I3,I4,I5,I6,I7,Sel)
    begin
        case Sel is
        when "000" => Y <= I0;
        when "001" => Y <= I1;
        when "010" => Y <= I2;
        when "011" => Y <= I3;
        when "100" => Y <= I4;
        when "101" => Y <= I5;
        when "110" => Y <= I6;
        when "111" => Y <= I7;
        when others => Y <= (others => '0');  
        end case;
    end process mux8_proc;
    
end beh;