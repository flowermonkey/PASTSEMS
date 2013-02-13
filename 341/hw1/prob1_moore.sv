`default_nettype none

typedef struct packed{
		bit[7:0] a,b,c,d;
}pay;

module producer(
	input pay valueToSend,
	input bit free,ck,r_l, 
	output bit put,
	output bit [7:0] payload);
		
	bit [1:0] count;
	bit en_count, cl_count;

	counter myCounter(en_count,cl_count, ck, r_l, count);
	
	enum bit {WAIT,SEND}curr,nxt;

	always_ff @(posedge ck, negedge r_l) 
		if(~r_l)	curr <= WAIT;
		else curr<=nxt;

	always_comb begin
		case(curr)
			WAIT: begin 
				nxt = (~free) ? WAIT : SEND;
				{payload,put} = 0;
				en_count = 0; cl_count = 1;
			end

			SEND: begin
				nxt = (count!=3) ? SEND : WAIT;
				{en_count,put} = 3;
				cl_count = 0;
				case (count)
					0: payload = valueToSend.a;
					1: payload = valueToSend.b;
					2: payload = valueToSend.c;
					3: payload = valueToSend.d;
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
	output pay valueReceived);
	
	bit [1:0] count;
	bit en_count, cl_count;

	counter myCounter(en_count,cl_count, ck, r_l, count);
	
	enum bit {WAIT, RECEIVE}curr,nxt;
	
	always_ff @(posedge ck, negedge r_l)
		if(~r_l) curr <= WAIT;
		else curr<=nxt;
	
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
					0: valueReceived.b = payload;
					1: valueReceived.c = payload;
					2: valueReceived.d = payload;
					default: valueReceived = 0;
				endcase
			end
		endcase
endmodule : consumer

module top;

	pay valueToSend, valueReceived;
	bit [7:0] payload;
	bit free, put;
	bit ck,r_l;

	producer p(.*);
	consumer c(.*);
	
	initial begin
		r_l = 0; ck = 0;
		#5 r_l = 1;
		forever #5 ck = ~ck;
	end

	initial begin
		valueToSend.a <= $urandom_range(8'hFF,0);
		valueToSend.b <= $urandom_range(8'hFF,0);
		valueToSend.c <= $urandom_range(8'hFF,0);
		valueToSend.d <= $urandom_range(8'hFF,0);
		repeat (3) begin
				repeat (5) @(posedge ck);
				assert (valueReceived == valueToSend)
					$display ("Message Sent!");
				else
					$display("Message did not send...you suck!");
		end
		$finish;
	end 
/*
	property checkMessageSent;
		@(posedge ck) (put) |-> ##4 (valueReceived == valueToSend);
	endproperty	
		
	assert property (checkMessageSent)
			$display ("Message Sent!");
	else
			$display("Message did not send...you suck!");
*/
endmodule : top

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
