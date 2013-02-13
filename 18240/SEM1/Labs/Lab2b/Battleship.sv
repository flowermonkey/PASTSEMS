module finalTop;
//input logic
  logic[3:0]x;
  logic[3:0]y;
  logic big;
  logic [1:0] bigleft;
  logic scorethis;
  
//  final output logic  
  logic hit;
  logic nearmiss;
  logic miss;
  logic [7:0] numhits;
  logic [4:0] biggestshiphit;
  logic somethingiswrong;

  //top t(x,y,big,bigleft,scorethis, hit,nearmiss,miss,numhits,biggestshiphit,somethingiswrong);
  //finalTopTester test(x,y,big,bigleft,scorethis, hit,nearmiss,miss,numhits,biggestshiphit,somethingiswrong);
  
endmodule

module finalTopTester(
  output
  logic[3:0]x,
  logic[3:0]y,
  logic big,
  logic [1:0] bigleft,
  logic scorethis,

  input 
  logic hit,
  logic nearmiss,
  logic miss,
  logic [7:0] numhits,
  logic [4:0] biggestshiphit,
  logic somethingiswrong);
  
  logic [3:0] i;
  logic [3:0]j;
  logic k;
  
  //x=0; y=0; bigleft=0; big=0; scorethis=0;    
initial begin
  $monitor($time,, 
  "(%d,%d), big=%b, bigleft=%d, scorethis=%b,--> hit=%b, nearmiss=%b,miss = %b, numhits=%b, biggestshiphit=%b, somethingiswrong=%b",
  x,y,big,bigleft,scorethis,hit,nearmiss,miss,numhits,biggestshiphit,somethingiswrong);

  x=0; y=0; bigleft=0; big=0; scorethis=0;  
  for (i=1;i<11;i++)begin
    for (j=1; j<11; j++)begin 
      #1 x=i; y=j; bigleft=3; big=1; scorethis=1;
    end
  end
  for (i=1;i<11;i++)begin
    for (j=1; j<11; j++)begin 
      #1 x=i; y=j; bigleft=3; big=0; scorethis=1;
    end
  end
 //display("");
#1 x=1; y=1; bigleft=2; big=1; scorethis=1;
#1 x=5; y=5; bigleft=1; big=1; scorethis=1;
#1 x=7; y=6; bigleft=0; big=1; scorethis=1;
#1 x=2; y=3; bigleft=0; big=0; scorethis=1;
#1 x=4; y=7; bigleft=1; big=1; scorethis=0;

//test cases for bad coordinate values
#1 x=12; y=12; bigleft=0; big=0; scorethis=1;
#1 x=9; y=14; bigleft=1; big=1; scorethis=0;
#1 x=12; y=2; bigleft=1; big=1; scorethis=0;
#1 x=12; y=2; bigleft=0; big=1; scorethis=0;
#1 x=12; y=12; bigleft=0; big=1; scorethis=0;

end
endmodule

module toptest; 
  logic[3:0]x;
  logic[3:0]y;
  logic big;
  logic [3:0]hit;
  logic nearmiss;
  logic miss;
  logic [4:0]rank;
  logic valid;
  logic [1:0]bigleft;
  logic bigbombpossible;
  logic validlocation;
  logic somethingiswrong;
//  PatrolShip p(.*);
//  testPatrol tp(.*);
//blockShip b(.*);
 //   testBlock p(.*);
//  SubShip sub(.*);
//  testSub t(.*);
//validLocation vl(.*);
//testvadLoc tvl(.*);
//BigBombPossible d(.*);
//testBigPoss b(.*);
somethingIsWrong sm(.*);
testsomethingiswrong tsm(.*);
endmodule

