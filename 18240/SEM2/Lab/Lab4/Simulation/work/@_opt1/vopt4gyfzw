library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        \out\           : out    vl_logic_vector(15 downto 0);
        condCodes       : out    vl_logic_vector(3 downto 0);
        inA             : in     vl_logic_vector(15 downto 0);
        inB             : in     vl_logic_vector(15 downto 0);
        opcode          : in     work.alu_sv_unit.alu_op_t
    );
end alu;
