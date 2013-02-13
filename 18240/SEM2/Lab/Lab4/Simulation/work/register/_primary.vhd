library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        WIDTH           : integer := 16
    );
    port(
        \out\           : out    vl_logic_vector;
        \in\            : in     vl_logic_vector;
        load_L          : in     vl_logic;
        clock           : in     vl_logic;
        reset_L         : in     vl_logic
    );
end \register\;
