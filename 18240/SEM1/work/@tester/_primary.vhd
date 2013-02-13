library verilog;
use verilog.vl_types.all;
entity Tester is
    port(
        a               : out    vl_logic;
        b               : out    vl_logic;
        c               : out    vl_logic;
        d               : out    vl_logic;
        e               : out    vl_logic;
        f               : out    vl_logic;
        valid           : in     vl_logic
    );
end Tester;
