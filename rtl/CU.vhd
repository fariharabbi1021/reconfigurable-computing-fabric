library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.custom_pack.all;

entity CU is
    Generic(d_w: integer := 4);
    Port ( A, B : in std_logic_vector(d_w - 1 downto 0); 
           Op : in op_select;                            
           Y : out std_logic_vector(d_w - 1 downto 0));   
end CU;

architecture beh of CU is
 
begin
    op_sel: process(A, B, Op)
    variable tempMult: std_logic_vector(d_w*2-1 downto 0);
    begin
        case Op is
            when ANDo => 
                Y <= (A and B);
            when ORo => 
                Y <= (A or B);
            when NANDo => 
                Y <= (A nand B);
            when NORo => 
                Y <= (A nor B);
            when XORo => 
                Y <= (A xor B);
            when XNORo => 
                Y <= (A xnor B);
            when ADDo => 
                Y <= std_logic_vector(unsigned(A) + unsigned(B));
            when SUBo => 
                Y <= std_logic_vector(unsigned(A) - unsigned(B));
            when MULTo => 
                tempMult:= std_logic_vector(unsigned(A) * unsigned(B));
                Y <= tempMult(d_w-1 downto 0);
            when GTo => 
                if unsigned(A) > unsigned(B) then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when LTo =>
                if unsigned(A) < unsigned(B) then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when EQo =>
                if A = B then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when GTEo =>
                if unsigned(A) >= unsigned(B) then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when LTEo =>
                if unsigned(A) <= unsigned(B) then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when NEQo =>
                if A /= B then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when LSLo =>  
                Y <= to_stdlogicvector(to_bitvector(A) sll to_integer(unsigned(B)));
            when LSRo => 
                Y <= to_stdlogicvector(to_bitvector(A) srl to_integer(unsigned(B)));
            when ASRo =>  
                Y <= to_stdlogicvector(to_bitvector(A) sra to_integer(unsigned(B)));
            when ASLo =>  
                Y <= to_stdlogicvector(to_bitvector(A) sla to_integer(unsigned(B)));
            when ROLo => 
                Y <= to_stdlogicvector(to_bitvector(A) rol to_integer(unsigned(B)));
            when RORo => 
                Y <= to_stdlogicvector(to_bitvector(A) ror to_integer(unsigned(B)));
            when NOPo =>
                Y <= (others => '0');    
            when PASSAo =>
                Y <= A;
            when PASSBo =>
                Y <= B;
            when others => 
                Y <= (others => '0'); 
        end case; 
         
    end process op_sel;
    
end beh;

