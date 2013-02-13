library verilog;
use verilog.vl_types.all;
entity shift_register_PISO is
    generic(
        w               : integer := 4
    );
    port(
        d               : in     vl_logic_vector;
        clk             : in     vl_logic;
        load            : in     vl_logic;
        en              : in     vl_logic;
        s_out           : out    vl_logic
    );
end shift_register_PISO;
