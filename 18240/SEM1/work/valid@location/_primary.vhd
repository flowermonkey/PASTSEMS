library verilog;
use verilog.vl_types.all;
entity validLocation is
    port(
        valid           : out    vl_logic;
        x               : in     vl_logic_vector(3 downto 0);
        y               : in     vl_logic_vector(3 downto 0)
    );
end validLocation;
