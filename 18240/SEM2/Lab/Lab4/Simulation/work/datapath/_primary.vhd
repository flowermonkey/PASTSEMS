library verilog;
use verilog.vl_types.all;
library work;
entity datapath is
    port(
        ir              : out    vl_logic_vector(15 downto 0);
        sp              : out    vl_logic_vector(15 downto 0);
        condCodes       : out    vl_logic_vector(3 downto 0);
        aluSrcA         : out    vl_logic_vector(15 downto 0);
        aluSrcB         : out    vl_logic_vector(15 downto 0);
        viewReg         : out    vl_logic_vector(15 downto 0);
        aluResult       : out    vl_logic_vector(15 downto 0);
        pc              : out    vl_logic_vector(15 downto 0);
        memAddr         : out    vl_logic_vector(15 downto 0);
        memData         : out    vl_logic_vector(15 downto 0);
        regSelA         : out    vl_logic_vector(2 downto 0);
        regSelB         : out    vl_logic_vector(2 downto 0);
        viewSel         : in     vl_logic_vector(2 downto 0);
        cPts            : in     work.datapath_sv_unit.\controlPts\;
        clock           : in     vl_logic;
        reset_L         : in     vl_logic
    );
end datapath;
