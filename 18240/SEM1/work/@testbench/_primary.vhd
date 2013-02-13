library verilog;
use verilog.vl_types.all;
entity Testbench is
    port(
        sum             : in     vl_logic_vector(3 downto 0);
        N               : in     vl_logic;
        Z               : in     vl_logic;
        V               : in     vl_logic;
        a               : out    vl_logic_vector(3 downto 0);
        b               : out    vl_logic_vector(3 downto 0)
    );
end Testbench;
