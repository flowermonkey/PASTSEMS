library verilog;
use verilog.vl_types.all;
entity muxulator is
    port(
        sel             : in     vl_logic_vector(7 downto 0);
        dmuxmsg         : out    vl_logic_vector(7 downto 0)
    );
end muxulator;
