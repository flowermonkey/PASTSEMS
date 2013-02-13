library verilog;
use verilog.vl_types.all;
entity fsm_task3 is
    port(
        clk             : in     vl_logic;
        is_new          : in     vl_logic;
        eqto1           : in     vl_logic;
        iseqto8         : in     vl_logic;
        countA          : in     vl_logic_vector(3 downto 0);
        ld_keyshift     : out    vl_logic;
        en_keyshift     : out    vl_logic;
        ld_byte_reg     : out    vl_logic;
        clr_byte_reg    : out    vl_logic;
        ld_key          : out    vl_logic;
        clr_key         : out    vl_logic;
        en_counter      : out    vl_logic;
        clr_counter     : out    vl_logic;
        ld_counter      : out    vl_logic;
        up              : out    vl_logic;
        clr_message     : out    vl_logic;
        en_message      : out    vl_logic;
        new_message     : out    vl_logic
    );
end fsm_task3;
