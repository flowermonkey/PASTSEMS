library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        w               : integer := 4
    );
    port(
        clk             : in     vl_logic;
        up              : in     vl_logic;
        en              : in     vl_logic;
        clr             : in     vl_logic;
        load            : in     vl_logic;
        d               : in     vl_logic_vector;
        q               : out    vl_logic_vector
    );
end counter;
