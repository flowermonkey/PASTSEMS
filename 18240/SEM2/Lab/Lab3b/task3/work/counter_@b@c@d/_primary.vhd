library verilog;
use verilog.vl_types.all;
entity counter_BCD is
    port(
        clk             : in     vl_logic;
        up              : in     vl_logic;
        en              : in     vl_logic;
        clr             : in     vl_logic;
        load            : in     vl_logic;
        d               : in     vl_logic_vector(7 downto 0);
        q               : out    vl_logic_vector(7 downto 0)
    );
end counter_BCD;
