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

	fifo #(32,4) packetQ(clk, rst_b, pkt_in, pkt_in_avail, free_outbound, 
											cQ_full,qEmpty, valueToSend);

//modules for handshaking with router
	producer sender(.valueToSend(valueToSend), .free(free_outbound), 
									.ck(clk), .r_l(rst_b),.enable(~qEmpty),
									.put(put_outbound), .payload(payload_outbound));
	
	consumer receiver(.payload(payload_inbound), .put(put_inbound),
										.ck(clk),.r_l(rst_b),
										.full(1'b0),
										.free(free_inbound), 
										.valueReceived(pkt_out), 
										.done(pkt_out_avail));
	
endmodule


/*  Create a fifo (First In First Out) with depth 4 using the given interface and constraints.
 *  -The fifo is initally empty.
 *  -Reads are combinational
 *  -Writes are processed on the clock edge.  
 *  -If the "we" happens to be asserted while the fifo is full, do NOT update the fifo.
 *  -Similarly, if the "re" is asserted while the fifo is empty, do NOT update the fifo. 
 */

module fifo(clk, rst_b, data_in, we, re, full, empty, data_out);
  parameter WIDTH = 32, SIZE=4;
  input clk, rst_b;
  input [WIDTH-1:0] data_in;
  input we; //write enable
  input re; //read enable
  output full;
  output empty;
  output [WIDTH-1:0] data_out ;

		bit[WIDTH-1:0] queue[SIZE];
		bit [1:0] putPtr, getPtr;
		bit [$clog2(SIZE):0] count;

		assign empty = (count == 0),
					 full = (count == SIZE),
					 data_out = queue[getPtr];

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

/////////////////////////ADDITIONAL MODULES//////////////////////////////

module producer(
	input pkt_t valueToSend,
	input bit free,ck,r_l,enable,
	output bit put,
	output bit [7:0] payload);
		
	bit [1:0] count;
	bit en_count, cl_count;
	pkt_t inpt_val;
	
	register value(valueToSend,ck,r_l,enable,inpt_val);
	counter myCounter(en_count,cl_count, ck, r_l, count);
	
	enum bit {WAIT,SEND}curr,nxt;

	always_ff @(posedge ck, negedge r_l) 
		if(~r_l)	curr <= WAIT;
		else curr<=nxt;
	
	always_comb begin
		case(curr)
			WAIT: begin 
				nxt = (free & enable) ? SEND : WAIT;
				{payload,put} = 0;
				en_count = 0; cl_count = 1;
			end

			SEND: begin
				nxt = (count!=3) ? SEND : WAIT;
				{en_count,put} = 3;      
				cl_count = 0;						
				case (count)
					0: payload = {inpt_val.sourceID,inpt_val.destID};				
					1: payload = inpt_val.data[23:16];
					2: payload = inpt_val.data[15:8];
					3: payload = inpt_val.data[7:0];
					default: payload = 0;
				endcase
			end
		endcase
	end 
endmodule : producer


module consumer(
	input bit [7:0] payload,
	input bit put,ck,r_l,
	input bit full,
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
				free = (~full) ? 1: 0;
				valueReceived = (~put) ? 0 : {payload, 24'b0};
				en_count =0; cl_count =1;
			end

			RECEIVE: begin
				nxt = (count!=2) ? RECEIVE : WAIT;
				free = 0;
				en_count = 1; cl_count = 0;
				case (count) 
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
