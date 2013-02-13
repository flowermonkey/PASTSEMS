library verilog;
use verilog.vl_types.all;
entity Comparator is
    port(
        \out\           : out    vl_logic;
        addin           : in     vl_logic_vector(3 downto 0);
        subin           : in     vl_logic_vector(3 downto 0)
    );
end Comparator;
