library verilog;
use verilog.vl_types.all;
library work;
entity controlpath is
    port(
        CCin            : in     vl_logic_vector(3 downto 0);
        IRIn            : in     vl_logic_vector(15 downto 0);
        \out\           : out    work.controlpath_sv_unit.\controlPts\;
        currState       : out    work.controlpath_sv_unit.opcode_t;
        nextState       : out    work.controlpath_sv_unit.opcode_t;
        clock           : in     vl_logic;
        reset_L         : in     vl_logic
    );
end controlpath;
