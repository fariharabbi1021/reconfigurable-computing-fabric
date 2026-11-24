library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.finish;

use work.custom_pack.all;

entity Testbench is

end Testbench;

architecture beh of Testbench is

    constant D_W  : integer := 4;
    constant ROWS : integer := 5;
    constant COLS : integer := 5;
    
    signal s_Ain      : arr_1d(0 to COLS-1);
    signal s_Bin      : arr_1d(0 to COLS-1);
    signal s_ops      : op_arr_2d(0 to ROWS-1)(0 to COLS-1);
    signal s_selAmux8  : sel3_arr_1d(0 to COLS-1);
    signal s_selBmux8  : sel3_arr_1d(0 to COLS-1);
    signal s_selAmux16 : sel4_arr_2d(2 to ROWS-1)(0 to COLS-1);
    signal s_selBmux16 : sel4_arr_2d(2 to ROWS-1)(0 to COLS-1);
    signal s_Yout : arr_1d(0 to COLS-1);
    
    constant GND4 : data_t := (others => '0');
    constant GND3 : data_3b := (others => '0');
               
    begin
    
        dut : entity work.fabric_5x5
            generic map (
                D_W  => D_W,
                ROWS => ROWS,
                COLS => COLS
            )
            port map (
                Ain        => s_Ain,
                Bin        => s_Bin,
                Ops        => s_ops,
                selA_mux8  => s_selAmux8,
                selB_mux8  => s_selBmux8,
                selA_mux16 => s_selAmux16,
                selB_mux16 => s_selBmux16,
                Yout       => s_Yout
            );

            
    stim: process
    variable t_ops : op_arr_2d(0 to ROWS-1)(0 to COLS-1);
    variable t_A   : arr_1d(0 to COLS-1);
    variable t_B   : arr_1d(0 to COLS-1);
    variable t_selA8 : sel3_arr_1d(0 to COLS-1);
    variable t_selB8 : sel3_arr_1d(0 to COLS-1);
    variable t_selA16 : sel4_arr_2d(2 to ROWS-1)(0 to COLS-1);
    variable t_selB16 : sel4_arr_2d(2 to ROWS-1)(0 to COLS-1);
    
    
    begin
        
        -- Test Case 1
        t_ops := (
            0 => (0 => XNORo,  1 => SUBo,   2 => RORo,   3 => NANDo,  4 => NOPo),
            1 => (0 => ROLo,   1 => LTo,    2 => ANDo,   3 => XORo,   4 => LSLo),
            2 => (0 => LSRo,   1 => MULTo,  2 => GTo,    3 => NOPo,   4 => NOPo),
            3 => (0 => NORo,   1 => LSRo,   2 => LTEo,   3 => NOPo,   4 => NOPo),
            4 => (0 => PASSAo, 1 => PASSAo, 2 => PASSAo, 3 => NOPo,   4 => NOPo)
        );
        
        t_A := (
            0 => "1100", 1 => "1110", 2 => "1101", 3 => "1000", 4 => "0000"
        );
        
        t_B := (
            0 => "1011", 1 => "0111", 2 => "0110", 3 => "0101", 4 => "0000"
        );
        
        t_selA8 := (
            0 => "000", 1 => "000", 2 => "001", 3 => "000", 4 => "011"
        );
        
        t_selB8 := (
            0 => "001", 1 => "011", 2 => "010", 3 => "010", 4 => "010"
        );
        
        t_selA16 := (
            2 => (0 => "0001", 1=> "0000", 2=> "0011", 3 => "1001", 4 => "1001"),
            3 => (0 => "0001", 1=> "0001", 2=> "1000", 3 => GND4,   4 => GND4  ),
            4 => (0 => "0000", 1=> "0001", 2=> "0010", 3 => GND4,   4 => GND4  )
        );
        
        t_selB16 := (
            2 => (0 => "0010", 1=> "0111", 2=> "0100", 3 => "1001", 4 => "1001"),
            3 => (0 => "0101", 1=> "0000", 2=> "0010", 3 => GND4,   4 => GND4  ),
            4 => (0 => "0000", 1=> "0000", 2=> "0000", 3 => GND4,   4 => GND4  )
        );
        
        s_ops <= t_ops;
        s_Ain <= t_A;
        s_Bin <= t_B;
        s_selAmux8   <= t_selA8;
        s_selBmux8   <= t_selB8;
        s_selAmux16  <= t_selA16;
        s_selBmux16  <= t_selB16;
        
        wait for 20ns;
       
        -- Test Case 2
        t_ops := (
            0 => (0 => MULTo,  1 => NORo,   2 => ADDo,   3 => ASRo,   4 => LSLo),
            1 => (0 => SUBo,   1 => LSRo,   2 => NOPo,   3 => NOPo,   4 => NOPo),
            2 => (0 => NANDo,  1 => EQo,    2 => XNORo,  3 => ROLo,   4 => NOPo),
            3 => (0 => NOPo,   1 => NOPo,   2 => NOPo,   3 => NOPo,   4 => NOPo),
            4 => (0 => RORo,   1 => NORo,   2 => NOPo,   3 => NOPo,   4 => NOPo)
        );
        
        t_A := (
            0 => "0101", 1 => "1101", 2 => "1001", 3 => "1010", 4 => "1011"
        );
        
        t_B := (
            0 => "0010", 1 => "0100", 2 => "0011", 3 => "0010", 4 => "0011"
        );
        
        t_selA8 := (
            0 => "010", 1 => "011", 2 => GND3, 3 => GND3, 4 => GND3
        );
        
        t_selB8 := (
            0 => "000", 1 => "001", 2 => GND3, 3 => GND3, 4 => GND3
        );
        
        t_selA16 := (
            2 => (0 => "0101", 1=> "0000", 2=> "0111", 3 => "1001", 4 => GND4),
            3 => (0 => GND4,   1=> GND4,   2=> GND4,   3 => GND4,   4 => GND4),
            4 => (0 => "0101", 1=> "0111", 2=> GND4,   3 => GND4,   4 => GND4)
        );
        
        t_selB16 := (
            2 => (0 => "0000", 1=> "0110", 2=> "1000", 3 => "0001", 4 => GND4),
            3 => (0 => GND4,   1=> GND4,   2=> GND4,   3 => GND4,   4 => GND4),
            4 => (0 => "0110", 1=> "1000", 2=> GND4,   3 => GND4,   4 => GND4)
        );
        
        s_ops <= t_ops;
        s_Ain <= t_A;
        s_Bin <= t_B;
        s_selAmux8   <= t_selA8;
        s_selBmux8   <= t_selB8;
        s_selAmux16  <= t_selA16;
        s_selBmux16  <= t_selB16;
        
        wait for 20ns;
           
        -- Test Case 3
        t_ops := (
            0 => (0 => SUBo,   1 => NANDo,  2 => LSRo,   3 => ANDo,   4 => NOPo),
            1 => (0 => SUBo,   1 => NORo,   2 => ADDo,   3 => NOPo,   4 => NOPo),
            2 => (0 => RORo,   1 => MULTo,  2 => LTo,    3 => NOPo,   4 => NOPo),
            3 => (0 => NOPo,   1 => NOPo,   2 => NOPo,   3 => NOPo,   4 => NOPo),
            4 => (0 => PASSAo, 1 => PASSAo, 2 => PASSAo, 3 => NOPo,   4 => NOPo)
        );
        
        t_A := (
            0 => "1100", 1 => "1110", 2 => "1000", 3 => "1101", 4 => "0000"
        );
        
        t_B := (
            0 => "0111", 1 => "1001", 2 => "0001", 3 => "0110", 4 => "0000"
        );
        
        t_selA8 := (
            0 => "010", 1 => "000", 2 => "010", 3 => GND3, 4 => GND3
        );
        
        t_selB8 := (
            0 => "001", 1 => "011", 2 => "011", 3 => GND3, 4 => GND3
        );
        
        t_selA16 := (
            2 => (0 => "0001", 1=> "0110", 2=> "0001", 3 => GND4, 4 => GND4),
            3 => (0 => GND4,   1=> GND4,   2=> GND4,   3 => GND4, 4 => GND4),
            4 => (0 => "0101", 1=> "0110", 2=> "0111", 3 => GND4, 4 => GND4)
        );
        
        t_selB16 := (
            2 => (0 => "0101", 1=> "0000", 2=> "0010", 3 => GND4, 4 => GND4),
            3 => (0 => GND4,   1=> GND4,   2=> GND4,   3 => GND4, 4 => GND4),
            4 => (0 => "0101", 1=> "0101", 2=> "0101", 3 => GND4, 4 => GND4)
        );
        
        s_ops <= t_ops;
        s_Ain <= t_A;
        s_Bin <= t_B;
        s_selAmux8   <= t_selA8;
        s_selBmux8   <= t_selB8;
        s_selAmux16  <= t_selA16;
        s_selBmux16  <= t_selB16;
        
        wait for 20ns;

        -- Test Case 4
        t_ops := (
            0 => (0 => GTo,   1 => NORo,  2 => ROLo,   3 => MULTo,  4 => NOPo),
            1 => (0 => EQo,   1 => LSLo,  2 => XORo,   3 => NOPo,   4 => NOPo),
            2 => (0 => ANDo,  1 => SUBo,  2 => NANDo,  3 => NOPo,   4 => NOPo),
            3 => (0 => XNORo, 1 => LTEo,  2 => NOPo,   3 => NOPo,   4 => NOPo),
            4 => (0 => RORo, 1 => NOPo, 2 => NOPo, 3 => NOPo,   4 => NOPo)
        );
        
        t_A := (
            0 => "1011", 1 => "1001", 2 => "1011", 3 => "0101", 4 => "0000"
        );
        
        t_B := (
            0 => "0101", 1 => "0101", 2 => "1101", 3 => "0011", 4 => "0000"
        );
        
        t_selA8 := (
            0 => "000", 1 => "010", 2 => "010", 3 => GND3, 4 => GND3
        );
        
        t_selB8 := (
            0 => "011", 1 => "001", 2 => "011", 3 => GND3, 4 => GND3
        );
        
        t_selA16 := (
            2 => (0 => "0101", 1=> "0000", 2=> "0010", 3 => GND4, 4 => GND4),
            3 => (0 => "0000", 1=> "0001", 2=> GND4,   3 => GND4, 4 => GND4),
            4 => (0 => "0000", 1=> GND4,   2=> GND4,   3 => GND4, 4 => GND4)
        );
        
        t_selB16 := (
            2 => (0 => "0001", 1=> "0010", 2=> "1000", 3 => GND4, 4 => GND4),
            3 => (0 => "0001", 1=> "0010", 2=> GND4,   3 => GND4, 4 => GND4),
            4 => (0 => "0001", 1=> GND4,   2=> GND4,   3 => GND4, 4 => GND4)
        );
        
        s_ops <= t_ops;
        s_Ain <= t_A;
        s_Bin <= t_B;
        s_selAmux8   <= t_selA8;
        s_selBmux8   <= t_selB8;
        s_selAmux16  <= t_selA16;
        s_selBmux16  <= t_selB16;
        
        wait for 20ns;
               
    finish;
    end process stim;
end beh;