module top
(input logic[3:0]x,
  logic[3:0]y,
  logic big,
  logic [1:0] bigleft,
  logic scorethis,
  
  input clock,
  input reset,

  output logic hit,
  logic nearmiss,
  logic miss,
  logic [7:0] numhits,
  logic [4:0] biggestshiphit,
  logic [7:0] somethingiswrong2,
  
  output 	displayA, displayB, displayC, displayD,
  output [7:0] sevenSegmentDisplay

  
);

  //additional necessary output logic
  logic validloc;
  logic validbomb;

  //additional logic from boats
  //logic from PatrolShip
  logic [3:0]phit;
  logic pnearmiss;
  logic pmiss;
  //logic from SubShip
  logic [3:0]subhit;
  logic subnearmiss;
  logic submiss;

  //logic from block
  logic [3:0] blockhit;
  logic blocknearmiss;
  logic blockmiss;
  logic [4:0] blockrank;
  
  //logic for LEDhit
  logic [7:0] pledhit;
  logic [7:0] subledhit;
  logic [7:0] blockledhit;

  //extra additional logic
  logic somethingiswrong1;
  
  validLocation vL(validloc,x,y,scorethis);
  BigBombPossible bbp(validbomb,big,bigleft,scorethis);
  
  somethingIsWrong sW(somethingiswrong1,validbomb,validloc);
  
    //linked each individual boat module
  PatrolShip pS(phit,pnearmiss,pmiss,big,x,y);
  SubShip    sS(subhit,subnearmiss,submiss,big,x,y);
  blockShip  bS(blockhit,blocknearmiss,blockmiss,blockrank, big,x,y);
  
  
  //convert num hits into LED lights
  BCDtoLED pLED(pledhit, phit);
  BCDtoLED sLED(subledhit, subhit);
  BCDtoLED bLED(blockledhit,blockhit);
  
  
  //link everything to finalOutput
  finalOutput finalo(hit, nearmiss, miss, numhits, biggestshiphit, somethingiswrong,
                    phit, pnearmiss, pmiss, pledhit,
                    subhit,subnearmiss,submiss,subledhit,
                    blockhit,blocknearmiss,blockmiss, blockledhit,blockrank,
                    scorethis,somethingiswrong1);
  
