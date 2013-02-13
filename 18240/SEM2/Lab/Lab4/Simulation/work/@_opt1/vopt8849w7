library verilog;
use verilog.vl_types.all;
entity memory_16bit is
    port(
        dataout         : out    vl_logic_vector(15 downto 0);
        datain          : in     vl_logic_vector(15 downto 0);
        addr            : in     vl_logic_vector(15 downto 0);
        we_L            : in     work.library_sv_unit.wr_cond_code_t;
        clock           : in     vl_logic
    );
end memory_16bit;
