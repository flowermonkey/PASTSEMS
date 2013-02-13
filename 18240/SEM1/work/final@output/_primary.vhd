library verilog;
use verilog.vl_types.all;
entity finalOutput is
    port(
        hit             : out    vl_logic;
        nearmiss        : out    vl_logic;
        miss            : out    vl_logic;
        numhits         : out    vl_logic_vector(7 downto 0);
        biggestshiphit  : out    vl_logic_vector(4 downto 0);
        somethingiswrongout: out    vl_logic;
        patrolhit       : in     vl_logic_vector(3 downto 0);
        patrolnearmiss  : in     vl_logic;
        patrolmiss      : in     vl_logic;
        pledhit         : in     vl_logic_vector(7 downto 0);
        subhit          : in     vl_logic_vector(3 downto 0);
        subnearmiss     : in     vl_logic;
        submiss         : in     vl_logic;
        subledhit       : in     vl_logic_vector(7 downto 0);
        blockhit        : in     vl_logic_vector(3 downto 0);
        blocknearmiss   : in     vl_logic;
        blockmiss       : in     vl_logic;
        blockledhit     : in     vl_logic_vector(7 downto 0);
        blockrank       : in     vl_logic_vector(4 downto 0);
        scorethis       : in     vl_logic;
        somethingiswrongin: in     vl_logic
    );
end finalOutput;
