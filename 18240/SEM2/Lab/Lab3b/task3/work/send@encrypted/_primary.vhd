library verilog;
use verilog.vl_types.all;
entity sendEncrypted is
    generic(
        WORDS           : integer := 153;
        WORD_SIZE       : integer := 23
    );
    port(
        clk             : in     vl_logic;
        serial_out      : out    vl_logic
    );
end sendEncrypted;