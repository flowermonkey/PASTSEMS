library verilog;
use verilog.vl_types.all;
entity fsm is
    port(
        clk             : in     vl_logic;
        twoerr          : in     vl_logic;
        eqto0           : in     vl_logic;
        eqto1           : in     vl_logic;
        eqto13          : in     vl_logic;
        eqto10          : in     vl_logic;
        countA          : in     vl_logic_vector(3 downto 0);
        countB          : in     vl_logic_vector(3 downto 0);
        message_byte    : in     vl_logic_vector(7 downto 0);
        clr_SIPO        : out    vl_logic;
        en_SIPO         : out    vl_logic;
        sel             : out    vl_logic;
        ld_A            : out    vl_logic;
        clr_A           : out    vl_logic;
        up_cA           : out    vl_logic;
        up_cB           : out    vl_logic;
        en_cA           : out    vl_logic;
        en_cB           : out    vl_logic;
        clr_cA          : out    vl_logic;
        clr_cB          : out    vl_logic;
        ld_cA           : out    vl_logic;
        ld_cB           : out    vl_logic;
        is_new          : out    vl_logic;
        inp_cA          : out    vl_logic_vector(3 downto 0);
        inp_cB          : out    vl_logic_vector(3 downto 0)
    );
end fsm;
