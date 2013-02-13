library verilog;
use verilog.vl_types.all;
entity receiver is
    port(
        clk             : in     vl_logic;
        serial_in       : in     vl_logic;
        message_byte    : out    vl_logic_vector(7 downto 0);
        is_new          : out    vl_logic
    );
end receiver;
