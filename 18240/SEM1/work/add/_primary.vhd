library verilog;
use verilog.vl_types.all;
entity add is
    generic(
        W               : integer := 1
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        c               : in     vl_logic;
        sum             : out    vl_logic_vector
    );
end add;
