library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        w               : integer := 4
    );
    port(
        clk             : in     vl_logic;
        load            : in     vl_logic;
        clr             : in     vl_logic;
        data_in         : in     vl_logic_vector;
        data_out        : out    vl_logic_vector
    );
end \register\;
