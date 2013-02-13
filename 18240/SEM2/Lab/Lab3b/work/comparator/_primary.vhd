library verilog;
use verilog.vl_types.all;
entity comparator is
    generic(
        w               : integer := 4
    );
    port(
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        AltB            : out    vl_logic;
        AeqB            : out    vl_logic;
        AgtB            : out    vl_logic
    );
end comparator;
