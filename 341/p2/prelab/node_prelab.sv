module node(clk, rst_b, pkt_in, pkt_in_avail, cQ_full, pkt_out, pkt_out_avail,
            free_outbound, put_outbound, payload_outbound,
            free_inbound, put_inbound, payload_inbound);

  parameter NODEID = 0;
  input clk, rst_b;

  // Interface to TestBench
  input pkt_t pkt_in;
  input pkt_in_avail;
  output cQ_full;
  output pkt_t pkt_out;
  output logic pkt_out_avail;

  // Endpoint -> Router transaction
  input free_outbound; // Router -> Endpoint
  output put_outbound; // Endpoint -> Router
  output [7:0] payload_outbound;

  // Router -> Endpoint transaction
  output free_inbound; // Endpoint -> Router
  input put_inbound; // Router -> Endpoint
  input [7:0] payload_inbound;

//////////////////////////MY CODE///////////////////////////

	pkt_t valueToSend;	
	bit qEmpty;

	fifo #(32) packetQ(clk, rst_b, pkt_in, pkt_in_avail, free_outbound, cQ_full,
											qEmpty, valueToSend);

//modules for handshaking with router
	producer sender(valueToSend, free_outbound, clk, rst_b, 
										put_outbound, payload_outbound);
	
	consumer receiver(payload_inbound, put_inbound,clk,rst_b, 
										free_inbound, pkt_out, pkt_out_avail);
endmodule


/*  Create a fifo (First In First Out) with depth 4 using the given interface and constraints.
 *  -The fifo is initally empty.
 *  -Reads are combinational
 *  -Writes are processed on the clock edge.  
 *  -If the "we" happens to be asserted while the fifo is full, do NOT update the fifo.
 *  -Similarly, if the "re" is asserted while the fifo is empty, do NOT update the fifo. 
 */

/**ADAPTED FROM LECTURE 4B NOTES**/
module fifo(clk, rst_b, data_in, we, re, full, empty, data_out);
  parameter WIDTH = 32;
  input clk, rst_b;
  input [WIDTH-1:0] data_in;
  input we; //write enable
  input re; //read enable
  output full;
  output empty;
  output [WIDTH-1:0] data_out ;
		
		bit[WIDTH-1:0] queue[4];
		bit [1:0] putPtr, getPtr;
		bit [2:0] count;

		assign empty = (count == 0),
					 full = (count == 4),
					 data_out = (re && (!empty)) ? queue[getPtr] : 'd0;

		always_ff @(posedge clk, negedge rst_b) begin
			if(~rst_b) begin
					count <= 0;
					getPtr <= 0;
					putPtr <= 0;
			end
			else begin
					if(re && (!empty))	begin
							getPtr <= getPtr + 1;
							count <=  count-1;
					end
					else if (we && (!full)) begin
							queue[putPtr] <= data_in;
							putPtr <= putPtr +1;
							count <= count +1;
					end
			end
		end
endmodule


/*COPIED OVER FROM: router.sv*/
module router(clk, rst_b,
              free_outbound, put_outbound, payload_outbound,
              free_inbound, put_inbound, payload_inbound);
  parameter ROUTERID = 0; // To differentiate between routers
  input  clk, rst_b;

  // self -> destination (sending a payload)
  input [3:0] free_outbound;
  output [3:0] put_outbound;
  output [3:0][7:0] payload_outbound;

  // source -> self (receiving a payload)
  output [3:0] free_inbound;
  input [3:0] put_inbound;
  input [3:0][7:0] payload_inbound;
  
///////////////////////MY CODE///////////////////////////////

	bit [3:0][31:0] valueReceived, valueToSend;
	bit [3:0] pkt_in_avail;
	genvar j;

//Generate 4 sets of buffers
	generate 
		for(j=0; j<4; j=j+1) begin: B1
			consumer input_buf(.ck(clk),.r_l(rst_b),
												 .valueReceived(valueReceived[j]),
												 .free(free_inbound[j]), 
												 .put(put_inbound[j]),
												 .done(pkt_in_avail[j]),
												 .payload(payload_inbound[j]));

			producer output_buf(.ck(clk), .r_l(rst_b),
													.valueToSend(valueToSend[j]),
													.free(free_outbound[j]), 
													.put(put_outbound[j]),
													.payload(payload_outbound[j]));
		end
	endgenerate
endmodule

