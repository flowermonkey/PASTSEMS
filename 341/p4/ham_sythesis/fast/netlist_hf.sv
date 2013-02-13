
module ham_decoder ( message, correctMessage );
  input [6:0] message;
  output [6:0] correctMessage;
  wire   N32, n3, n4, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n19, n20,
         n21, n22, n23, n24, n25, n26, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37;
  assign correctMessage[0] = N32;

  AOI2BB2XL U32 ( .B0(message[6]), .B1(message[4]), .A0N(message[4]), .A1N(
        message[6]), .Y(n29) );
  AOI2BB2XL U31 ( .B0(message[2]), .B1(message[0]), .A0N(message[0]), .A1N(
        message[2]), .Y(n30) );
  XOR2XL U30 ( .A(n29), .B(n30), .Y(n3) );
  OAI2BB2XL U29 ( .B0(message[5]), .B1(message[3]), .A0N(message[5]), .A1N(
        message[3]), .Y(n28) );
  XNOR2XL U28 ( .A(n28), .B(n29), .Y(n7) );
  OAI2BB2XL U38 ( .B0(message[5]), .B1(message[6]), .A0N(message[5]), .A1N(
        message[6]), .Y(n31) );
  INVXL U37 ( .A(message[1]), .Y(n25) );
  INVXL U36 ( .A(message[2]), .Y(n22) );
  AOI22XL U35 ( .A0(message[2]), .A1(message[1]), .B0(n25), .B1(n22), .Y(n32)
         );
  XNOR2XL U34 ( .A(n31), .B(n32), .Y(n16) );
  NAND2XL U11 ( .A(n7), .B(n16), .Y(n12) );
  INVXL U7 ( .A(n12), .Y(n4) );
  INVXL U33 ( .A(n16), .Y(n19) );
  NAND2XL U16 ( .A(n7), .B(n19), .Y(n8) );
  NOR2XL U24 ( .A(n7), .B(n19), .Y(n23) );
  INVXL U23 ( .A(n3), .Y(n10) );
  INVXL U27 ( .A(n7), .Y(n15) );
  AOI31XL U22 ( .A0(n16), .A1(n10), .A2(n15), .B0(n25), .Y(n26) );
  AOI31XL U21 ( .A0(n23), .A1(n10), .A2(n25), .B0(n26), .Y(n24) );
  INVXL U20 ( .A(n24), .Y(correctMessage[1]) );
  NOR2XL U15 ( .A(n3), .B(n8), .Y(n14) );
  NOR2XL U10 ( .A(n14), .B(n15), .Y(n9) );
  AOI2BB1X1 U9 ( .A0N(n8), .A1N(n10), .B0(message[4]), .Y(n13) );
  AOI31XL U8 ( .A0(message[4]), .A1(n12), .A2(n9), .B0(n13), .Y(
        correctMessage[4]) );
  AOI21XL U6 ( .A0(n10), .A1(n4), .B0(message[5]), .Y(n11) );
  AOI31XL U5 ( .A0(n9), .A1(message[5]), .A2(n10), .B0(n11), .Y(
        correctMessage[5]) );
  NOR3XL U19 ( .A(n7), .B(n10), .C(n19), .Y(n20) );
  NAND2XL U18 ( .A(n3), .B(n23), .Y(n21) );
  AOI22XL U17 ( .A0(message[2]), .A1(n20), .B0(n21), .B1(n22), .Y(
        correctMessage[2]) );
  NAND3X1 U39 ( .A(n19), .B(n15), .C(n3), .Y(n33) );
  NAND2X1 U40 ( .A(n33), .B(message[0]), .Y(n34) );
  OAI21XL U41 ( .A0(message[0]), .A1(n33), .B0(n34), .Y(N32) );
  NOR3X1 U42 ( .A(n3), .B(n16), .C(n15), .Y(n35) );
  AOI2BB2X1 U43 ( .B0(message[3]), .B1(n35), .A0N(n14), .A1N(message[3]), .Y(
        correctMessage[3]) );
  AND2X1 U44 ( .A(n7), .B(n8), .Y(n36) );
  AOI21X1 U45 ( .A0(n3), .A1(n4), .B0(message[6]), .Y(n37) );
  AOI31X1 U46 ( .A0(n36), .A1(message[6]), .A2(n3), .B0(n37), .Y(
        correctMessage[6]) );
endmodule

