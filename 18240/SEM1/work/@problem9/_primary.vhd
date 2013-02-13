library verilog;
use verilog.vl_types.all;
entity Problem9 is
    port(
        g               : in     vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        y               : out    vl_logic;
        valid           : out    vl_logic
    );
end Problem9;
