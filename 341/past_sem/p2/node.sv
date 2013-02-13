module node(clk, rst_b, pkt_in, pkt_in_avail, cQ_full, pkt_out, pkt_out_avail,
            free_outbound, put_outbound, payload_outbound,
            free_inbound, put_inbound, payload_inbound);

  parameter NODEID = 0;
  input clk, rst_b;

  // Interface to TestBench
  input pkt_t pkt_in;
  input pkt_in_avail;
  output bit cQ_full;
  output pkt_t  pkt_out;
  output logic pkt_out_avail;

  // Endpoint -> Router transaction
  input bit free_outbound; // Router -> Endpoint
  output bit put_outbound; // Endpoint -> Router
  output [7:0] payload_outbound;

  // Router -> Endpoint transaction
  output bit free_inbound; // Endpoint -> Router
  input bit put_inbound; // Router -> Endpoint
  input [7:0] payload_inbound;
  
  //Control Points
  bit we,re,sel;
  bit en_SIPO, en_PISO;
  
  //Status Points
  bit fifo_full,fifo_empty; 
  bit done_PISO;

  //Wires
  bit [31:0] message; 
  bit [31:0] fifo_input;
  
  //Module Instantiations
  demux input_selector (.*);  
  register_SIPO pkt_builder(.*);
  register_PISO payload_splitter(.done(done_PISO), .*);
  fifo out_buffer(.data_in(fifo_input),.full(fifo_full),.empty(fifo_empty),.data_out(message), .*);

  //FSM instantiation
  enum{start, load_out, load_tb, send_out, send_tb} st,ns;
  
  always_ff @(posedge clk, negedge rst_b) begin
  	if (~rst_b) st <= start;
  	else st <= ns;
  end
  
  always_comb begin
  //Zero all signals for consistant transitions 
  	sel =0; we =0; re =0; cQ_full=0; pkt_out_avail =0; 
	free_inbound=0; en_SIPO=0; en_PISO =0;
  	
	unique case (st)
		//Start State: Controls what message Node will be recieveing/sending
		start: begin
			//in case of load from outside, set free
			free_inbound = 1;

			//check if TB has pkt
			if(pkt_in_avail)         
				ns = load_tb;

			//check if router sending message
			else if(put_inbound)begin    
				ns = load_out;
				we = 1;
				sel = 1;
			end

			//send non-zero message to router if node ready and router ready
			else if (free_outbound & ~fifo_empty & (message>0)) begin
				ns = send_out; 
			end

			//else remain in Start State
			else
				ns = st;
		end
		
		//Load_Out State: Will load a message to Router
		load_out: begin
			//if queue is not full entire message has not been recieved
			//therefore remain in this state until it is full
			if(~fifo_full) begin
				ns = st;
				we = 1;
				sel = 1;
			end
			
			//finshed collecting 
			else begin
				ns = send_tb;	
			end
		end
		
		//Load_TB State: Loads pkt from TB 
		load_tb: begin	
			//if queue is full we cannot load
			if(~fifo_full) begin
				ns = start;
				cQ_full = 1;	        
				sel = 0;
				we = 1;
			end
		end
		
		//Send_Out State: Sends	a message to Router
		send_out: begin
			//Message is not sent out until PISO register is empty
			//stay in this state until that is true
			if(~done_PISO) begin	
				ns = st;
				re = 1;
				en_PISO=1;
			end

			//finished sending
			else
				ns = start;
		end
		
		//Send_TB State: Sends pkt to TB
		send_tb:begin
			//Pkt not competely sent until queue is empty
			//remain in this state till that is true
			if(~fifo_empty)begin
				ns=st;
				re=1;
				en_SIPO=1;
			end

			//finished sending tell TB pkt ready
			else begin
				ns = start;
				pkt_out_avail = 1;	
			end
		end
  	endcase
  end
endmodule


/*  Create a fifo (First In First Out) with depth 4 using the given interface and constraints.
 *  -The fifo is initally empty.
 *  -Reads are combinational
 *  -Writes are processed on the clock edge.  
 *  -If the "we" happens to be asserted while the fifo is full, do NOT update the fifo.
 *  -Similarly, if the "re" is asserted while the fifo is empty, do NOT update the fifo. 
 */

