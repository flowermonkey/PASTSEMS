library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        W               : integer := 1
    );
    port(
        c               : in     vl_logic;
        ld              : in     vl_logic;
        reset_l         : in     vl_logic;
        cl              : in     vl_logic;
        newVal          : in     vl_logic_vector;
        Val             : out    vl_logic_vector
    );
end \register\;
