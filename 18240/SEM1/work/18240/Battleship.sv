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

  top t(x,y,big,bigleft,scorethis, hit,nearmiss,miss,numhits,biggestshiphit,somethingiswrong);
  finalTopTester test(x,y,big,bigleft,scorethis, hit,nearmiss,miss,numhits,biggestshiphit,somethingiswrong);
  
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
  
  logic i,j,k;
  
initial begin
  $monitor($time,, 
  "x=%d, y=%d, big=%b, bigleft=%d, scorethis=%b,--> hit=%b, nearmiss=%b, numhits=&b, biggestshiphit=%b, somethingiswrong=%b",
  x,y,big,bigleft,scorethis,hit,nearmiss,numhits,biggestshiphit,somethingiswrong);
x=0; y=0; bigleft=0; big=0; scorethis=0;  

  for (i=1;i<=10;i++)begin
    for (j=1; j<=10; j++)begin  
      for(k=0; k<=1;k++)begin
        #1 x=i; y=j; bigleft=3; big=k; scorethis=1;
      end
    end
  end
 
#1 x=1; y=1; bigleft=2; big=1; scorethis=1;
#1 x=5; y=5; bigleft=1; big=1; scorethis=1;
#1 x=7; y=6; bigleft=0; big=1; scorethis=1;
#1 x=2; y=3; bigleft=0; big=0; scorethis=1;
#1 x=4; y=7; bigleft=1; big=1; scorethis=0;
end
endmodule

module toptest; 
  logic[3:0]x;
  logic[3:0]y;
  logic big;
  logic [3:0]hit;
  logic nearmiss;
  logic miss;
  //PatrolBoat p(.*);
  SubShip sub(.*);
  testSub t(.*);
endmodule

module top
(input logic[3:0]x,
  logic[3:0]y,
  logic big,
  logic [1:0] bigleft,
  logic scorethis,

  output logic hit,
  logic nearmiss,
  logic miss,
  logic [7:0] numhits,
  logic [4:0] biggestshiphit,
  logic somethingiswrong
);

  //input logic
//  logic[3:0]x;
//  logic[3:0]y;
//  logic big;
//  logic [1:0] bigleft;
//  logic scorethis;
  
  //final output logic  
//  logic hit;
//  logic nearmiss;
//  logic miss;
//  logic [7:0] numhits;
//  logic [4:0] biggestshiphit;
// logic somethingiswrong;

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
  
  
  validLocation vL(validloc,x,y);
  BigBombPossible bbp(validbomb,big,bigleft);
  somethingIsWrong sW(somethingiswrong,validbomb,validloc);
  
  //linked each individual boat module
  PatrolShip pS(phit,pnearmiss,pmiss,big,x,y);
  SubShip    sS(subhit,subnearmiss,submiss,big,x,y);
  blockShip  bS(blockhit,blocknearmiss,blockmiss,blockrank, big,x,y);
  
  //convert num hits into LED lights
  BCDtoLED pLED(pledhit,phit);
  BCDtoLED sLED(subledhit,subhit);
  BCDtoLED bLED(blockledhit,blockhit);
  
  
  //link everything to finalOutput
  finalOutput finalo(hit, nearmiss, miss, numhits, biggestshiphit, somethingiswrong,
                    phit, pnearmiss, pmiss, pledhit,
                    subhit,subnearmiss,submiss,subledhit,
                    blockhit,blocknearmiss,blockmiss, blockledhit,blockrank,
                    scorethis,somethingiswrong);
endmodule

module BCDtoLED
  (output		reg	[7:0]	led,
    logic bar,
    input [3:0] 			bcd);

  always_comb
  case(bcd)
    0: led = 8'b00000011;
    1: led = 8'b10011111;
    2: led = 8'b00100101;
    3: led = 8'b00001101;
    4: led = 8'b10011001;
    5: led = 8'b01001001; 
    6: led = 8'b01000001; 
    7: led = 8'b00011111; 
    8: led = 8'b00000001; 
    9: led = 8'b00011001; 
    default: led = 8'b00000011;
  endcase
  assign bar = led; 
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
      if(blockhit >0)begin
        hit = 1'b1;
        biggestshiphit = blockrank;
        numhits = blockledhit;
      end
      else if(subhit >0) begin
        hit = 1'b1;
        biggestshiphit = 5'b00100;
        numhits = subledhit;
      end
      else if(patrolhit >0) begin
        hit = 1'b1;
        biggestshiphit = 5'b00001;
        numhits = pledhit;
      end
      else if(blocknearmiss >0)begin
        nearmiss = 1'b1;
        biggestshiphit = blockrank;
      end
      else if(subnearmiss >0) begin
        nearmiss = 1'b1;
        biggestshiphit = 5'b00100;
      end
      else if(patrolnearmiss >0) begin
        nearmiss = 1'b1;
        biggestshiphit = 5'b00001;
      end
      else begin
        miss = 1'b1;
      end
    end
    
  end

//always_comb begin
//  if (subhit>0 && blockrank<3) begin
//    rank = 5'b00010;
//  end
//  else if (patrolhit>0 && blockrank<2) begin
//    rank = 5'b00001;
//  end
//  else begin
//    rank = blockrank;
//  end   
//end
endmodule



module validLocation
(output logic valid,
input logic [3:0] x, y);
  always_comb begin
    if(x>=0 && x<=10 && y>=0 && y<=10)begin
      valid = 1'b1;
    end
    else begin
      valid = 1'b0;
    end
  end
endmodule;

module BigBombPossible
  (output logic valid,
  input logic big, logic [1:0] bigleft);
  
  always_comb begin
    if(big && bigleft >0)begin
      valid = 1'b1;
    end
    else begin
      valid = 1'b0;
    end
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
          nearmiss = 1'b1;
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
        if((x==5 && y ==8)||
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