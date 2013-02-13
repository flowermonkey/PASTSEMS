library verilog;
use verilog.vl_types.all;
entity iscorrect is
    port(
        incode          : in     vl_logic_vector(12 downto 0);
        syndrome        : in     vl_logic_vector(3 downto 0);
        oneerr          : out    vl_logic;
        twoerr          : out    vl_logic
    );
end iscorrect;
