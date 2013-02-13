library verilog;
use verilog.vl_types.all;
entity top1 is
    port(
        displayA        : out    vl_logic;
        displayB        : out    vl_logic;
        displayC        : out    vl_logic;
        displayD        : out    vl_logic;
        sevenSegmentDisplay: out    vl_logic_vector(7 downto 0)
    );
end top1;
