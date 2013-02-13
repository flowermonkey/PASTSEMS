/*
 * A router transfers packets between nodes and other routers.
 */
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
  output [3:0] free_inbound; //message top node saying I'm free
  input [3:0] put_inbound;
  input [3:0][7:0] payload_inbound;

///////////////////////MY CODE///////////////////////////////

	pkt_t [3:0] valueReceived, valueToSend, topQ, sendOut;
	bit [3:0] regfree, ld, re, en_send, Q_empty, Q_full;
	bit [3:0] pkt_in_avail; //indicates when message is recieved from node
	genvar j;

//Generate 4 sets of buffers, fifos, and counters
	generate 
		for(j=0; j<4; j=j+1) begin: B1
			consumer input_buf(.ck(clk),.r_l(rst_b),
												 .valueReceived(valueReceived[j]),
												 .free(free_inbound[j]),
												 .full(Q_full[j]),
												 .put(put_inbound[j]),
												 .done(pkt_in_avail[j]),
												 .payload(payload_inbound[j]));

			producer output_buf(.ck(clk), .r_l(rst_b),
													.valueToSend(valueToSend[j]),
													.free(free_outbound[j]), 
													.enable(en_send[j]),
													.put(put_outbound[j]),
													.payload(payload_outbound[j]));

			fifo #(32,9) waitList(.clk(clk),.rst_b(rst_b), 
										.data_in(valueReceived[j]), 
										.we(pkt_in_avail[j]),.re(re[j]), 
										.full(Q_full[j]), 
										.empty(Q_empty[j]), 
										.data_out(topQ[j]));
			
			counter_reg coutReg (.clk(clk), .rst_b(rst_b), .ld(ld[j]), 
								 				.free(regfree[j]));
		end
	endgenerate

	//secretary organizes all pkts to correct locations
	secretary #(ROUTERID) s(.*);
			
endmodule

module secretary(input bit clk, rst_b,
								 input bit [3:0] Q_empty, regfree,
								 input pkt_t [3:0] topQ,
								 output pkt_t [3:0] valueToSend,
								 output bit [3:0] ld, re,en_send);
 
 parameter ROUTERID = 0; // To differentiate between routers
	
	bit [3:0] j;

//This always_comb block defines the priority scheme. 
//Nodes at port 0 have highest priority, and nodes at port 3 have lowest
	always_comb begin
		ld = 4'b0; re = 4'b0; en_send = 4'b0;
	
	//for each node in router
		for(j=0; j<4; j++) begin
		//define which router we are in		
			if(ROUTERID == 0) begin
				//if counter indicates that there is no current pkt being sent
				//and the fifo is not empty
				//and this is the dest Node for pkt  -> then load in
					if (regfree[0] & ~Q_empty[j] & (0 == topQ[j].destID))begin
							if(ld[0]) continue; // if ld were already set, means
																	//	current pkt must wait its turn
								re[j] = 1;
								en_send[0] = 1;
								ld[0] = 1;
								valueToSend[0] = topQ[j];
								break;
					end
					else if (regfree[1] & ~Q_empty[j] & (2 < topQ[j].destID))begin
							if(ld[1]) continue; 	
								re[j] = 1;
								en_send[1] = 1;
								ld[1] = 1;
								valueToSend[1] = topQ[j];
								break;
					end
					else if (regfree[2] & ~Q_empty[j] & (1 == topQ[j].destID))begin
							if(ld[2]) continue; 	
								re[j] = 1;
								en_send[2] = 1;
								ld[2] = 1;
								valueToSend[2] = topQ[j];
								break;
					end
					else if (regfree[3] & ~Q_empty[j] & (2 == topQ[j].destID))begin
							if(ld[3]) continue; 	
								re[j] = 1;
								en_send[3] = 1;
								ld[3] = 1;
								valueToSend[3] = topQ[j];
								break;
					end
			end
		//Similarly for Rounter 1
			if(ROUTERID == 1) begin
					if (regfree[0] & ~Q_empty[j] & (3 == topQ[j].destID))begin
							if(ld[0]) continue; 	
								re[j] = 1;
								ld[0] = 1;
								en_send[0] = 1;
								valueToSend[0] = topQ[j];
								break;
					end
					else if (regfree[1] & ~Q_empty[j] & (4 == topQ[j].destID))begin
							if(ld[1]) continue; 	
								re[j] = 1;
								ld[1] = 1;
								en_send[1] = 1;
								valueToSend[1] = topQ[j];
								break;
					end
					else if (regfree[2] & ~Q_empty[j] & (5 == topQ[j].destID))begin
							if(ld[2]) continue; 	
								re[j] = 1;
								ld[2] = 1;
								en_send[2] = 1;
								valueToSend[2] = topQ[j];
								break;
					end
					else if (regfree[3] & ~Q_empty[j] & (3 > topQ[j].destID))begin
							if(ld[3]) continue; 	
								re[j] = 1;
								ld[3] = 1;
								en_send[3] = 1;
								valueToSend[3] = topQ[j];
								break;
					end
			end
		end
	end

endmodule

//Counter that can indicate when it is ok to send another pkt to 
//output register (router to node)
module counter_reg(input bit clk, rst_b, ld, output bit free);
	
	bit [3:0] count;
	
	assign free = (count>4);
	
	always_ff @(posedge clk, negedge rst_b) begin
			if(~rst_b)	 count <= 0;
			else if (ld) count <= 0;
			else  			 count <= count +1;
	end
endmodule
