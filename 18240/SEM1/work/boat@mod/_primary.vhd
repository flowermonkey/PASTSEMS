library verilog;
use verilog.vl_types.all;
entity boatMod is
    port(
        rank            : out    vl_logic_vector(2 downto 0);
        pathit          : in     vl_logic_vector(3 downto 0);
        subhit          : in     vl_logic_vector(3 downto 0);
        blockrank       : in     vl_logic_vector(2 downto 0)
    );
end boatMod;
