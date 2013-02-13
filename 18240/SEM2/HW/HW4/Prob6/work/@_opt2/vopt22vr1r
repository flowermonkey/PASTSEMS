library verilog;
use verilog.vl_types.all;
entity fsm is
    generic(
        w               : integer := 30
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        d_in_ready      : in     vl_logic;
        lowBit          : in     vl_logic;
        BCount          : in     vl_logic_vector;
        Cclr            : out    vl_logic;
        Cinc            : out    vl_logic;
        Oclr            : out    vl_logic;
        Oinc            : out    vl_logic;
        load            : out    vl_logic;
        d_out_ready     : out    vl_logic
    );
end fsm;
