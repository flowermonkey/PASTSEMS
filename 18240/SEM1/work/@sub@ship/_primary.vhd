library verilog;
use verilog.vl_types.all;
entity SubShip is
    port(
        hit             : out    vl_logic_vector(3 downto 0);
        nearmiss        : out    vl_logic;
        miss            : out    vl_logic;
        big             : in     vl_logic;
        x               : in     vl_logic_vector(3 downto 0);
        y               : in     vl_logic_vector(3 downto 0)
    );
end SubShip;
