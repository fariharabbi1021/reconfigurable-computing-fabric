library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package custom_pack is

    -- Project 1 is 4-bit data
    subtype data_t is std_logic_vector(3 downto 0);
    subtype data_3b is std_logic_vector(2 downto 0);

    -- MUX8 select
    subtype sel3_t is std_logic_vector(2 downto 0);
    subtype sel4_t is std_logic_vector(3 downto 0);

    -- Operations
    type op_select is (
        ANDo, ORo, NANDo, NORo, XORo, XNORo,
        ADDo, SUBo, MULTo,
        ASLo, ASRo, ROLo, RORo, LSLo, LSRo,
        PASSAo, PASSBo, NOPo, 
        GTo, LTo, EQo, GTEo, LTEo, NEQo
    );

    -- Op arrays
    type op_arr_1d is array(natural range<>) of op_select;
    type op_arr_2d is array(natural range<>) of op_arr_1d;

    -- Data arrays
    type arr_1d is array(natural range<>) of data_t;
    type arr_2d is array(natural range<>) of arr_1d;

    -- Select arrays (3-bit)
    type sel3_arr_1d is array(natural range<>) of sel3_t;
    type sel3_arr_2d is array(natural range<>) of sel3_arr_1d;
    
    -- Select arrays (4-bit)
    type sel4_arr_1d is array(natural range<>) of sel4_t;
    type sel4_arr_2d is array(natural range<>) of sel4_arr_1d;

end package custom_pack;