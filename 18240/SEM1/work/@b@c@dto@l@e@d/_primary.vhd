library verilog;
use verilog.vl_types.all;
entity BCDtoLED is
    port(
        led             : out    vl_logic_vector(7 downto 0);
        bar             : out    vl_logic;
        bcd             : in     vl_logic_vector(3 downto 0)
    );
end BCDtoLED;
