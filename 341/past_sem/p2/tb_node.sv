module tb_node(clk, rst_b, pkt_in, pkt_in_avail, cQ_full, pkt_out, pkt_out_avail,
            free_outbound, put_outbound, payload_outbound,
            free_inbound, put_inbound, payload_inbound);

  output bit clk, rst_b;

  // Interface to TestBench
  output pkt_t pkt_in;
  output logic pkt_in_avail;
  input bit cQ_full;
  input pkt_t pkt_out;
  input logic pkt_out_avail;

  // Endpoint -> Router transaction
  output bit free_outbound; // Router -> Endpoint
  input bit put_outbound; // Endpoint -> Router
  input bit [7:0] payload_outbound;

  // Router -> Endpoint transaction
  input bit free_inbound; // Endpoint -> Router
  output bit put_inbound; // Router -> Endpoint
  output bit [7:0] payload_inbound;
  
	initial begin
		pkt_in.sourceID = 4'b1111;
		pkt_in.destID = 4'b0000;
		pkt_in.data = 24'b101010101010101010101010;
	end
  	initial begin
  		#1 clk = 0; rst_b = 0;
		#5 rst_b=1;
		forever #5 clk =~clk;
  	end

	initial begin
		@(posedge clk)
		pkt_in_avail =1;
		$display("pkt_in_avail <= 1");
		$display("Time: %3d, cQ_full: %b ",$stime,cQ_full);
		@(posedge clk)
		pkt_in_avail =0;
		free_outbound =1;
		$display("free_outbound <=1");
		$display("Time: %3d, cQ_full: %b ",$stime,cQ_full);
		@(posedge clk)
		$display("Time: %3d, cQ_full: %b, put_outbound: %b toRouter: %b ",$stime,cQ_full,
		put_outbound, payload_outbound );
		@(posedge clk)
		free_outbound =0;
		$display("Time: %3d, cQ_full: %b, put_outbound: %b toRouter: %b ",$stime,cQ_full,
		put_outbound, payload_outbound );
		@(posedge clk)
		$display("Time: %3d, cQ_full: %b, put_outbound: %b toRouter: %b ",$stime,cQ_full,
		put_outbound, payload_outbound );
		@(posedge clk)
		$display("Time: %3d, cQ_full: %b, put_outbound: %b toRouter: %b ",$stime,cQ_full,
		put_outbound, payload_outbound );
		@(posedge clk)
		$display("Time: %3d, cQ_full: %b, put_outbound: %b toRouter: %b ",$stime,cQ_full,
		put_outbound, payload_outbound );
		@(posedge clk)
		$display("Time: %3d, cQ_full: %b, put_outbound: %b toRouter: %b ",$stime,cQ_full,
		put_outbound, payload_outbound );
		@(posedge clk)
		$display("Time: %3d, cQ_full: %b, put_outbound: %b toRouter: %b ",$stime,cQ_full,
		put_outbound, payload_outbound );

		@(posedge clk)
		$display("Test 1 done");

		@(posedge clk)
		rst_b <= 0;
		@(posedge clk)
		rst_b <= 1;
		
		@(posedge clk)
		put_inbound = 1;
		payload_inbound = 8'b 11110000;
		$display("Time: %3d, free_inbound:%b",$stime,free_inbound);
		@(posedge clk)
		payload_inbound = 8'b 10101010;
		@(posedge clk)
		payload_inbound = 8'b 01010101;
		@(posedge clk)
		payload_inbound = 8'b 10101010;
		put_inbound =0;
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		$display("Time: %3d, GOT-IT: %b, fromNode_Router: %h",$stime,pkt_out_avail, pkt_out);	
		@(posedge clk)
		$display("Time: %3d, GOT-IT: %b, fromNode_Router: %h",$stime,pkt_out_avail, pkt_out);	
		@(posedge clk)
		$display("Time: %3d, GOT-IT: %b, fromNode_Router: %h",$stime,pkt_out_avail, pkt_out);	
		@(posedge clk)
		$display("Time: %3d, GOT-IT: %b, fromNode_Router: %h",$stime,pkt_out_avail, pkt_out);	
		@(posedge clk)

		$display("TEST 2 finished");

		$finish;
	end
endmodule
