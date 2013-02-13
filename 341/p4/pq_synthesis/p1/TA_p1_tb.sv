//`default_nettype none
`define RESET @(posedge ck); r <=1; #1 r <=0; @(posedge ck);
module priorityElement_TA
  #(parameter W = 8)
   (input   logic  [W-1:0]  newVal, elemAbove, elemBelow,
    input   logic      ck, r, clear, loadedAboveIn, shiftOut, loadIn,
    output   logic [W-1:0]  elem,
    output  logic      loadedAboveOut);
    
  logic  [W-1:0] muxOut;
  logic      here, ld;

  assign here = (newVal > elem) & loadIn;
  assign loadedAboveOut =  ld;
  assign ld = here | loadedAboveIn | (shiftOut & ~loadIn);
  
  always_comb begin
    casez ({loadIn, shiftOut, loadedAboveIn})
      3'b1?0 : muxOut = newVal;
      3'b1?1 : muxOut = elemAbove;
      3'b01? : muxOut = elemBelow;
    endcase
  end
  
  always_ff @(posedge ck, posedge r) begin
    if (r)  elem <= 0;
    else  if (clear) elem <= 0;  //sync clear overrides ld
    else  if (ld) elem <= muxOut;
  end

endmodule: priorityElement_TA


module priQueue_TA
  #(parameter W = 8)
  (input  logic[W-1:0]  newVal,
   input  logic      ck, r, clear, loadIn, shiftOut,
   output logic[W-1:0]  top);
  
  //logic  [W-1:0]  elemAbove;
  //logic      loadedAboveIn;
  logic [W-1:0]  elem5, elem4, elem3, elem2, elem1, elem0;
  logic      hA5, hA4, hA3, hA2, hA1, hA0;
  
  assign top = elem5;
    
  priorityElement_TA #(W) e5 (.elemAbove({W{1'b1}}), .elem(elem5), .elemBelow(elem4), .loadedAboveOut(hA5), .loadedAboveIn(1'b0), .*);
  priorityElement_TA #(W) e4 (.elemAbove(elem5), .elem(elem4), .elemBelow(elem3), .loadedAboveOut(hA4), .loadedAboveIn(hA5), .*);
  priorityElement_TA #(W) e3 (.elemAbove(elem4), .elem(elem3), .elemBelow(elem2), .loadedAboveOut(hA3), .loadedAboveIn(hA4), .*);
  priorityElement_TA #(W) e2 (.elemAbove(elem3), .elem(elem2), .elemBelow(elem1), .loadedAboveOut(hA2), .loadedAboveIn(hA3), .*);
  priorityElement_TA #(W) e1 (.elemAbove(elem2), .elem(elem1), .elemBelow(elem0), .loadedAboveOut(hA1), .loadedAboveIn(hA2), .*);
  priorityElement_TA #(W) e0 (.elemAbove(elem1), .elem(elem0), .elemBelow({W{1'b0}}), .loadedAboveOut(hA0), .loadedAboveIn(hA1), .*);
  
  initial
    $monitor($stime,,"shiftOut=%b, loadIn=%b, clear=%b, new=%2d, e5=%2d, e4=%2d, e3=%2d, e2=%2d, e1=%2d, e0=%2d",
    shiftOut, loadIn, clear,newVal, elem5, elem4, elem3, elem2, elem1, elem0);

endmodule: priQueue_TA

module tb;
  parameter W = 8;
  
  logic  [W-1:0] newVal, top_student, top_TA;
  logic      ck, r, shiftOut, loadIn, clear;
  logic [9:0] newVal10, top10;

  bit en_check;
  bit has_err;
  bit results[8:1];
  bit test3;

  int score;
  int pts[1:8];


  priQueue #(W) pq (.top(top_student), .*);
  priQueue_TA #(W) pq_TA (.top(top_TA), .*);
  priQueue #(10) pq_W10 (.top(top10), .newVal(newVal10), .*);


  initial begin
    @(posedge ck);
    $display("*******************************************");
    $display("**********GRADING TESTBENCH****************");
    $display("*******************************************\n\n\n");



    $display("*******************************************");
    $display("Test1 (%-d pts) Basic Functionality 1",pts[1]);
    $display("*******************************************");
    shiftOut <= 0;
    loadIn <= 1;
    clear <= 0;
    en_check <= 1;
    for (int i = 0; i < 6; i++) begin
      newVal <= $urandom_range(100,1);
      @ (posedge ck);
    end
    shiftOut <= 1;
    loadIn <= 0 ;
    for (int i = 0; i < 6; i++) begin
      @ (posedge ck);
    end
    @(posedge ck);
    if(has_err) begin
      en_check = 0;
      results[1] = 1'b1;
    end
    `RESET

    $display("*******************************************");
    $display("Test2 (%-d pts) Basic Functionality 2 (Clear in the middle)",pts[2]);
    $display("*******************************************");
    shiftOut <= 0;
    loadIn <= 1;
    clear <= 0;
    en_check <= 1;
    for (int i = 0; i < 14; i++) begin
      newVal <= $urandom_range(100,1);
      clear <= (i==5) ? 1'b1 : 1'b0 ;
      @ (posedge ck);
    end
    shiftOut <= 1;
    loadIn <= 0 ;
    for (int i = 0; i < 6; i++) begin
      @ (posedge ck);
    end
    @(posedge ck);
    if(has_err) begin
      en_check = 0;
      results[2] = 1'b1;
    end
    `RESET

    $display("*******************************************");
    $display("Test3 (%-d pts) Basic Functionality with W=10",pts[3]);
    $display("*******************************************");
    shiftOut <= 0;
    loadIn <= 1;
    clear <= 0;
    test3 = 0;
    fork
      begin
        for (int i = 0; i < 20; i++) begin
          newVal10 <= $urandom_range(1023,512); // Higher range than 8 bits
          @ (posedge ck);
        end
        shiftOut <= 1;
        loadIn <= 0 ;
        for (int i = 0; i < 10; i++) begin
          @ (posedge ck);
        end
        @(posedge ck);
        if(has_err) begin
          en_check = 0;
          results[3] = 1'b1;
        end
        test3 = 1;
      end
      begin
        while(test3) begin
          @(posedge ck);
          #1 if(top10 != top_TA) begin
            $display("ERROR: @%-t student's top = %-d, correct top = %-d",$stime-1,top_student,top_TA);
            has_err = 1;
          end
        end
      end
    join
    `RESET

    $display("*******************************************");
    $display("Test4 (%-d pts) Extremes of ranges",pts[4]);
    $display("*******************************************");
    shiftOut <= 0;
    loadIn <= 1;
    clear <= 0;
    en_check <= 1;
    for (int i = 0; i < 10; i++) begin
      newVal <= 246+i;
      @ (posedge ck);
    end
    newVal <= 1;
    @(posedge ck);
    shiftOut <= 1;
    loadIn <= 0 ;
    for (int i = 0; i < 6; i++) begin
      @ (posedge ck);
    end
    @(posedge ck);
    if(has_err) begin
      en_check = 0;
      results[4] = 1'b1;
    end
    `RESET

    $display("*******************************************");
    $display("Test5 (%-d pts) Priority test1 (shiftOut + loadIn)",pts[5]);
    $display("*******************************************");
    shiftOut <= 1;
    loadIn <= 1;
    clear <= 0;
    en_check <= 1;
    for (int i = 0; i < 6; i++) begin
      newVal <= $urandom_range(100,1);
      @ (posedge ck);
    end
    shiftOut <= 1;
    loadIn <= 0 ;
    for (int i = 0; i < 6; i++) begin
      @ (posedge ck);
    end
    @(posedge ck);
    if(has_err) begin
      en_check = 0;
      results[5] = 1'b1;
    end
    `RESET

    $display("*******************************************");
    $display("Test6 (%-d pts) Priority test2 (All 3 control signals asserted!)",pts[6]);
    $display("*******************************************");
    shiftOut <= 1;
    loadIn <= 1;
    clear <= 0;
    en_check <= 1;
    for (int i = 0; i < 30; i++) begin
      newVal <= $urandom_range(100,1);
      clear <= (i inside{4,5,6}) ? 1'b1 : 1'b0 ;
      @ (posedge ck);
    end
    shiftOut <= 0;
    loadIn <= 0;
    repeat(5) @(posedge ck);
    shiftOut <= 1;
    loadIn <= 0 ;
    for (int i = 0; i < 6; i++) begin
      @ (posedge ck);
    end
    @(posedge ck);
    if(has_err) begin
      en_check = 0;
      results[6] = 1'b1;
    end
    `RESET

    $display("*******************************************");
    $display("Test7 (%-d pts) Same numbers!",pts[7]);
    $display("*******************************************");
    shiftOut <= 0;
    loadIn <= 1;
    clear <= 0;
    en_check <= 1;
    newVal <= 5;
    repeat(3) @ (posedge ck);
    newVal <= 7; 
    repeat(5) @(posedge ck);
    newVal <= 6;
    repeat(4) @(posedge ck);
    shiftOut <= 1;
    loadIn <= 0 ;
    newVal <=100;
    repeat(5);    
    shiftOut <= 1;
    loadIn <= 0 ;
    for (int i = 0; i < 8; i++) begin
      @ (posedge ck);
    end
    @(posedge ck);
    if(has_err) begin
      en_check = 0;
      results[7] = 1'b1;
    end
    `RESET

    $display("*******************************************");
    $display("Test8 (%-d pts) BART (Big Ass Random Test)",pts[8]);
    $display("*******************************************");
    shiftOut <= 0;
    loadIn <= 0;
    clear <= 0;
    en_check <= 1;
    @(posedge ck);
    for(int i=0; i < 341; i++) begin
      newVal <= $urandom_range(100,1);
      loadIn <= i[4] || i[3] ;
      shiftOut <= !i[3] ;
      @(posedge ck);
    end
    if(has_err) begin
      en_check = 0;
      results[8] = 1'b1;
    end
    `RESET



    #1 $finish;
  end

  //initialize pts array  
  initial begin
    pts[1] = 8;
    pts[2] = 5;
    pts[3] = 5;
    pts[4] = 3;
    pts[5] = 5;
    pts[6] = 4;
    pts[7] = 4;
    pts[8] = 6;
  end


  final begin
    score = 0;
    for(int i=1; i<9; i++) begin
      if(!results[i]) score += pts[i];
      $display("TEST%-d : %-d/%-d",i,results[i] ? 0 : pts[i],pts[i]);
    end
    $display("Final Score! = %-d/40",score);
  end


  initial begin
    en_check = 0;
    ck = 0;
    r = 1;
    r <= #1 0;
    forever #5 ck = ~ck;
  end

  //Function to check student's design vs our design  (can be disabled)
  initial begin
    @(posedge ck);
    forever @(posedge ck) begin
      if(~en_check) begin
        has_err = 0;
      end
      #1 if(en_check && top_student != top_TA) begin
        $display("ERROR: @%6t student's top = %-d, correct top = %-d",$stime-1,top_student,top_TA);
        has_err = 1;
      end
    end
  end


endmodule: tb

