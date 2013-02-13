
module priQueue ( newVal, ck, r, clear, loadIn, shiftOut, top );
  input [0:0] newVal;
  output [0:0] top;
  input ck, r, clear, loadIn, shiftOut;
  wire   \r2_out[0] , \r3_out[0] , \r5_out[0] , \r6_out[0] , \r6/N1 , n17, n43,
         n50, n51, n52, n53, n54, n55, n257, n258, n259, n260, n261, n262,
         n263, n265, n266, n267, n268, n269, n270, n271, n272, n277, n279,
         n280;
  assign \r6/N1  = r;

  DFFSX1 \r2/out_reg[0]  ( .D(n55), .CK(ck), .SN(n17), .Q(n277), .QN(
        \r2_out[0] ) );
  DFFSX1 \r6/out_reg[0]  ( .D(n51), .CK(ck), .SN(n17), .QN(\r6_out[0] ) );
  DFFSX1 \r3/out_reg[0]  ( .D(n54), .CK(ck), .SN(n17), .QN(\r3_out[0] ) );
  DFFSX1 \r5/out_reg[0]  ( .D(n52), .CK(ck), .SN(n17), .QN(\r5_out[0] ) );
  DFFSX1 \r4/out_reg[0]  ( .D(n53), .CK(ck), .SN(n17), .QN(n257) );
  OAI21XL U189 ( .A0(clear), .A1(shiftOut), .B0(n270), .Y(n268) );
  OAI21XL U184 ( .A0(n270), .A1(newVal[0]), .B0(n271), .Y(n267) );
  AOI22XL U173 ( .A0(n266), .A1(n257), .B0(\r3_out[0] ), .B1(n267), .Y(n265)
         );
  OAI21XL U172 ( .A0(n263), .A1(n277), .B0(n265), .Y(n262) );
  INVX1 U190 ( .A(loadIn), .Y(n270) );
  NOR2X1 U177 ( .A(clear), .B(n268), .Y(n258) );
  NAND2X1 U180 ( .A(loadIn), .B(newVal[0]), .Y(n263) );
  NOR2X1 U179 ( .A(clear), .B(n263), .Y(n260) );
  NAND3BX1 U185 ( .AN(shiftOut), .B(n261), .C(n270), .Y(n271) );
  NOR2BX1 U176 ( .AN(n267), .B(clear), .Y(n259) );
  INVX1 U188 ( .A(n268), .Y(n266) );
  AOI22X1 U183 ( .A0(n266), .A1(n277), .B0(n279), .B1(n267), .Y(n272) );
  NAND2X1 U171 ( .A(n261), .B(n262), .Y(n54) );
  OAI31X1 U181 ( .A0(clear), .A1(newVal[0]), .A2(n270), .B0(n271), .Y(n269) );
  INVX1 U186 ( .A(clear), .Y(n261) );
  AOI222XL U175 ( .A0(n258), .A1(\r6_out[0] ), .B0(n257), .B1(n260), .C0(n259), 
        .C1(\r5_out[0] ), .Y(n52) );
  AOI222XL U174 ( .A0(n258), .A1(\r5_out[0] ), .B0(n257), .B1(n259), .C0(n260), 
        .C1(\r3_out[0] ), .Y(n53) );
  AOI22XL U178 ( .A0(\r6_out[0] ), .A1(n269), .B0(n260), .B1(\r5_out[0] ), .Y(
        n51) );
  INVX1 U191 ( .A(\r6/N1 ), .Y(n17) );
  DFFSHQX4 \r1/out_reg[0]  ( .D(n50), .CK(ck), .SN(n17), .Q(n43) );
  CLKINVXL U192 ( .A(n43), .Y(n280) );
  INVXL U193 ( .A(n43), .Y(top[0]) );
  NAND2X1 U194 ( .A(n272), .B(n261), .Y(n50) );
  INVX1 U195 ( .A(n280), .Y(n279) );
  AOI222X1 U196 ( .A0(n280), .A1(n260), .B0(n259), .B1(\r2_out[0] ), .C0(n258), 
        .C1(\r3_out[0] ), .Y(n55) );
endmodule

