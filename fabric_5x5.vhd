library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.custom_pack.all;

entity fabric_5x5 is
    generic (
        D_W  : integer := 4;
        ROWS : integer := 5;
        COLS : integer := 5
    );
    port (
        -- External inputs, 4-bit each
        Ain        : in  arr_1d(0 to COLS-1);
        Bin        : in  arr_1d(0 to COLS-1);

        -- Configuration for each CU
        Ops        : in  op_arr_2d(0 to ROWS-1)(0 to COLS-1);
        selA_mux8  : in  sel3_arr_1d(0 to COLS-1);
        selB_mux8  : in  sel3_arr_1d(0 to COLS-1);
        selA_mux16 : in  sel4_arr_2d(2 to ROWS-1)(0 to COLS-1);
        selB_mux16 : in  sel4_arr_2d(2 to ROWS-1)(0 to COLS-1);
        
        -- Final outputs are the last row outputs (COLS outputs)
        Yout : out arr_1d(0 to COLS-1)
    );
end fabric_5x5;

architecture beh of fabric_5x5 is

    -- Internal CU outputs
    signal w_y   : arr_2d(0 to ROWS-1)(0 to COLS-1);
    signal w_a    : arr_2d(0 to ROWS-1)(0 to COLS-1);
    signal w_b    : arr_2d(0 to ROWS-1)(0 to COLS-1);
    
    constant ZERO4 : data_t := (others => '0');
   
    begin
    
    -- ROW0 receives external inputs
    gen_ins : for c in 0 to COLS-1 generate
        w_a(0)(c) <= Ain(c);
        w_b(0)(c) <= Bin(c);
    end generate;
    
    -- Final outputs are the last row (row ROWS-1)
    gen_outs : for c in 0 to COLS-1 generate
        Yout(c) <= w_y(ROWS-1)(c);
    end generate;

    -- Build the 5x5 fabric
    gen_rows : for r in 0 to ROWS-1 generate
        gen_cols : for c in 0 to COLS-1 generate

            -- Rows 1: select from previous row outputs only
            row1_gen : if r = 1 generate
                muxA : entity work.MUX8
                    generic map (d_w => D_W)
                    port map (
                        I0  => w_y(r-1)(0),
                        I1  => w_y(r-1)(1),
                        I2  => w_y(r-1)(2),
                        I3  => w_y(r-1)(3),
                        I4  => w_y(r-1)(4),
                        I5  => ZERO4,  -- unused
                        I6  => ZERO4,  -- unused
                        I7  => ZERO4,  -- unused
                        Sel => selA_mux8(c),
                        Y   => w_a(r)(c)
                    );

                muxB : entity work.MUX8
                    generic map (d_w => D_W)
                    port map (
                        I0  => w_y(r-1)(0),
                        I1  => w_y(r-1)(1),
                        I2  => w_y(r-1)(2),
                        I3  => w_y(r-1)(3),
                        I4  => w_y(r-1)(4),
                        I5  => ZERO4,  -- unused
                        I6  => ZERO4,  -- unused
                        I7  => ZERO4,  -- unused
                        Sel => selB_mux8(c),
                        Y   => w_b(r)(c)
                    );
            end generate;
            
            -- Rows 2..4: select from parent and grandparent row outputs
            rowN_gen : if r > 1 generate
                muxA : entity work.MUX16
                    generic map (d_w => D_W)
                    port map (
                        I0   => w_y(r-1)(0),
                        I1   => w_y(r-1)(1),
                        I2   => w_y(r-1)(2),
                        I3   => w_y(r-1)(3),
                        I4   => w_y(r-1)(4),
                        I5   => w_y(r-2)(0),
                        I6   => w_y(r-2)(1),
                        I7   => w_y(r-2)(2),
                        I8   => w_y(r-2)(3),
                        I9   => w_y(r-2)(4),
                        I10  => ZERO4,  -- unused
                        I11  => ZERO4,  -- unused
                        I12  => ZERO4,  -- unused
                        I13  => ZERO4,  -- unused
                        I14  => ZERO4,  -- unused
                        I15  => ZERO4,  -- unused
                        Sel  => selA_mux16(r)(c),
                        Y    => w_a(r)(c)
                    );

                muxB : entity work.MUX16
                    generic map (d_w => D_W)
                    port map (
                        I0   => w_y(r-1)(0),
                        I1   => w_y(r-1)(1),
                        I2   => w_y(r-1)(2),
                        I3   => w_y(r-1)(3),
                        I4   => w_y(r-1)(4),
                        I5   => w_y(r-2)(0),
                        I6   => w_y(r-2)(1),
                        I7   => w_y(r-2)(2),
                        I8   => w_y(r-2)(3),
                        I9   => w_y(r-2)(4),
                        I10  => ZERO4,  -- unused
                        I11  => ZERO4,  -- unused
                        I12  => ZERO4,  -- unused
                        I13  => ZERO4,  -- unused
                        I14  => ZERO4,  -- unused
                        I15  => ZERO4,  -- unused
                        Sel  => selB_mux16(r)(c),
                        Y    => w_b(r)(c)
                    );
            end generate;

            -- CU itself
            cu_inst : entity work.CU
                generic map (d_w => D_W)
                port map (
                    A  => w_a(r)(c),
                    B  => w_b(r)(c),
                    Op => Ops(r)(c),
                    Y  => w_y(r)(c)
                );

        end generate;
    end generate;

end beh;
