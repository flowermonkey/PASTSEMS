library verilog;
use verilog.vl_types.all;
entity top1 is
    port(
        displayA        : out    vl_logic;
        sevenSegmentDisplay: out    vl_logic_vector(7 downto 0);
        h_move          : in     vl_logic_vector(3 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        c_move          : out    vl_logic_vector(3 downto 0)
    );
end top1;
