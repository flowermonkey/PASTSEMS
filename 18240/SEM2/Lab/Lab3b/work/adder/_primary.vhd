library verilog;
use verilog.vl_types.all;
entity adder is
    generic(
        w               : integer := 4
    );
    port(
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        Cin             : in     vl_logic;
        sum             : out    vl_logic_vector;
        Cout            : out    vl_logic
    );
end adder;
