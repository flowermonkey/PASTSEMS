library verilog;
use verilog.vl_types.all;
entity BigBombPossible is
    port(
        valid           : out    vl_logic;
        big             : in     vl_logic;
        bigleft         : in     vl_logic_vector(1 downto 0)
    );
end BigBombPossible;
