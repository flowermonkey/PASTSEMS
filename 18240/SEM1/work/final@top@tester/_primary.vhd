library verilog;
use verilog.vl_types.all;
entity finalTopTester is
    port(
        x               : out    vl_logic_vector(3 downto 0);
        y               : out    vl_logic_vector(3 downto 0);
        big             : out    vl_logic;
        bigleft         : out    vl_logic_vector(1 downto 0);
        scorethis       : out    vl_logic;
        hit             : in     vl_logic;
        nearmiss        : in     vl_logic;
        miss            : in     vl_logic;
        numhits         : in     vl_logic_vector(7 downto 0);
        biggestshiphit  : in     vl_logic_vector(4 downto 0);
        somethingiswrong: in     vl_logic
    );
end finalTopTester;
