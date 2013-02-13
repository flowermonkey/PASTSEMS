library verilog;
use verilog.vl_types.all;
entity compare is
    generic(
        W               : integer := 1
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        c               : in     vl_logic;
        eq              : out    vl_logic;
        aGT             : out    vl_logic;
        bGT             : out    vl_logic
    );
end compare;
