library verilog;
use verilog.vl_types.all;
entity blockShip is
    port(
        hit             : out    vl_logic_vector(3 downto 0);
        nearmiss        : out    vl_logic;
        miss            : out    vl_logic;
        rank            : out    vl_logic_vector(4 downto 0);
        big             : in     vl_logic;
        x               : in     vl_logic_vector(3 downto 0);
        y               : in     vl_logic_vector(3 downto 0)
    );
end blockShip;
