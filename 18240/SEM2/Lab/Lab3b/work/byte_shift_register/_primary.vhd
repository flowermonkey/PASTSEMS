library verilog;
use verilog.vl_types.all;
entity byte_shift_register is
    port(
        inpbyte         : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        en              : in     vl_logic;
        message         : out    vl_logic_vector(63 downto 0)
    );
end byte_shift_register;
