library verilog;
use verilog.vl_types.all;
entity makecorrect is
    port(
        incode          : in     vl_logic_vector(12 downto 0);
        oneerr          : in     vl_logic;
        twoerr          : in     vl_logic;
        syndrome        : in     vl_logic_vector(3 downto 0);
        outcode         : out    vl_logic_vector(12 downto 0)
    );
end makecorrect;
