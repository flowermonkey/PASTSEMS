
module ham_decoder ( message, correctMessage );
  input [6:0] message;
  output [6:0] correctMessage;
  wire   n270, n271, n272, n273, n274, n275, n276, n277, n278, n279, n280,
         n281, n282, n283, n284, n285, n286, n287, n288, n289, n290, n291,
         n292, n293, n294, n295, n296;

  OAI21XL U144 ( .A0(n285), .A1(n288), .B0(message[1]), .Y(n277) );
  NOR2X2 U145 ( .A(n271), .B(n294), .Y(n270) );
  NOR2X2 U146 ( .A(n271), .B(n294), .Y(n272) );
  XNOR3X4 U147 ( .A(message[2]), .B(message[1]), .C(n273), .Y(n271) );
  NAND2X2 U148 ( .A(n271), .B(n292), .Y(n285) );
  NAND2X2 U149 ( .A(n270), .B(n286), .Y(n274) );
  NAND2X2 U150 ( .A(n272), .B(n295), .Y(n275) );
  XNOR2X4 U151 ( .A(message[6]), .B(message[5]), .Y(n273) );
  XOR2X4 U152 ( .A(message[6]), .B(message[5]), .Y(n289) );
  XNOR3X2 U153 ( .A(message[6]), .B(message[4]), .C(n293), .Y(n292) );
  OAI31XL U154 ( .A0(n285), .A1(message[1]), .A2(n288), .B0(n277), .Y(
        correctMessage[1]) );
  NOR2X2 U155 ( .A(n291), .B(n294), .Y(n296) );
  XOR2X1 U156 ( .A(n274), .B(n287), .Y(correctMessage[4]) );
  INVX1 U157 ( .A(message[0]), .Y(n276) );
  XOR2X1 U158 ( .A(n275), .B(n276), .Y(correctMessage[0]) );
  NAND2X1 U159 ( .A(n295), .B(n296), .Y(n278) );
  NAND2X1 U160 ( .A(message[2]), .B(n278), .Y(n279) );
  OAI21XL U161 ( .A0(message[2]), .A1(n278), .B0(n279), .Y(correctMessage[2])
         );
  NAND3XL U162 ( .A(n291), .B(n288), .C(n292), .Y(n280) );
  NAND2X1 U163 ( .A(n280), .B(message[3]), .Y(n281) );
  OAI21XL U164 ( .A0(message[3]), .A1(n280), .B0(n281), .Y(correctMessage[3])
         );
  OAI21XL U165 ( .A0(n285), .A1(n295), .B0(message[5]), .Y(n282) );
  OAI31XL U166 ( .A0(n285), .A1(message[5]), .A2(n295), .B0(n282), .Y(
        correctMessage[5]) );
  NAND2X1 U167 ( .A(n286), .B(n296), .Y(n283) );
  NAND2X1 U168 ( .A(n283), .B(message[6]), .Y(n284) );
  OAI21XL U169 ( .A0(message[6]), .A1(n283), .B0(n284), .Y(correctMessage[6])
         );
  XNOR3X4 U170 ( .A(n287), .B(message[3]), .C(n289), .Y(n286) );
  INVX8 U171 ( .A(message[4]), .Y(n287) );
  XNOR3X4 U172 ( .A(n287), .B(message[3]), .C(n289), .Y(n288) );
  XNOR3X4 U173 ( .A(message[2]), .B(message[1]), .C(n289), .Y(n291) );
  XNOR3X4 U174 ( .A(message[6]), .B(message[4]), .C(n290), .Y(n294) );
  XOR2X4 U175 ( .A(message[0]), .B(message[2]), .Y(n290) );
  XNOR3X4 U176 ( .A(message[4]), .B(message[3]), .C(n289), .Y(n295) );
  XOR2X4 U177 ( .A(message[0]), .B(message[2]), .Y(n293) );
endmodule

