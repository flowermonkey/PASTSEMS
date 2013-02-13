library verilog;
use verilog.vl_types.all;
entity fsm_task3 is
    port(
        clk             : in     vl_logic;
        is_new          : in     vl_logic;
        eqto8           : in     vl_logic;
        less5           : in     vl_logic;
        key             : in     vl_logic_vector(7 downto 0);
        ld_keyshift     : out    vl_logic;
        en_keyshift     : out    vl_logic;
        ld_key          : out    vl_logic;
        clr_key         : out    vl_logic;
        en_counter      : out    vl_logic;
        clr_counter     : out    vl_logic;
        up              : out    vl_logic;
        clr_message     : out    vl_logic;
        en_message      : out    vl_logic;
        new_message     : out    vl_logic
    );
end fsm_task3;
