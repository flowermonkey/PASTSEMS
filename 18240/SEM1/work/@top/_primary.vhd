library verilog;
use verilog.vl_types.all;
entity Top is
    port(
        sum             : out    vl_logic_vector(3 downto 0);
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        N               : out    vl_logic;
        Z               : out    vl_logic;
        V               : out    vl_logic
    );
end Top;
