library verilog;
use verilog.vl_types.all;
library work;
entity barDisplay is
    port(
        leds            : out    vl_logic_vector(7 downto 0);
        switches        : in     vl_logic_vector(2 downto 0);
        controlPoints   : in     work.board_sv_unit.\controlPts\;
        condCodes       : in     vl_logic_vector(3 downto 0);
        regSelA         : in     vl_logic_vector(2 downto 0);
        regSelB         : in     vl_logic_vector(2 downto 0);
        currState       : in     vl_logic_vector(9 downto 0);
        nextState       : in     vl_logic_vector(9 downto 0);
        clock           : in     vl_logic
    );
end barDisplay;
