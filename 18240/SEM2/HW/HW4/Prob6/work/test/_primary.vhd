library verilog;
use verilog.vl_types.all;
entity test is
    port(
        \out\           : in     vl_logic;
        \in\            : out    vl_logic_vector(31 downto 0);
        sel             : out    vl_logic_vector(4 downto 0)
    );
end test;
