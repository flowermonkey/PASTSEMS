library verilog;
use verilog.vl_types.all;
entity decRegister is
    generic(
        W               : integer := 1
    );
    port(
        c               : in     vl_logic;
        ld              : in     vl_logic;
        dec             : in     vl_logic;
        newVal          : in     vl_logic_vector;
        Val             : out    vl_logic_vector
    );
end decRegister;
