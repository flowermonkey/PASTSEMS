
module priQueue ( newVal, ck, r, clear, loadIn, shiftOut, top );
  input [0:0] newVal;
  output [0:0] top;
  input ck, r, clear, loadIn, shiftOut;
  wire   \r2_out[0] , \r3_out[0] , \r4_out[0] , \r5_out[0] , \r6_out[0] ,
         \r6/N1 , n17, n49, n50, n51, n52, n53, n54, n114, n115, n116, n117,
         n118, n119, n120, n121, n122, n123, n124, n125, n126, n128, n134;
  assign \r6/N1  = r;

  DFFSX1 \r2/out_reg[0]  ( .D(n54), .CK(ck), .SN(n17), .Q(n134), .QN(
        \r2_out[0] ) );
  DFFSX1 \r3/out_reg[0]  ( .D(n53), .CK(ck), .SN(n17), .QN(\r3_out[0] ) );
  DFFSX1 \r4/out_reg[0]  ( .D(n52), .CK(ck), .SN(n17), .QN(\r4_out[0] ) );
  DFFSX1 \r5/out_reg[0]  ( .D(n51), .CK(ck), .SN(n17), .QN(\r5_out[0] ) );
  DFFSX1 \r1/out_reg[0]  ( .D(n49), .CK(ck), .SN(n17), .QN(top[0]) );
  DFFSX1 \r6/out_reg[0]  ( .D(n50), .CK(ck), .SN(n17), .QN(\r6_out[0] ) );
  OAI21XL U80 ( .A0(top[0]), .A1(n122), .B0(n126), .Y(n49) );
  AOI2BB2XL U76 ( .B0(n123), .B1(\r6_out[0] ), .A0N(clear), .A1N(n124), .Y(n50) );
  INVX1 U86 ( .A(n123), .Y(n122) );
  OR2XL U73 ( .A(clear), .B(n120), .Y(n51) );
  OR2XL U67 ( .A(clear), .B(n114), .Y(n54) );
  OR2XL U71 ( .A(clear), .B(n119), .Y(n52) );
  OR2XL U69 ( .A(clear), .B(n118), .Y(n53) );
  NOR2X1 U79 ( .A(newVal[0]), .B(n121), .Y(n125) );
  AOI22XL U77 ( .A0(\r6_out[0] ), .A1(n125), .B0(n116), .B1(\r5_out[0] ), .Y(
        n124) );
  INVX1 U88 ( .A(\r6/N1 ), .Y(n17) );
  AND2X2 U78 ( .A(newVal[0]), .B(loadIn), .Y(n116) );
  NOR3XL U82 ( .A(newVal[0]), .B(top[0]), .C(n121), .Y(n128) );
  AOI211XL U81 ( .A0(n117), .A1(n134), .B0(clear), .C0(n128), .Y(n126) );
  AOI222X1 U74 ( .A0(n115), .A1(\r5_out[0] ), .B0(n116), .B1(\r4_out[0] ), 
        .C0(n117), .C1(\r6_out[0] ), .Y(n120) );
  AOI222X1 U68 ( .A0(n115), .A1(\r2_out[0] ), .B0(n116), .B1(top[0]), .C0(n117), .C1(\r3_out[0] ), .Y(n114) );
  AOI222X1 U70 ( .A0(n115), .A1(\r3_out[0] ), .B0(n116), .B1(\r2_out[0] ), 
        .C0(n117), .C1(\r4_out[0] ), .Y(n118) );
  AOI222X1 U72 ( .A0(n115), .A1(\r4_out[0] ), .B0(n116), .B1(\r3_out[0] ), 
        .C0(n117), .C1(\r5_out[0] ), .Y(n119) );
  NOR3X1 U89 ( .A(clear), .B(loadIn), .C(shiftOut), .Y(n123) );
  INVX1 U90 ( .A(loadIn), .Y(n121) );
  OAI21XL U91 ( .A0(newVal[0]), .A1(n121), .B0(n122), .Y(n115) );
  NOR2X1 U92 ( .A(loadIn), .B(n123), .Y(n117) );
endmodule

