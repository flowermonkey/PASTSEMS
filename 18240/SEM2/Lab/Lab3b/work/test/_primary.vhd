library verilog;
use verilog.vl_types.all;
entity test is
    port(
        clk             : in     vl_logic;
        serial_out      : out    vl_logic
    );
end test;