//Testbench: Tests message routes:
//						: TB -> Node -> Router
//						: Router -> Node -> TB
module tb(output bit clk, rst_b, output pkt_t pkt_in[6],
  output bit pkt_in_avail[6],
  input pkt_t pkt_out[6],
  input bit pkt_out_avail[6]);
 
 	initial begin
		rst_b=0;clk=0;
		#10 rst_b = 1;
		forever #5 clk = ~clk;
	end
	
	initial begin
	//Loads in random value to send node
		pkt_in[0] <= $urandom_range(32'hFFFFFFFF,0);

		pkt_in_avail[0] <= 1;
		@(posedge clk);
		pkt_in_avail[0] <= 0;
	
	//wait for send, then check for values
		repeat (4) @(posedge clk);
		assert (R1[0].router_inst.valueReceived[0] == pkt_in[0])
			$display ("\nMessage Sent: Node->Router!\n");
		else
			$display("\nMessage did not send Node->Router...you suck!\n");
		
	//Loads in same random value into router to send to node
		R1[0].router_inst.valueToSend <= pkt_in[0];
	
	//wait for send, then check for values
		repeat (5) @(posedge clk);	
		assert (pkt_out[0] == pkt_in[0])
			$display ("\nMessage Sent to TB!\n");
		else
			$display("\nMessage did not send to TB...you suck!\n");

		$finish;
	end 
endmodule 


/////////////////////////ADDITIONAL MODULES//////////////////////////////

/*NOTE2SELF:
	Assumed input value remained forever...
  did some quick fix...need better implementation*/
module producer(
	input pkt_t valueToSend,
	input bit free,ck,r_l, 
	output bit put,
	output bit [7:0] payload);
		
	bit [1:0] count;
	bit en_count, cl_count, ld;
	pkt_t inpt_val;
	
	register value(valueToSend,ck,r_l,ld,inpt_val);
	counter myCounter(en_count,cl_count, ck, r_l, count);
	
	enum bit {WAIT,SEND}curr,nxt;

	always_ff @(posedge ck, negedge r_l) 
		if(~r_l)	curr <= WAIT;
		else curr<=nxt;

	always_comb begin
		case(curr)
			WAIT: begin 
				nxt = (~free) ? WAIT : SEND;
				{payload,put,ld} = 0;
				en_count = 0; cl_count = 1;
			end

			SEND: begin
				nxt = (count!=3) ? SEND : WAIT;
				{ld,en_count,put} = 3;       //<<<<<<<<QUICK HACK WITH ld
				cl_count = 0;						
				case (count)
					0:begin 
							payload = {valueToSend.sourceID,valueToSend.destID};
							ld =1;								//	DONT FORGET TO FIX
					end
					1: payload = valueToSend.data[23:16];
					2: payload = valueToSend.data[15:8];
					3: payload = valueToSend.data[7:0];
					default: payload = 0;
				endcase
			end
		endcase
	end 
endmodule : producer


module consumer(
	input bit [7:0] payload,
	input bit put,ck,r_l,
	output bit free,
	output pkt_t valueReceived,
	output bit done);
	
	bit [1:0] count;
	bit en_count, cl_count;

	counter myCounter(en_count,cl_count, ck, r_l, count);
	
	enum bit {WAIT, RECEIVE}curr,nxt;
	
	always_ff @(posedge ck, negedge r_l)
		if(~r_l) curr <= WAIT;
		else curr<=nxt;

	assign done = (count == 2);

	always_comb
		case(curr)
			WAIT: begin
				nxt = (~put) ? WAIT : RECEIVE;
				free = 1;
				valueReceived = (~put) ? 0 : {payload, 24'b0};
				en_count =0; cl_count =1;
			end

			RECEIVE: begin
				nxt = (count!=2) ? RECEIVE : WAIT;
				free = 0;
				en_count = 1; cl_count = 0;
				case (count) //alt. shift in while(put)
					0: valueReceived.data[23:16] = payload;
					1: valueReceived.data[15:8] = payload;
					2: valueReceived.data[7:0] = payload;
					default: valueReceived = 0;
				endcase
			end
		endcase
endmodule : consumer

//Clock-based 2-bit counter
module counter 
		(input bit enable,clear,ck,r_l,
		 output logic [1:0] count);

//active on a clk or reset_L for sync and async functionality
	always_ff @ (posedge ck, negedge r_l)
		if(~r_l | clear) 
			count <= 0;
		else if (enable)
			count <= count+1;
endmodule: counter


module register(input pkt_t in, input bit clk, rst_b, ld, 
								output pkt_t out);
	always_ff @(posedge clk, negedge rst_b) begin
			if(~rst_b)		out <= 0;
			else if (ld)	out <= in;
			else 					out <= out;
	end
endmodule
