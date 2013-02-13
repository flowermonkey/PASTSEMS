library verilog;
use verilog.vl_types.all;
entity test is
    port(
        hit             : in     vl_logic;
        nearmiss        : in     vl_logic;
        miss            : in     vl_logic;
        big             : out    vl_logic;
        x               : out    vl_logic;
        y               : out    vl_logic
    );
end test;
