library verilog;
use verilog.vl_types.all;
entity decryptionService is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        serial_in       : in     vl_logic;
        message_bytes   : out    vl_logic_vector(63 downto 0);
        new_message     : out    vl_logic
    );
end decryptionService;
