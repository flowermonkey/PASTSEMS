library verilog;
use verilog.vl_types.all;
entity fsmtestbench is
    port(
        c_move          : in     vl_logic_vector(3 downto 0);
        h_move          : out    vl_logic_vector(3 downto 0);
        clk             : out    vl_logic;
        rst             : out    vl_logic
    );
end fsmtestbench;
