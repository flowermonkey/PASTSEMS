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
  output bit [3:0] put_outbound;
  output [3:0][7:0] payload_outbound;

  // source -> self (receiving a payload)
  output bit [3:0] free_inbound;
  input [3:0] put_inbound;
  input [3:0][7:0] payload_inbound;
  
  //Control points 
  bit [3:0] rr_ld;
  bit [3:0] sr_en;
  
  //Status Points
  bit found_port; 
  bit [3:0] sent;
  bit [3:0] rm; /*reconstructed message bit*/

  //Wires
  bit [1:0] port;
  bit [3:0] [31:0] data;
  bit [3:0] [3:0] loc;

  //Module instantiations
  rec_reg rr0(.data_in(payload_inbound[0]), .data_out(data[0]), .loc(loc[0]), 
  				.rr_ld(rr_ld[0]), .rm(rm[0]), .id(ROUTERID), .*);
  rec_reg rr1(.data_in(payload_inbound[1]), .data_out(data[1]), .loc(loc[1]), 
  				.rr_ld(rr_ld[1]), .rm(rm[1]), .id(ROUTERID), .*);
  rec_reg rr2(.data_in(payload_inbound[2]), .data_out(data[2]), .loc(loc[2]), 
  				.rr_ld(rr_ld[2]), .rm(rm[2]), .id(ROUTERID),.*);
  rec_reg rr3(.data_in(payload_inbound[3]), .data_out(data[3]), .loc(loc[3]), 
  				.rr_ld(rr_ld[3]), .rm(rm[3]), .id(ROUTERID), .*);
  
  send_register sr0(.sr_en(sr_en[0]), .data_in(data[0]),.sent(sent[0]), 
  					.data_out(payload_outbound),.loc(loc[0]),.put_outbound(put_outbound[0]),.*);
  send_register sr1(.sr_en(sr_en[1]), .data_in(data[1]),.sent(sent[1]), 
  					.data_out(payload_outbound),.loc(loc[1]),.put_outbound(put_outbound[1]),.*);
  send_register sr2(.sr_en(sr_en[2]), .data_in(data[2]),.sent(sent[2]), 
  					.data_out(payload_outbound),.loc(loc[2]),.put_outbound(put_outbound[2]),.*);
  send_register sr3(.sr_en(sr_en[3]), .data_in(data[3]),.sent(sent[3]), 
  					.data_out(payload_outbound),.loc(loc[3]),.put_outbound(put_outbound[3]),.*);
  
  port_picker pp(.*);
	
  //FSM State Instantiation
  enum{start, load_node, send_node} st,ns;

	always_ff @(posedge clk, negedge rst_b) begin
		//on reset, go back to Start State
		if(~rst_b) begin
			st<= start;
		end
		else st<=ns;
	end

	always_comb begin
		//Zerp all signals 
		rr_ld =0; sr_en=0; free_inbound = 4'd0;
		
		unique case (st)
			//Start State: Controls when router is to recieve/send data from nodes
			start: begin
				//free to recieve values if anyone is ready
				free_inbound = 4'b1111;

				//if Round-Robin function finds a free node
				//send message to it
			    if(found_port)begin	
					ns = send_node;
				end
				
				//if messages are being sent to any nodes
				//load them into recieving registers
				else if (put_inbound > 0)begin	
					ns = load_node;           
					rr_ld = put_inbound;
				end

				//else remain in start state
				else begin 
					ns=st;
				end
			end
			
			//Load_Node State : loads messages from all senging nodes
			load_node: begin
				//remain in this state until all sent messages have been
				//recieved
				if(rm < put_inbound) begin
					ns = st;
					rr_ld = put_inbound;
				end	
				//else go back to Start State
				else
					ns = start;
			end

			//Send_Node State : sends messages to next Round-Robined node
			send_node: begin
				//remain in state until message is sent
				if(~sent[port]) begin
					ns = st;
					sr_en[port] =1;
				end
				else begin
					ns = start;
				end
			end
		endcase
	end
endmodule

//Recieving Register:
//Function to recieve and reconstruct message from node
module rec_reg (clk, rst_b, rr_ld, data_in, id, rm,loc, data_out);
  input bit clk, rst_b, rr_ld;
  input bit [7:0] data_in;
  input bit  [31:0] id;
  output bit [31:0] data_out;
  output bit rm; 	/*reconstructed message variable*/
  output bit [3:0] loc;
	
  //local variable
  bit [2:0] count;

  	always_ff @(posedge clk, negedge rst_b) begin
  		//on reset zero data
		if(~rst_b) begin 
			data_out <= 0;
			count <=0;
			rm <=0;
		end
		//load payloads into shift register
		else if(rr_ld) begin			
			data_out <= data_out<<8; 
			data_out[7:0]<= data_in;
			count++;
		end
		else
			data_out <= data_out;
		
		//if done recieve set done signals and get destID
		if(count==4)begin
			rm <=1;
			count <= 0;
			case (data_out[19:16])		//get destination location
				0: if(id) loc <=3; 
				   else loc <=0;
				1: if(id) loc <=3;
				   else loc <=2;
				2: if(id) loc <=3;
				   else loc <=3;
				3: if(id) loc <=0; 
				   else loc <=1;
				4: if(id) loc <=1; 
				   else loc <=1;
				5: if(id) loc <=2; 
				   else loc <=1;
			endcase
		end

 	end
