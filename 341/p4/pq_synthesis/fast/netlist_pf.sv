
module priQueue ( newVal, ck, r, clear, loadIn, shiftOut, top );
  input [0:0] newVal;
  output [0:0] top;
  input ck, r, clear, loadIn, shiftOut;
  wire   \r2_out[0] , \r3_out[0] , \m2_out[0] , \r4_out[0] , \m3_out[0] ,
         \r5_out[0] , \m4_out[0] , \r6_out[0] , \m5_out[0] , \sel6[1] , load,
         _5_net_, n2, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15,
         n16, n17, n18, n19, n20, \r1/n3 , n21, n22, n23, n24, n25, n26, n27,
         n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
         n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57;
  wire   [1:0] sel2;
  wire   [1:0] sel3;
  wire   [1:0] sel4;
  wire   [1:0] sel5;

  DFFRHQX4 \r1/out_reg[0]  ( .D(\r1/n3 ), .CK(ck), .RN(_5_net_), .Q(top[0]) );
  DFFRHQX1 \r6/out_reg[0]  ( .D(n45), .CK(ck), .RN(_5_net_), .Q(\r6_out[0] )
         );
  DFFRHQX1 \r3/out_reg[0]  ( .D(n40), .CK(ck), .RN(_5_net_), .Q(\r3_out[0] )
         );
  DFFRHQX1 \r5/out_reg[0]  ( .D(n44), .CK(ck), .RN(_5_net_), .Q(\r5_out[0] )
         );
  DFFRHQX1 \r4/out_reg[0]  ( .D(n42), .CK(ck), .RN(_5_net_), .Q(\r4_out[0] )
         );
  DFFRHQX1 \r2/out_reg[0]  ( .D(n38), .CK(ck), .RN(_5_net_), .Q(\r2_out[0] )
         );
  OAI21XL U24 ( .A0(\r4_out[0] ), .A1(n11), .B0(n20), .Y(n14) );
  NAND4BXL U18 ( .AN(\r3_out[0] ), .B(n36), .C(newVal[0]), .D(\r2_out[0] ), 
        .Y(n17) );
  OAI21XL U22 ( .A0(\r6_out[0] ), .A1(n11), .B0(n13), .Y(n18) );
  OAI221XL \m4/U2  ( .A0(n54), .A1(\r4_out[0] ), .B0(sel4[0]), .B1(\r5_out[0] ), .C0(sel4[1]), .Y(n53) );
  OAI21XL \m4/U1  ( .A0(sel4[1]), .A1(n52), .B0(n53), .Y(\m4_out[0] ) );
  OAI21XL U7 ( .A0(n9), .A1(n10), .B0(n7), .Y(n4) );
  OAI21XL U6 ( .A0(n2), .A1(n8), .B0(n4), .Y(sel5[0]) );
  OAI221XL \m5/U2  ( .A0(n57), .A1(\r5_out[0] ), .B0(sel5[0]), .B1(\r6_out[0] ), .C0(sel5[1]), .Y(n56) );
  OAI21XL \m5/U1  ( .A0(sel5[1]), .A1(n55), .B0(n56), .Y(\m5_out[0] ) );
  OAI221XL \m2/U2  ( .A0(n48), .A1(\r2_out[0] ), .B0(sel2[0]), .B1(\r3_out[0] ), .C0(sel2[1]), .Y(n47) );
  OAI21XL \m2/U1  ( .A0(sel2[1]), .A1(n46), .B0(n47), .Y(\m2_out[0] ) );
  OAI221XL \m3/U2  ( .A0(n51), .A1(\r3_out[0] ), .B0(sel3[0]), .B1(\r4_out[0] ), .C0(sel3[1]), .Y(n50) );
  OAI21XL \m3/U1  ( .A0(sel3[1]), .A1(n49), .B0(n50), .Y(\m3_out[0] ) );
  INVX1 U33 ( .A(newVal[0]), .Y(n11) );
  AOI21X1 U30 ( .A0(n36), .A1(\r2_out[0] ), .B0(n11), .Y(n19) );
  AOI2BB1XL U25 ( .A0N(\r3_out[0] ), .A1N(n11), .B0(n19), .Y(n20) );
  NOR3BX1 U29 ( .AN(shiftOut), .B(clear), .C(loadIn), .Y(n2) );
  INVX1 U27 ( .A(n2), .Y(n7) );
  NAND2X1 U10 ( .A(n14), .B(n7), .Y(sel4[1]) );
  INVX1 U13 ( .A(n14), .Y(n5) );
  OR2X1 U32 ( .A(n36), .B(n11), .Y(n15) );
  NAND3BX1 U31 ( .AN(\r2_out[0] ), .B(newVal[0]), .C(n15), .Y(n16) );
  NOR2X1 U26 ( .A(\r5_out[0] ), .B(n11), .Y(n6) );
  NOR2X1 U23 ( .A(n6), .B(n14), .Y(n13) );
  NAND4X1 U12 ( .A(n15), .B(n16), .C(n17), .D(n18), .Y(n10) );
  AOI2BB1X1 U11 ( .A0N(n5), .A1N(n10), .B0(n2), .Y(sel4[0]) );
  INVX1 \m4/U4  ( .A(sel4[0]), .Y(n54) );
  OAI22X1 \m4/U3  ( .A0(sel4[0]), .A1(newVal[0]), .B0(n54), .B1(\r3_out[0] ), 
        .Y(n52) );
  MXI2X1 \r4/U3  ( .A(\r4_out[0] ), .B(\m4_out[0] ), .S0(load), .Y(n41) );
  NOR2X1 \r4/U2  ( .A(clear), .B(n41), .Y(n42) );
  INVX1 U9 ( .A(n13), .Y(n8) );
  NAND2X1 U5 ( .A(n7), .B(n8), .Y(sel5[1]) );
  INVX1 U20 ( .A(n20), .Y(n12) );
  NOR3X1 U8 ( .A(\r4_out[0] ), .B(n11), .C(n12), .Y(n9) );
  INVX1 \m5/U4  ( .A(sel5[0]), .Y(n57) );
  OAI22X1 \m5/U3  ( .A0(sel5[0]), .A1(newVal[0]), .B0(n57), .B1(\r4_out[0] ), 
        .Y(n55) );
  MXI2X1 \r5/U3  ( .A(\r5_out[0] ), .B(\m5_out[0] ), .S0(load), .Y(n43) );
  NOR2X1 \r5/U2  ( .A(clear), .B(n43), .Y(n44) );
  NAND2X1 U21 ( .A(n7), .B(n18), .Y(\sel6[1] ) );
  NAND2BX1 U19 ( .AN(\sel6[1] ), .B(n12), .Y(sel3[1]) );
  NAND2BX1 U17 ( .AN(sel3[1]), .B(n17), .Y(sel2[1]) );
  AOI21X1 U15 ( .A0(n15), .A1(n19), .B0(n2), .Y(sel2[0]) );
  INVX1 \m2/U4  ( .A(sel2[0]), .Y(n48) );
  OAI22X1 \m2/U3  ( .A0(sel2[0]), .A1(newVal[0]), .B0(n48), .B1(n36), .Y(n46)
         );
  MXI2X1 \r2/U3  ( .A(\r2_out[0] ), .B(\m2_out[0] ), .S0(load), .Y(n37) );
  NOR2X1 \r2/U2  ( .A(clear), .B(n37), .Y(n38) );
  AOI31X1 U14 ( .A0(n12), .A1(n15), .A2(n16), .B0(n2), .Y(sel3[0]) );
  INVX1 \m3/U4  ( .A(sel3[0]), .Y(n51) );
  OAI22X1 \m3/U3  ( .A0(sel3[0]), .A1(newVal[0]), .B0(n51), .B1(\r2_out[0] ), 
        .Y(n49) );
  MXI2X1 \r3/U3  ( .A(\r3_out[0] ), .B(\m3_out[0] ), .S0(load), .Y(n39) );
  NOR2X1 \r3/U2  ( .A(clear), .B(n39), .Y(n40) );
  INVX1 U35 ( .A(r), .Y(_5_net_) );
  OR2X1 U34 ( .A(shiftOut), .B(loadIn), .Y(load) );
  NAND2X1 U36 ( .A(n6), .B(n5), .Y(n21) );
  OAI21XL U37 ( .A0(n2), .A1(n21), .B0(n4), .Y(n22) );
  INVXL U38 ( .A(\r5_out[0] ), .Y(n23) );
  NOR2X1 U39 ( .A(n22), .B(newVal[0]), .Y(n24) );
  AOI211X1 U40 ( .A0(n23), .A1(n22), .B0(\sel6[1] ), .C0(n24), .Y(n25) );
  AOI31X1 U41 ( .A0(\sel6[1] ), .A1(\r6_out[0] ), .A2(n22), .B0(n25), .Y(n26)
         );
  NOR2X1 U42 ( .A(\r6_out[0] ), .B(load), .Y(n27) );
  AOI211X1 U43 ( .A0(load), .A1(n26), .B0(clear), .C0(n27), .Y(n45) );
  NOR2BX1 U44 ( .AN(n16), .B(sel2[1]), .Y(n28) );
  AOI21X1 U45 ( .A0(n16), .A1(n19), .B0(n2), .Y(n29) );
  INVXL U46 ( .A(n36), .Y(n30) );
  INVXL U47 ( .A(n29), .Y(n31) );
  NOR2X1 U48 ( .A(\r2_out[0] ), .B(n29), .Y(n32) );
  AOI211X1 U49 ( .A0(n29), .A1(n30), .B0(n28), .C0(n32), .Y(n33) );
  AOI31X1 U50 ( .A0(n28), .A1(newVal[0]), .A2(n31), .B0(n33), .Y(n34) );
  NOR2X1 U51 ( .A(n36), .B(load), .Y(n35) );
  AOI211X1 U52 ( .A0(load), .A1(n34), .B0(clear), .C0(n35), .Y(\r1/n3 ) );
  DLY1X1 U53 ( .A(top[0]), .Y(n36) );
endmodule

