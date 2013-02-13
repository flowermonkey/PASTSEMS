library verilog;
use verilog.vl_types.all;
entity mux is
    generic(
        w               : integer := 32
    );
    port(
        \in\            : in     vl_logic_vector;
        sel             : in     vl_logic_vector;
        \out\           : out    vl_logic
    );
end mux;
