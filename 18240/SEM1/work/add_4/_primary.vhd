library verilog;
use verilog.vl_types.all;
entity add_4 is
    port(
        sum             : out    vl_logic_vector(3 downto 0);
        N               : out    vl_logic;
        Z               : out    vl_logic;
        V               : out    vl_logic;
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0)
    );
end add_4;