endmodule

//Function: to pick next port in Round-Robin Scheme
module port_picker (clk, rst_b, free_outbound,data, port, found_port);
  input bit clk, rst_b;
  input [3:0] free_outbound;
  input bit [3:0] [31:0] data;
  output bit [1:0] port;
  output bit found_port;
  //Round-Robin Lead Variable
  bit [1:0] leader;   
	
	always_ff @(posedge clk, negedge rst_b)begin
		//on reset, reset all variables
		if (~rst_b) begin
			port <= 0;
			found_port <= 1;
			leader <= 0;
		end

		//set found signal as default
		found_port = 1;	
		
		//case statement for method of searching router 
		//depending on the Lead, makes cirle around ports
		unique case (leader)
			2'd0:begin
				if(free_outbound[0] & (data[0]!= 32'd0)) port <= 0;
				else if(free_outbound[1] & (data[1]!= 32'd0)) port <= 1;
				else if(free_outbound[2] & (data[2]!= 32'd0)) port <= 2;
				else if(free_outbound[3] & (data[3]!= 32'd0)) port <= 3;
				else found_port = 0;
			end
			2'd1:begin
				if(free_outbound[1] & (data[1]!= 32'd0)) port <= 1;
				else if(free_outbound[2] & (data[2]!= 32'd0)) port <= 2;
				else if(free_outbound[3] & (data[3]!= 32'd0)) port <= 3;
				else if(free_outbound[0] & (data[0]!= 32'd0)) port <= 0;
				else found_port = 0;
			end
			2'd2:begin
				if(free_outbound[2] & (data[2]!= 32'd0)) port <= 2;
				else if(free_outbound[3] & (data[3]!= 32'd0)) port <= 3;
				else if(free_outbound[0] & (data[0]!= 32'd0)) port <= 0;
				else if(free_outbound[1] & (data[1]!= 32'd0)) port <= 1;
				else found_port = 0;
			end
			2'd3:begin
				if(free_outbound[3] & (data[3]!= 32'd0)) port <= 3;
				else if(free_outbound[0] & (data[0]!= 32'd0)) port <= 0;
				else if(free_outbound[1] & (data[1]!= 32'd0)) port <= 1;
				else if(free_outbound[2] & (data[2]!= 32'd0)) port <= 2;
				else found_port = 0;
			end
		endcase
	end
endmodule


//Send Message Register :
// Function is to send out data to Node that is ready
module send_register (clk, rst_b, sr_en, data_in,loc, sent, put_outbound, data_out);
  input clk, rst_b;
  input bit sr_en;
  input bit [31:0] data_in;
  output bit sent;
  input bit [3:0] loc;
  output bit put_outbound;
  output bit [3:0] [7:0] data_out;
  
  //local variables
  bit [7:0] temp[4];
  bit [2:0] count;

	always_ff @(posedge clk, negedge rst_b) begin
		//on reset make all registers zero
		if(~rst_b) begin
			data_out[loc] <= 0;
			count <= 0;
			sent <= 0;
			temp[0] <= 8'b0;
			temp[1] <= 8'b0;
			temp[2] <= 8'b0;
			temp[3] <= 8'b0;
		end
		//if first data is being recieved 
		//set data out with first payload
		else if(sr_en & (count==0))begin
			temp[0] <= data_in[31:24];
			temp[1] <= data_in[23:16];
			temp[2] <= data_in[15:8];
			temp[3] <= data_in[7:0];
			data_out[loc] <= data_in[31:24];
			put_outbound <= 1; //set output signal 
			count++;
		end

		//if enabled and not first 
		//refresh temp registers
		//send rest of payloads
		else if (sr_en)begin
			temp[0] <= temp[0];
			temp[1] <= temp[1];
			temp[2] <= temp[2];
			temp[3] <= temp[3];
			
			//send remaining payloads
			if (count < 4) begin
				data_out[loc] <= temp[count];
				put_outbound <= 1; //continue to set output signal
				count++;
			end

			//if done end sending signal and update status signals
			else if (count == 4)begin
				put_outbound <= 0;
				sent <= 1;
				count <=0;
			end
		end
		else 
			sent<=0;
	end
endmodule
