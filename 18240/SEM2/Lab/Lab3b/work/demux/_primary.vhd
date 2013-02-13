library verilog;
use verilog.vl_types.all;
entity demux is
    port(
        sel             : in     vl_logic_vector(7 downto 0);
        dmuxmsg         : out    vl_logic_vector(7 downto 0)
    );
end demux;
