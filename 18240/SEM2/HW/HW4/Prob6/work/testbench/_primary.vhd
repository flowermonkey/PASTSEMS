library verilog;
use verilog.vl_types.all;
entity testbench is
    generic(
        w               : integer := 30
    );
    port(
        d_in_ready      : out    vl_logic;
        clk             : out    vl_logic;
        reset           : out    vl_logic;
        d_in            : out    vl_logic_vector;
        d_out           : in     vl_logic_vector;
        d_out_ready     : in     vl_logic
    );
end testbench;
