library verilog;
use verilog.vl_types.all;
entity sevenSegDisplay is
    port(
        sevenseg1       : out    vl_logic_vector(7 downto 0);
        sevenseg2       : out    vl_logic_vector(7 downto 0);
        switches        : in     vl_logic_vector(4 downto 0);
        aluSrc1         : in     vl_logic_vector(15 downto 0);
        aluSrc2         : in     vl_logic_vector(15 downto 0);
        aluOut          : in     vl_logic_vector(15 downto 0);
        irVal           : in     vl_logic_vector(15 downto 0);
        pcVal           : in     vl_logic_vector(15 downto 0);
        marVal          : in     vl_logic_vector(15 downto 0);
        mdrVal          : in     vl_logic_vector(15 downto 0);
        viewReg         : in     vl_logic_vector(15 downto 0);
        spVal           : in     vl_logic_vector(15 downto 0)
    );
end sevenSegDisplay;
