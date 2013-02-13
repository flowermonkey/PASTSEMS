library verilog;
use verilog.vl_types.all;
entity LEDController is
    port(
        displayValuesA  : in     vl_logic_vector(7 downto 0);
        displayValuesB  : in     vl_logic_vector(7 downto 0);
        displayValuesC  : in     vl_logic_vector(7 downto 0);
        displayValuesD  : in     vl_logic_vector(7 downto 0);
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        displayA        : out    vl_logic;
        displayB        : out    vl_logic;
        displayC        : out    vl_logic;
        displayD        : out    vl_logic;
        sevenSegmentDisplay: out    vl_logic_vector(7 downto 0)
    );
end LEDController;
