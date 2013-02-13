library verilog;
use verilog.vl_types.all;
entity demux is
    generic(
        OUT_WIDTH       : integer := 8;
        IN_WIDTH        : integer := 3;
        DEFAULT         : integer := 0
    );
    port(
        \in\            : in     vl_logic;
        sel             : in     vl_logic_vector;
        \out\           : out    vl_logic_vector
    );
end demux;
