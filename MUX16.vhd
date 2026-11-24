library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX16 is
    generic (d_w: integer:= 4);
    Port ( I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15 : in std_logic_vector(d_w-1 downto 0);
           Sel : in std_logic_vector(3 downto 0);
           Y: out std_logic_vector(d_w - 1 downto 0)
    );
end MUX16;

architecture beh of MUX16 is

begin
MUX16_proc: process (I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15,Sel)
    begin
        case Sel is
            when "0000" => Y <= I0;
            when "0001" => Y <= I1;
            when "0010" => Y <= I2;
            when "0011" => Y <= I3;
            when "0100" => Y <= I4;
            when "0101" => Y <= I5;
            when "0110" => Y <= I6;
            when "0111" => Y <= I7;
            when "1000" => Y <= I8;
            when "1001" => Y <= I9;
            when "1010" => Y <= I10;
            when "1011" => Y <= I11;
            when "1100" => Y <= I12;
            when "1101" => Y <= I13;
            when "1110" => Y <= I14;
            when "1111" => Y <= I15;
            when others => Y <= (others => '0');  
        end case;
    end process MUX16_proc;
    
end beh;