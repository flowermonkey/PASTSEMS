
module priQueue ( newVal, ck, r, clear, loadIn, shiftOut, top );
  input [0:0] newVal;
  output [0:0] top;
  input ck, r, clear, loadIn, shiftOut;
  wire   \r2_out[0] , \r3_out[0] , \r5_out[0] , \r6_out[0] , \r6/N1 , n17, n43,
         n50, n51, n52, n53, n54, n55, n279, n292, n293, n294, n295, n296,
         n297, n298, n299, n300, n301, n303, n304, n305, n310, n312, n313;
  assign \r6/N1  = r;

  DFFSX1 \r4/out_reg[0]  ( .D(n53), .CK(ck), .SN(n17), .Q(n279), .QN(n310) );
  DFFSX1 \r6/out_reg[0]  ( .D(n51), .CK(ck), .SN(n17), .QN(\r6_out[0] ) );
  DFFSX1 \r3/out_reg[0]  ( .D(n54), .CK(ck), .SN(n17), .QN(\r3_out[0] ) );
  DFFSX1 \r5/out_reg[0]  ( .D(n52), .CK(ck), .SN(n17), .QN(\r5_out[0] ) );
  DFFSX1 \r2/out_reg[0]  ( .D(n55), .CK(ck), .SN(n17), .QN(\r2_out[0] ) );
  AOI22XL U196 ( .A0(n299), .A1(\r2_out[0] ), .B0(\r3_out[0] ), .B1(n300), .Y(
        n298) );
  OAI21XL U195 ( .A0(n279), .A1(n297), .B0(n298), .Y(n296) );
  NAND2X1 U207 ( .A(loadIn), .B(newVal[0]), .Y(n301) );
  NOR2X1 U206 ( .A(clear), .B(n301), .Y(n292) );
  INVX1 U212 ( .A(loadIn), .Y(n305) );
  NAND2X1 U211 ( .A(shiftOut), .B(n305), .Y(n297) );
  NOR2X1 U200 ( .A(clear), .B(n297), .Y(n293) );
  OAI22X1 U210 ( .A0(n305), .A1(newVal[0]), .B0(shiftOut), .B1(loadIn), .Y(
        n300) );
  NOR2BX1 U201 ( .AN(n300), .B(clear), .Y(n294) );
  AOI21X1 U209 ( .A0(n312), .A1(n300), .B0(clear), .Y(n304) );
  INVX1 U205 ( .A(clear), .Y(n295) );
  INVX1 U197 ( .A(n301), .Y(n299) );
  NAND2X1 U194 ( .A(n295), .B(n296), .Y(n54) );
  AND4XL U204 ( .A(\r6_out[0] ), .B(n295), .C(n301), .D(n297), .Y(n303) );
  AOI222XL U198 ( .A0(n310), .A1(n294), .B0(\r5_out[0] ), .B1(n293), .C0(n292), 
        .C1(\r3_out[0] ), .Y(n53) );
  AOI222XL U199 ( .A0(n310), .A1(n292), .B0(\r5_out[0] ), .B1(n294), .C0(
        \r6_out[0] ), .C1(n293), .Y(n52) );
  AOI21XL U203 ( .A0(n292), .A1(\r5_out[0] ), .B0(n303), .Y(n51) );
  INVX1 U213 ( .A(\r6/N1 ), .Y(n17) );
  DFFSHQX4 \r1/out_reg[0]  ( .D(n50), .CK(ck), .SN(n17), .Q(n43) );
  CLKINVXL U214 ( .A(n43), .Y(n313) );
  INVXL U215 ( .A(n43), .Y(top[0]) );
  AOI222XL U216 ( .A0(n313), .A1(n292), .B0(n293), .B1(\r3_out[0] ), .C0(n294), 
        .C1(\r2_out[0] ), .Y(n55) );
  INVX1 U217 ( .A(n313), .Y(n312) );
  OAI21XL U218 ( .A0(\r2_out[0] ), .A1(n297), .B0(n304), .Y(n50) );
endmodule

