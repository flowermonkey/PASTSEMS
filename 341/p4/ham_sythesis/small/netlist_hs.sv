
module ham_decoder ( message, correctMessage );
  input [6:0] message;
  output [6:0] correctMessage;
  wire   n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n119,
         n120, n121, n122, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n138, n140, n141, n142, n143, n145, n146,
         n147, n148, n149, n150;

  OAI21XL U113 ( .A0(n131), .A1(n135), .B0(n136), .Y(n134) );
  NAND2XL U102 ( .A(n109), .B(n115), .Y(n120) );
  AOI22XL U123 ( .A0(message[0]), .A1(n125), .B0(message[3]), .B1(n122), .Y(
        n141) );
  NOR2XL U119 ( .A(n130), .B(n122), .Y(n138) );
  AOI22XL U118 ( .A0(message[2]), .A1(n138), .B0(message[6]), .B1(n108), .Y(
        n135) );
  AOI33XL U114 ( .A0(message[5]), .A1(n113), .A2(n130), .B0(n122), .B1(n125), 
        .B2(message[1]), .Y(n136) );
  NOR2XL U101 ( .A(n127), .B(n120), .Y(n121) );
  AOI21XL U89 ( .A0(n108), .A1(n109), .B0(message[6]), .Y(n111) );
  AOI31XL U88 ( .A0(n108), .A1(n109), .A2(n110), .B0(n111), .Y(
        correctMessage[6]) );
  AOI21XL U105 ( .A0(n113), .A1(n115), .B0(message[1]), .Y(n129) );
  AOI31XL U104 ( .A0(n113), .A1(n115), .A2(n110), .B0(n129), .Y(
        correctMessage[1]) );
  INVXL U95 ( .A(n109), .Y(n116) );
  AOI21XL U94 ( .A0(n108), .A1(n116), .B0(message[4]), .Y(n117) );
  AOI31XL U93 ( .A0(n110), .A1(n116), .A2(n108), .B0(n117), .Y(
        correctMessage[4]) );
  AOI21XL U91 ( .A0(n113), .A1(n112), .B0(message[5]), .Y(n114) );
  AOI31XL U90 ( .A0(n110), .A1(n112), .A2(n113), .B0(n114), .Y(
        correctMessage[5]) );
  AOI21XL U108 ( .A0(n128), .A1(n125), .B0(message[0]), .Y(n132) );
  AOI31XL U107 ( .A0(n110), .A1(n128), .A2(n125), .B0(n132), .Y(
        correctMessage[0]) );
  AOI2BB2X1 U127 ( .B0(message[4]), .B1(message[6]), .A0N(message[6]), .A1N(
        message[4]), .Y(n143) );
  AOI2BB2X1 U128 ( .B0(message[5]), .B1(message[3]), .A0N(message[3]), .A1N(
        message[5]), .Y(n142) );
  XOR2X1 U126 ( .A(n142), .B(n143), .Y(n130) );
  INVX1 U117 ( .A(n122), .Y(n119) );
  XNOR2X1 U106 ( .A(n130), .B(n131), .Y(n115) );
  INVX1 U110 ( .A(n131), .Y(n126) );
  INVX1 U92 ( .A(n115), .Y(n112) );
  NOR2X1 U109 ( .A(n126), .B(n122), .Y(n128) );
  NOR2X1 U124 ( .A(n122), .B(n125), .Y(n108) );
  OAI2BB1X1 U122 ( .A0N(message[4]), .A1N(n108), .B0(n141), .Y(n133) );
  NOR2X1 U103 ( .A(n113), .B(n128), .Y(n109) );
  AOI21X1 U112 ( .A0(n133), .A1(n131), .B0(n134), .Y(n127) );
  INVX1 U111 ( .A(n127), .Y(n110) );
  AOI2BB2X1 U132 ( .B0(message[2]), .B1(message[6]), .A0N(message[6]), .A1N(
        message[2]), .Y(n140) );
  NOR2X1 U133 ( .A(n119), .B(n131), .Y(n113) );
  XOR2X1 U134 ( .A(message[1]), .B(n140), .Y(n145) );
  NAND2X1 U135 ( .A(n145), .B(message[5]), .Y(n146) );
  OAI21XL U136 ( .A0(n145), .A1(message[5]), .B0(n146), .Y(n131) );
  XOR2X1 U137 ( .A(message[0]), .B(n140), .Y(n147) );
  NAND2X1 U138 ( .A(n147), .B(message[4]), .Y(n148) );
  OAI21XL U139 ( .A0(n147), .A1(message[4]), .B0(n148), .Y(n122) );
  AOI31X1 U140 ( .A0(n119), .A1(n125), .A2(n126), .B0(message[2]), .Y(n149) );
  AOI21X1 U141 ( .A0(n119), .A1(n121), .B0(n149), .Y(correctMessage[2]) );
  AOI2BB1X1 U142 ( .A0N(n120), .A1N(n119), .B0(message[3]), .Y(n150) );
  AOI21X1 U143 ( .A0(n122), .A1(n121), .B0(n150), .Y(correctMessage[3]) );
  INVX1 U144 ( .A(n130), .Y(n125) );
endmodule

