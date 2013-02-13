
module ham_decoder ( message, correctMessage );
  input [6:0] message;
  output [6:0] correctMessage;
  wire   n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51,
         n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93,
         n94, n95, n96;

  NOR2X2 U44 ( .A(n38), .B(n66), .Y(n53) );
  MXI2XL U45 ( .A(n81), .B(n80), .S0(n79), .Y(correctMessage[1]) );
  XOR3X4 U46 ( .A(message[1]), .B(message[5]), .C(n60), .Y(n38) );
  NOR2X4 U47 ( .A(n58), .B(n59), .Y(n39) );
  NOR2X2 U48 ( .A(n39), .B(n72), .Y(n40) );
  NAND2XL U49 ( .A(n63), .B(n39), .Y(n89) );
  NOR2BX2 U50 ( .AN(n39), .B(n63), .Y(n61) );
  NAND2X1 U51 ( .A(n40), .B(n63), .Y(n41) );
  NAND2X1 U52 ( .A(n40), .B(n45), .Y(n44) );
  MXI2XL U53 ( .A(n81), .B(n78), .S0(n41), .Y(correctMessage[0]) );
  MXI2XL U54 ( .A(n42), .B(n43), .S0(n44), .Y(correctMessage[2]) );
  NAND2XL U55 ( .A(n68), .B(n69), .Y(n45) );
  INVX1 U56 ( .A(message[2]), .Y(n43) );
  INVXL U57 ( .A(n82), .Y(n42) );
  INVX4 U58 ( .A(n69), .Y(n72) );
  INVX8 U59 ( .A(message[0]), .Y(n78) );
  XOR3X4 U60 ( .A(message[1]), .B(message[5]), .C(n47), .Y(n48) );
  XNOR2X4 U61 ( .A(message[1]), .B(message[2]), .Y(n83) );
  MXI2X4 U62 ( .A(n76), .B(message[0]), .S0(n49), .Y(n82) );
  XOR2X4 U63 ( .A(message[2]), .B(message[6]), .Y(n47) );
  XOR2X4 U64 ( .A(message[2]), .B(message[6]), .Y(n46) );
  XNOR3X4 U65 ( .A(message[1]), .B(message[5]), .C(n70), .Y(n49) );
  NOR2X4 U66 ( .A(n66), .B(n50), .Y(n63) );
  XOR3X4 U67 ( .A(message[1]), .B(message[5]), .C(n46), .Y(n50) );
  NOR2X1 U68 ( .A(n68), .B(n69), .Y(n91) );
  NAND2X4 U69 ( .A(n96), .B(message[2]), .Y(n73) );
  INVX8 U70 ( .A(message[6]), .Y(n96) );
  XOR2X4 U71 ( .A(message[2]), .B(message[6]), .Y(n51) );
  XOR2X4 U72 ( .A(message[2]), .B(message[6]), .Y(n52) );
  MXI2XL U73 ( .A(n54), .B(n94), .S0(n55), .Y(correctMessage[3]) );
  XNOR3X2 U74 ( .A(message[4]), .B(message[3]), .C(n77), .Y(n56) );
  NOR3X4 U75 ( .A(n53), .B(n56), .C(n48), .Y(n55) );
  INVX1 U76 ( .A(message[3]), .Y(n54) );
  NAND2BX1 U77 ( .AN(n95), .B(n61), .Y(n57) );
  OAI21XL U78 ( .A0(n96), .A1(n61), .B0(n57), .Y(correctMessage[6]) );
  XOR2X4 U79 ( .A(message[2]), .B(message[6]), .Y(n60) );
  XNOR3X4 U80 ( .A(message[4]), .B(message[0]), .C(n52), .Y(n59) );
  XNOR3X4 U81 ( .A(message[4]), .B(message[3]), .C(n77), .Y(n58) );
  XOR2X4 U82 ( .A(message[6]), .B(message[5]), .Y(n62) );
  OAI2BB1X2 U83 ( .A0N(message[1]), .A1N(n72), .B0(n82), .Y(n81) );
  XOR3X4 U84 ( .A(n75), .B(n74), .C(n73), .Y(n76) );
  XOR2X4 U85 ( .A(message[2]), .B(message[6]), .Y(n65) );
  XOR2X4 U86 ( .A(message[2]), .B(message[6]), .Y(n64) );
  XNOR3X4 U87 ( .A(message[4]), .B(message[0]), .C(n51), .Y(n66) );
  NOR2BX4 U88 ( .AN(message[2]), .B(message[0]), .Y(n74) );
  INVXL U89 ( .A(n71), .Y(n67) );
  XOR3X2 U90 ( .A(message[4]), .B(message[3]), .C(n62), .Y(n71) );
  XNOR3X4 U91 ( .A(message[1]), .B(message[5]), .C(n65), .Y(n68) );
  NAND2X4 U92 ( .A(n90), .B(message[2]), .Y(n75) );
  NAND2X1 U93 ( .A(n90), .B(n96), .Y(n84) );
  INVX8 U94 ( .A(message[4]), .Y(n90) );
  NAND2X1 U95 ( .A(n67), .B(n91), .Y(n79) );
  XNOR3X4 U96 ( .A(message[4]), .B(n78), .C(n64), .Y(n69) );
  XOR2X4 U97 ( .A(message[2]), .B(message[6]), .Y(n70) );
  XOR2X4 U98 ( .A(message[6]), .B(message[5]), .Y(n77) );
  MX2X2 U99 ( .A(message[5]), .B(message[3]), .S0(n68), .Y(n94) );
  MXI2XL U100 ( .A(n95), .B(n90), .S0(n89), .Y(correctMessage[4]) );
  MXI2XL U101 ( .A(n94), .B(n93), .S0(n92), .Y(correctMessage[5]) );
  NAND3X1 U102 ( .A(n88), .B(n87), .C(n86), .Y(n95) );
  NAND2X1 U103 ( .A(message[4]), .B(message[6]), .Y(n86) );
  NAND3X1 U104 ( .A(n85), .B(message[5]), .C(n84), .Y(n87) );
  INVX1 U105 ( .A(n83), .Y(n85) );
  NAND3X1 U106 ( .A(n83), .B(n84), .C(n93), .Y(n88) );
  INVX1 U107 ( .A(message[1]), .Y(n80) );
  NAND2X1 U108 ( .A(n71), .B(n91), .Y(n92) );
  INVX1 U109 ( .A(message[5]), .Y(n93) );
endmodule

