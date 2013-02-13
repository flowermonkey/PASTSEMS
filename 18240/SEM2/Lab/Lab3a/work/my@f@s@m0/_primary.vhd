library verilog;
use verilog.vl_types.all;
entity myFSM0 is
    port(
        h_move          : in     vl_logic_vector(3 downto 0);
        c_move          : out    vl_logic_vector(3 downto 0);
        q0              : out    vl_logic;
        q1              : out    vl_logic;
        q2              : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end myFSM0;
