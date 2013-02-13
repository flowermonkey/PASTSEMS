library verilog;
use verilog.vl_types.all;
entity shift_register_SIPO is
    generic(
        w               : integer := 4
    );
    port(
        s_in            : in     vl_logic;
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        en              : in     vl_logic;
        q               : out    vl_logic_vector
    );
end shift_register_SIPO;