module fifo(clk, rst_b, data_in, we, re, full, empty, data_out);
  parameter WIDTH = 32;
  input bit clk, rst_b;
  input bit [WIDTH-1:0] data_in;
  input bit we; //write enable
  input bit re; //read enable
  output bit full;
  output bit empty;
  output bit [WIDTH-1:0] data_out ;
  
  //local variables
  bit [WIDTH-1:0] data[4]; //temp registers
  bit [2:0] i, j; //indeces
	
	always_ff @(posedge clk, negedge rst_b) begin
		//on reset, make all temp registers, and signals 0
		if(~rst_b)begin
			data[0] <= 32'b0;
			data[1] <= 32'b0;
			data[2] <= 32'b0;
			data[3] <= 32'b0;
			data_out <= 32'b0;
			empty <= 1;
			full <= 0;
			i <= 0;
			j <=0;
		end
		
		//Can only write if queue is not full
		//Write is done using non-blocking statements
		if (we & ~full) begin
			//first element shoud also appear in data_out
			if (i==0) data_out <= data_in;
			empty <= 0;

			//for each added element increment tail index
			if(i<4)begin
				data[i]<=data_in;
				i++;
			end
			//else we are full
			else begin
				full<=1;
			end
		end

		//Can only read whule queue is not empty
		//read is done is combinational logic
		else if(re & ~empty)begin
			//read out first (head) element
			data_out = data[j];
			j++;
			full = 0;
			empty = 0;

			//if head index == tail index, we are empty once again
			//therefore reset
			if (j==i)begin
				full = 0;
				empty = 1;
				i=0;
				j=0;
			end
		end

		//else reload same register values
		else begin 
			data_out<=data_out;
			data[0] <= data[0];
			data[1] <= data[1];
			data[2] <= data[2];
			data[3] <= data[3];
		end
	end
endmodule

//Function: to choose which input is seen by FIFO module
// if sel=1 : FIFO gets [7:0] payload
// if sel=0 : FIFO gets [31:0] pkt
module demux (pkt_in,payload_inbound,sel,fifo_input);
  input pkt_t pkt_in;
  input [7:0] payload_inbound;
  input bit sel;
  output bit [31:0] fifo_input;

  always_comb begin
  	if(~sel)
		fifo_input = pkt_in;
	else
		fifo_input = {payload_inbound,24'b0}; //pack the trailing end of 8'	payload
  end
endmodule

//Fuction : provide a method of shifting in a 8' payload and make a 32 pkt
module register_SIPO (clk, rst_b, message, en_SIPO, pkt_out);
  input bit [31:0] message;
  input bit clk, rst_b, en_SIPO;
  output  pkt_t pkt_out;

  bit [2:0] count;

  	always_ff @(posedge clk, negedge rst_b) begin
		//on reset, make all variables zero
		if(~rst_b)begin
			pkt_out <= 32'b0;
			count <=0;
		end
		// if register is enabled shift in payloads
		// define sourceID and destID with shifted values
		// done due to compling errors
		else if (en_SIPO & count<4)begin
			pkt_out <= pkt_out>>8;
			pkt_out.sourceID <= message [31:28];
			pkt_out.destID <= message [27:24];
			count++;
		end	
		// else relod pkt
		else
			pkt_out <= pkt_out;
	end
endmodule

//Function : provide a method of shifting out 8' payloads from a 32' pkt
module register_PISO (clk, rst_b, message, en_PISO,done,put_outbound, payload_outbound);
  input bit clk, rst_b, en_PISO;
  input bit [31:0] message;
  output bit [7:0] payload_outbound;
  output bit put_outbound;
  output bit done;

  // local variables
  bit [7:0] temp[4];
  bit [3:0] count;

	always_ff @(posedge clk, negedge rst_b) begin
		//on reset 0 all variables 
		if (~rst_b) begin
			temp[0] <= 8'b0;
			temp[1] <= 8'b0;
			temp[2] <= 8'b0;
			temp[3] <= 8'b0;
			payload_outbound <=0;
			put_outbound <= 0;
			done <=0;
			count <=0;
		end

		//clear status signals 
		done<=0;
		put_outbound<=0;	
		
		//if enabled and first values 
		//save entire pkt into temp registers and
		//load first payload
		if(en_PISO & (count==0))begin
			temp[0] <= message[31:24];
			temp[1] <= message[23:16];
			temp[2] <= message[15:8];
			temp[3] <= message[7:0];
			payload_outbound <= message[31:24];
			put_outbound <= 1;		//send signal for outputing payload
			count++;
		end

		//if enabled but not first value
		//refresh temp registers and load 
		//next payloads
		else if (en_PISO) begin
			temp[0] <= temp[0];
			temp[1] <= temp[1];
			temp[2] <= temp[2];
			temp[3] <= temp[3];
			
			//load next payloads
			if (count < 4) begin
				payload_outbound <= temp[count];
				put_outbound <= 1; //continue to send signal
				count++;
			end
			//if last payload, update status signals
			else if (count == 4) begin
				put_outbound <= 0; //stop sending signal
				done <= 1;
				count <=0;
			end
		end	
	end
endmodule
