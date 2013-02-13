library verilog;
use verilog.vl_types.all;
entity testPatrol is
    port(
        hit             : in     vl_logic_vector(3 downto 0);
        nearmiss        : in     vl_logic;
        miss            : in     vl_logic;
        big             : out    vl_logic;
        x               : out    vl_logic_vector(3 downto 0);
        y               : out    vl_logic_vector(3 downto 0)
    );
end testPatrol;
