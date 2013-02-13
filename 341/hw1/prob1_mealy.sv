`default_nettype none

typedef struct packed{
		bit[7:0] a,b,c,d;
}pay;

module producer(
	input pay valueToSend,
	input bit free,ck,r_l, 
	output bit put,
	output bit sent,
	output bit [7:0] payload);
		
	bit [2:0] count;
	bit en_count, cl_count;

	counter myCounter(en_count,cl_count, ck, r_l, count);
	
	enum bit {WAIT,SEND}curr;

	always_ff @(posedge ck, negedge r_l) begin
		if(~r_l)	curr <= WAIT;
		else case(curr)
				WAIT :begin
							curr <= (~free) ? WAIT : SEND;
							{payload,put,en_count,sent} <= 0;
			 				cl_count <= 1;
				end
				SEND :begin
							curr <= (count!=4) ? SEND : WAIT;
							{put,en_count} <= 3;
			 				{sent,cl_count} <= 0;
							
							case (count)
								0: payload <= valueToSend.a;
								1: payload <= valueToSend.b;
								2: payload <= valueToSend.c;
								3: payload <= valueToSend.d;
							default: payload <= 0;
							endcase
							
							if (count == 4) begin
								{payload,put,en_count} <= 0;
			 					{sent,cl_count} <= 3;
							end
				end

				default: curr <= WAIT;
				endcase
	end 
endmodule : producer
	
module consumer(
	input bit [7:0] payload,
	input bit put,ck,r_l,
	output bit free, received,
	output pay valueReceived);
	
	bit [2:0] count;
	bit en_count, cl_count;

	counter myCounter(en_count,cl_count, ck, r_l, count);
	
	enum bit {WAIT, RECEIVE}curr;
	
	always_ff @(posedge ck, negedge r_l) begin
		if(~r_l)  curr <= WAIT;
		else case (curr) 
					WAIT: begin 
								curr <=(~put) ? WAIT : RECEIVE;
								{free,cl_count} <= 3;
								valueReceived <= (~put) ? 0 : {payload, 24'b0};
								{en_count,received}<=0;
					end
					RECEIVE:begin
									curr <= (count!=3) ? RECEIVE : WAIT;
					
									{free,received,cl_count} <= 0;
									en_count <= 1;
									case (count) //alt. shift in while(put)
										0: valueReceived.b <= payload;
										1: valueReceived.c <= payload;
										2: valueReceived.d <= payload;
									default: valueReceived <= 0;
									endcase
						
									if (count == 3) begin	
										{free,received,cl_count} <= 7;
										valueReceived <= (~put) ? 0 : {payload, 24'b0};
										en_count <=0;
									end
					end
					
					default: curr <= WAIT;
				endcase
	end
endmodule : consumer

module top;

	pay valueToSend, valueReceived;
	bit [7:0] payload;
	bit free, put, sent, received;
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
		@(posedge ck)
		repeat (3) begin
				repeat (6) @(posedge ck);
				assert (valueReceived == valueToSend)
					$display ("Message Sent!");
				else
					$display("Message did not send...you suck! %x", valueReceived);
		end

//	repeat (25) @(posedge ck);
		$finish;
	end

/*
	property checkMessageSent;
		@(posedge ck) (put) ##4 (sent == 1) ##1 (received == 1);
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
		 output logic [2:0] count);

//active on a clk or reset_L for sync and async functionality
	always_ff @ (posedge ck, negedge r_l)
		if(~r_l | clear) 
			count <= 0;
		else if (enable)
			count <= count+1;
endmodule: counter