//  logic [7:0]somethingiswrong2;
  always_comb begin
  if(somethingiswrong)begin
    somethingiswrong2 = 8'b0000_0000;
  end
  else begin
    somethingiswrong2 = 8'b1111_1111;
  end

  end  
   LEDController lc(.displayValuesA(numhits), .displayValuesB(8'b1111_1111),
		    .displayValuesC(8'b1111_1111), .displayValuesD(somethingiswrong2),
		    .clock(clock), .reset(reset),
		    .displayA(displayA), .displayB(displayB),
		    .displayC(displayC), .displayD(displayD),
		    .sevenSegmentDisplay(sevenSegmentDisplay) );
  
endmodule

module BCDtoLED
  (output		reg	[7:0]	led,
    input [3:0] 			bcd);

  always_comb
  case(bcd)
//    0: led = 8'b00000011;
    0: led = 8'b11111111;
    1: led = 8'b10011111;
    2: led = 8'b00100101;
    3: led = 8'b00001101;
    4: led = 8'b10011001;
    5: led = 8'b01001001; 
    6: led = 8'b01000001; 
    7: led = 8'b00011111; 
    8: led = 8'b00000001; 
    9: led = 8'b00011001; 
    default: led = 8'b11111111;
  endcase
endmodule

module finalOutput
  (output logic hit, nearmiss, miss, logic [7:0] numhits, logic [4:0] biggestshiphit, logic somethingiswrongout,  
    input logic [3:0]patrolhit, logic patrolnearmiss, logic patrolmiss, logic [7:0] pledhit,
          logic [3:0]subhit, logic subnearmiss, logic submiss, logic [7:0] subledhit,
          logic [3:0] blockhit, logic blocknearmiss, logic blockmiss, logic [7:0] blockledhit,logic [4:0] blockrank,
          logic scorethis,logic somethingiswrongin);

  always_comb begin
    //default everything as 0;
    hit = 1'b0;
    nearmiss = 1'b0;
    miss = 1'b0;
    numhits = 8'b0000_0000;
    biggestshiphit = 5'b00000;
    somethingiswrongout = somethingiswrongin;
         
    //only if something is not wrong and you want to score this, then do the following:
    if(scorethis && ~somethingiswrongin)begin
      somethingiswrongout = somethingiswrongin;
      if(blockhit >0)begin
        hit = 1'b1;
        biggestshiphit = blockrank;
        numhits = blockledhit;
      end
      else if(subhit >0) begin
        hit = 1'b1;
        biggestshiphit = 5'b00010;
        numhits = subledhit;
      end
      else if(patrolhit >0) begin
        hit = 1'b1;
        biggestshiphit = 5'b00001;
        numhits = pledhit;
      end
      else if(blocknearmiss >0)begin
        nearmiss = 1'b1;
      end
      else if(subnearmiss >0) begin
        nearmiss = 1'b1;
      end
      else if(patrolnearmiss >0) begin
        nearmiss = 1'b1;
      end
      else begin
        miss = 1'b1;
      end
    end
  end
endmodule



module validLocation
(output logic valid,
input logic [3:0] x, y, logic scorethis);
  always_comb begin
    if(scorethis)begin
    if(x>=1 && x<=10 && y>=1 && y<=10)begin
      valid = 1'b1;
    end
    else begin
      valid = 1'b0;
    end
    end
  end
endmodule

module testvadLoc
  (input logic valid,
output logic [3:0] x, y);
initial begin       
  $monitor($time,, "x=%d, y=%d, valid=%b", x,y,valid);
    x=0; y=0;
    #1 x=10; y=4;
    #1 x=11; y=8;
    #1 x=13; y=9;
    #1 x=5; y=5;
    end
  endmodule
  
module BigBombPossible
  (output logic valid,
  input logic big, logic [1:0] bigleft, logic scorethis);
  
  always_comb begin
    if(scorethis)begin
    if(big ==1&& bigleft ==0)begin
      valid = 1'b0;
    end
    else begin
      valid = 1'b1;
    end
  end
  end
endmodule

module testBigPoss
  (input logic valid,
  output logic big, logic [1:0] bigleft);
initial begin       
  $monitor($time,, "big=%b, bigleft=%d, valid=%b", big,bigleft,valid);
    big=0; bigleft=0;
    #1 big=10; bigleft=3;
    #1 big=1; bigleft=2;
    #1 big=1; bigleft=1;
    #1 big=1; bigleft=0;
    #1 big=0; bigleft=0;
    end
  endmodule

module somethingIsWrong
  (output logic somethingiswrong,
  input logic bigbombpossible, validlocation);
  
  always_comb begin
    if(bigbombpossible && validlocation)begin
      somethingiswrong = 1'b0;
    end
    else begin
      somethingiswrong = 1'b1;
    end
  end
endmodule

module testsomethingiswrong
  (input logic somethingiswrong,
  output logic bigbombpossible, validlocation);
initial begin       
  $monitor($time,, "bigbombpossible=%b, validlocation=%b, somethingiswrong=%b", bigbombpossible, validlocation,somethingiswrong);
    bigbombpossible=0;  validlocation=0;
    #1 bigbombpossible=0; validlocation=1;
    #1 bigbombpossible=1;  validlocation=0;
    #1 bigbombpossible=1;  validlocation=1;
    end
  endmodule

  
module PatrolShip
(output logic [3:0]hit, logic nearmiss, logic miss,
  input logic big, logic [3:0]x, 
       logic [3:0]y);
  
  always_comb begin
    hit = 1'b0;
    nearmiss=1'b0;
    miss=1'b0;
   
    if(big)begin
      if((y==3 && x>= 6 && x<=8) ||
      (x==9 && (y==1 || y==2)))begin
        nearmiss = 1'b1;
      end
      else if((x ==5 || x==8) && y >=1 && y<=2)begin
        hit = 4'd1;
      end
      else if((x ==6 || x==7) && y >=1 && y<=2)begin
        hit = 4'd2;
      end
      else begin
        miss = 1'b1;
      end 
      
      if(miss)begin
        if(((x==1 || x==4) && y>=8 && y<=10))begin
          hit = 4'd1;
        end
        else if(((x==3 || x==2) && y>=8 && y<=10))begin
          hit = 4'd2;
        end
        else if(x==5 && y ==8)begin
          nearmiss = 1'b1;
        end
      end
      
      
    end
    else if(~big)begin
      if((x>=1 && x <=4 && y>=8 && y<=10)||
      (x>=5 && x <=8 && y>=1 && y<=2))begin
        
        if((x >=2 && x <=3 && y==9)||
        (x>=6 && x<=7 && y==1))begin
          hit = 1'b1;
        end
        else begin
          if(~(x==1 && y==8)&&
            ~(x==1 && y==10) &&
            ~(x==4 && y==10) &&
            ~(x==4 && y==8) &&
            
            ~(x==5 && y==2) &&
            ~(x==8 && y ==2))begin
            nearmiss = 1'b1;
          end
          else begin
            miss = 1'b1;
          end          
        end
      end
      else begin
        miss = 1'b1;
      end 
    end
  end
endmodule

module testPatrol
  (input logic [3:0]hit, logic nearmiss, logic miss,
  output logic big, logic [3:0]x, 
       logic [3:0]y);   
initial begin       
  $monitor($time,, "x=%d, y=%d, big=%b, hit=%d, nearmiss=%b, miss=%b", x,y,big,hit,nearmiss,miss);
    x=0; y=0; big=0;
    #1 x=10; y=4; big=0;
    
    #1 x=2; y=9; big=0;
    #1 x=6; y=1; big=0;

    #1 x=1; y=8; big=0;
    #1 x=5; y=2; big=0;
    
    #1 x=8; y=4; big=0;
    
    #1 x=3; y=3; big=0;
    #1 x=2; y=2; big=0;
    #1 x=2; y=5; big=0;
    #1 x=1; y=1; big=0;
    #1 x=11; y=15; big=0;
    #1 x=1; y=1; big=1;
    #1 x=4; y=4; big=1;
    #1 x=1; y=7; big=1;
    
    #1 x=9; y=1; big=1;
    #1 x=10; y=1; big=1;
    end
  endmodule

module blockShip
(output logic [3:0]hit, logic nearmiss, logic miss, logic[4:0] rank,
  input logic big, logic [3:0]x, 
       logic [3:0]y);
  
  always_comb begin
    hit = 1'b0;
    nearmiss=1'b0;
    miss=1'b0;
    rank = 5'b00000;
    if(big)begin
      if(x>= 6 && x<=10 && y ==6)begin
        nearmiss = 1'b1;
      end
      else if(x>= 5&& x<=10 && y >= 9 && y<=10) begin
        rank = 5'b10000;
        
        if(x== 5&& y>=9 && y<=10)begin
          hit = 4'd1;
        end
        else if(x==6 && y==10)begin
          hit = 4'd2;
        end
        else if(x== 7&& y==10)begin
          hit = 4'd4;
        end
        else if(x== 8&& y==10)begin
          hit = 4'd5;
        end
        else if(x== 9&& y==10)begin
          hit = 4'd6;
        end
        else if(x== 10&& y==10)begin
          hit = 4'd4;
        end
        else if(x== 6&& y==9)begin
          hit = 4'd3;
        end
        else if(x== 7&& y==9)begin
          hit = 4'd6;
        end
        else if(x== 8&& y==9)begin
          hit = 4'd8;
        end
        else if(x== 9&& y==9)begin
          hit = 4'd9;
        end
        else if(x== 10&& y==9)begin
          hit = 4'd6;
        end
      end
      else if(x>=6 && x<=10 && y>=7 && y<=8) begin
        rank = 5'b01000;
        if(x == 6 && y >=7 && y<=8)begin
           hit = 4'd1;
        end
        else if(x>=8 && x<=9&& y==7)begin
         hit = 4'd3;
        end
        else if(x== 7&& y==8)begin
          hit = 4'd3;
        end
        else if(x== 7&& y==7)begin
          hit = 4'd2;
        end
        else if(x== 8&& y==8)begin
          hit = 4'd5;
        end
        else if(x== 9&& y==8)begin
          hit = 4'd6;
        end
        else if(x== 10&& y==8)begin
          hit = 4'd4;
        end
        else if(x== 10&& y==7)begin
          hit = 4'd2;
        end
      end
    else begin
      miss = 1'b1;
    end
    
    end 
    else if(~big)begin
      if(x>= 5 && x<= 10 && y >= 7 && y<=10)begin
        if((x==5 && y ==9) || 
            (x==5 && y ==8)||
            (x==5 && y ==7)||
            (x==6 && y ==7))begin
          miss = 1'b1;
        end
        //refers to aircraft carrier
        else if((x>= 6 && x<=10 && y ==10))begin
          hit = 1'b1;
          rank = 5'b10000;
        end
        //refers to cruiser
        else if((x>= 8 && x<=10 && y ==9))begin
          hit = 1'b1;        
          rank = 5'b00100;
        end
        //refers to battleship
        else if((x>= 7 && x<=10 && y ==8))begin
          hit = 1'b1;
          rank = 5'b01000;
        end
        else begin
          nearmiss = 1'b1;
        end      
      end
      else begin
        miss = 1'b1;
      end
    end
  end
endmodule

module testBlock
  (input logic [3:0]hit, logic nearmiss, logic miss, logic[4:0] rank,
  output logic big, logic [3:0]x, 
       logic [3:0]y);   
initial begin       
  $monitor($time,, "x=%d, y=%d, big=%b, hit=%d, nearmiss=%b, miss=%b, rank=%b", x,y,big,hit,nearmiss,miss,rank);
    x=0; y=0; big=0;
    #1 x=10; y=4; big=0;
    #1 x=8; y=8; big=0;
    #1 x=8; y=9; big=0;
    #1 x=8; y=10; big=0;
    #1 x=6; y=7; big=0;
    #1 x=7; y=9; big=0;
    #1 x=9; y=9; big=1;
    #1 x=9; y=6; big=1;
    end
  endmodule


module SubShip
(output logic [3:0]hit, logic nearmiss, logic miss,
  input logic big, logic [3:0]x, 
       logic [3:0]y);
  
  always_comb begin
    hit = 1'b0;
    nearmiss=1'b0;
    miss=1'b0;
   
    if(big)begin
      if((x>=1 && x<=5 && (y==7))||
      (x>=2 && x<=4 && (y==1))||
        ((x==1 || x==5) && y>=2 && y<=6))begin
        nearmiss = 1'b1;
      end
      else if(x>=2 && x<=4 && (y==6 || y==2))begin
        hit = 3'd1;
      end
      else if(x>=2 && x<=4 && (y==3 || y==5))begin
        hit = 3'd2;
      end
      else if(x>=2 && x<=4 && (y==4))begin
        hit = 3'd3;
      end
      else begin
        miss = 1'b1;
      end
    end 
    else if(~big)begin
      if((x>=2 && x <=4 && y>=2 && y<=6) 
          && !((x==2 && (y==2 || y==6)) || (x==4 && (y==2 || y==6))))begin
        if((x==3 && y>=3 && y<=5))begin
          hit = 1'b1;
        end
        else begin
          nearmiss = 1'b1;
        end
      end
      else begin
        miss = 1'b1;
      end 
    end
  end
endmodule

module testSub
  (input logic [3:0]hit, logic nearmiss, logic miss,
  output logic big, logic [3:0]x, 
       logic [3:0]y);   
initial begin       
  $monitor($time,, "x=%d, y=%d, big=%b, hit=%d, nearmiss=%b, miss=%b", x,y,big,hit,nearmiss,miss);
    x=0; y=0; big=0;
    #1 x=10; y=4; big=0;
    #1 x=3; y=3; big=0;
    #1 x=2; y=2; big=0;
    #1 x=2; y=5; big=0;
    #1 x=1; y=1; big=0;
    #1 x=11; y=15; big=0;
    #1 x=1; y=1; big=1;
    #1 x=4; y=4; big=1;
    #1 x=1; y=7; big=1;
    end
  endmodule 