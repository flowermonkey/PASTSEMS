`default_nettype none

// Write your usb host here.  Do not modify the port list.
module usbHost
  (input logic clk, rst_L, 
  usbWires wires);
	
	bit on_bitStuff, on_crc,
		en_cable, stall,syncing,
		inBit, nBit, OGbit5,OGbit16, sBit,eop,
		mux_sel, mux1_out, spe_sel, mux2_out,
		in2, ld_reg;
	bit en_count, cl_count;
	bit [7:0] count;	
		
	bit receive, done_receive, ok, ack, nak, receiverRst;
	bit [63:0] messageReceived;

	bit done_crc5, done_crc16; //Might not need crc dones

	bit [2:0] indicator;
	bit sendingRequest, reading, writing;
	bit resend,done;
	bit [3:0] sentTimes;

	crc5Sender bitStreamEncoder5(.in(inBit), .bit_out(OGbit5),
									.on(on_crc), .done(done_crc5), .*);
	crc16Sender bitStreamEncoder16(.in(inBit), .bit_out(OGbit16),
									.on(on_crc), .done(done_crc16), .*);
	
	mux2 bitSelector(.in1(OGbit5), .in2(OGbit16), .sel(mux_sel), .out(mux1_out));	
	stuffBit 	bitStuffer(.in(mux1_out), .out(sBit),.on(on_bitStuff), .*);
	
	nrzi_encoder nrzi(.in1(sBit),.in2(in2),.out(nBit)); 
	register bitReg(.inBit(nBit), .outBit(in2), .*);
	mux2 speSelector(.in1(inBit), .in2(nBit), .sel(spe_sel), .out(mux2_out));
	wireCoder cable(.in(mux2_out),.enable(en_cable), .*);
	
	receiver R(.on(receive),.done(done_receive), .*);

	counter #(8) c(.enable(en_count), .on(1'b0), .clear(cl_count), .stall(stall), .*);
	
	/* Tasks needed to be finished to run testbenches */

  task prelabRequest/*{{{*/
  // sends an OUT packet with ADDR=5 and ENDP=4
  // packet should have SYNC and EOP too
  (input bit  [15:0] data);
		sentTimes = 0;
		sendingRequest <= 1;
		@(posedge clk);		

		on_bitStuff = 0;
		on_crc = 0;
 		{mux_sel, spe_sel} = 2'b01;
		en_cable = 1;
		ld_reg = 1;
		syncing = 1;

//Sengin OUT
		$display("Sending sync...");	
		sendSync;
		$display("Sending PID...");
		sendPid(4'd1);
		syncing = 0;

		$display("Sending Address and endP...");
		sendAE(4'd4);
		repeat(6) @(posedge clk);
		$display("Sending EOP...");
		sendEOP;
	
		en_cable = 0;
		ld_reg = 0;
		sendingRequest <= 0;
		@(posedge clk);
  endtask: prelabRequest
/*}}}*/

//READ DATA {{{
	task readData
  // host sends memPage to thumb drive and then gets data back from it
  // then returns data and status to the caller
  (input  bit [15:0]  mempage, // Page to write
   output bit [63:0] data, // array of bytes to write
   output bit        success);
		reading <= 1;
    
		receive = 1'b0; 
    	
		sentTimes = 0;
		@(posedge clk);		

		on_bitStuff = 0;
		on_crc = 0;
 		{mux_sel, spe_sel} = 2'b01;
		en_cable = 1;
		ld_reg = 1;
		syncing = 1;

//Sending OUT {{{
		$display("Sending sync...");	
		sendSync;
		$display("Sending PID...");
		sendPid(4'd1);
		syncing = 0;

		$display("Sending Address and endP...");
		sendAE (4'd4);
		repeat(6) @(posedge clk);
		$display("Sending EOP...");
		sendEOP;
				
		en_cable = 0;
		ld_reg = 0;

		receive = 1'b1; 
		repeat (30) @(posedge clk);
//			do begin
		//	wait({resend, done} == 2'b0);
			//	if (resend)

//			@(posedge clk);
//		end while (~done); 
		receive = 1'b0; 
/*}}}*/

//Sending memPage {{{	
		@(posedge clk);		
		en_cable = 1;
		ld_reg = 1;
		syncing = 1;
		
		$display("Sending sync...");
		sendSync;
		$display("Sending PID...");
		sendPid(4'b0011);
		syncing = 0;
		
		$display("Sending Data...");
		sendData(mempage);
		repeat(16) @(posedge clk);
		
		$display("Sending EOP...");
		receiverRst <= 0;

		sendEOP;
		sentTimes <= sentTimes +1;

		en_cable = 0;
		ld_reg = 0;

		receive = 1'b1; 
		
		do begin
		//	wait({resend, done} == 2'b0);
			
			if (resend)
					resendData(data);
			@(posedge clk);
		end while (~done); 
   
		receive = 1'b0; 
	 	
/*}}}*/

//Sending IN {{{

		syncing = 1;
		en_cable = 1;
		ld_reg = 1;

		$display("Sending sync...");	
		sendSync;
		$display("Sending PID...");
		sendPid(4'b1001);
		syncing = 0;

		$display("Sending Address and endP...");
		sendAE (4'd8);
		repeat(6) @(posedge clk);
		$display("Sending EOP...");
		sendEOP;
		
		en_cable = 0;
		ld_reg = 0;

		receive = 1'b1; 
			do begin
		//	wait({resend, done} == 2'b0);
			//	if (resend)

			@(posedge clk);
		end while (~done); 
		receive = 1'b0; 
/*}}}*/

		data = messageReceived; 
		success = ack;

		reading <= 0;
		@(posedge clk);
  endtask: readData /*}}}*/
	
//WRITE DATA {{{
  task writeData
  // Host sends memPage to thumb drive and then sends data
  // then returns status to the caller
  (input  bit [15:0]  mempage, // Page to write
   input  bit [63:0] data, // array of bytes to write
   output bit        success);
		writing <= 1;

		receive = 1'b0; 
    	
		sentTimes = 0;
		@(posedge clk);		

		on_bitStuff = 0;
		on_crc = 0;
 		{mux_sel, spe_sel} = 2'b01;

//Sending OUT {{{
		en_cable = 1;
		ld_reg = 1;
		syncing = 1;
	
		$display("Sending sync...");	
		sendSync;
		$display("Sending PID...");
		sendPid(4'd1);
		syncing = 0;

		$display("Sending Address and endP...");
		sendAE (4'd4);
		repeat(6) @(posedge clk);
		$display("Sending EOP...");
		sendEOP;
		
		en_cable = 0;
		ld_reg = 0;

		receive = 1'b1; 
		repeat (100) @(posedge clk);
//			do begin
		//	wait({resend, done} == 2'b0);
			//	if (resend)

//			@(posedge clk);
//		end while (~done); 
		receive = 1'b0; 
/*}}}*/

//Sending memPage {{{	
	/*	@(posedge clk);		
		en_cable = 1;
		ld_reg = 1;
		syncing = 1;
		
		$display("Sending sync...");
		sendSync;
		$display("Sending PID...");
		sendPid(4'b0011);
		syncing = 0;
		
		$display("Sending Data...");
		sendData(mempage);
		repeat(16) @(posedge clk);
		
		$display("Sending EOP...");
		receiverRst <= 0;

		sendEOP;
		
		en_cable = 0;
		ld_reg = 0;

		sentTimes <= sentTimes +1;

		receive = 1'b1; 
		
		do begin
		//	wait({resend, done} == 2'b0);
			
			if (resend)
					resendData(data);
			@(posedge clk);
		end while (~done); 
   
		receive = 1'b0; 
	 */	
/*}}}*/

//Senging OUT {{{
/*		en_cable = 1;
		ld_reg = 1;
		syncing = 1;

		$display("Sending sync...");	
		sendSync;
		$display("Sending PID...");
		sendPid(4'd1);
		syncing = 0;

		$display("Sending Address and endP...");
		sendAE (4'd8);
		repeat(6) @(posedge clk);
		$display("Sending EOP...");
		sendEOP;

		en_cable = 0;
		ld_reg = 0;
		
		receive = 1'b1; 
			do begin
		//	wait({resend, done} == 2'b0);
			//	if (resend)

			@(posedge clk);
		end while (~done); 
		receive = 1'b0; 
*//*}}}*/

//Sending Data {{{	
/*		@(posedge clk);		
		en_cable = 1;
		ld_reg = 1;
		syncing = 1;
		
		$display("Sending sync...");
		sendSync;
		$display("Sending PID...");
		sendPid(4'b0011);
		syncing = 0;
		
		$display("Sending Data...");
		sendData(data);
		repeat(16) @(posedge clk);
		
		$display("Sending EOP...");
		receiverRst <= 0;

		sendEOP;

		en_cable = 0;
		ld_reg = 0;

		sentTimes <= sentTimes +1;

		receive = 1'b1; 
		
		do begin
		//	wait({resend, done} == 2'b0);
			
			if (resend)
					resendData(data);
			@(posedge clk);
		end while (~done); 
   
		receive = 1'b0; 
*/	 	
/*}}}*/

		success = ack;

		writing <= 0;
		@(posedge clk);
  endtask: writeData/*}}}*/

//EXTRA TASKS {{{
	task sendSync;
		bit [4:0] cnt;
		bit [7:0] sync = 8'b1000_0000;
	
		on_bitStuff = 1;
		for(cnt = 0; cnt<8; cnt++) begin
			inBit <= sync[cnt]; 
			@(posedge clk);
			on_bitStuff = 0;
		end
		
	endtask : sendSync

	task sendPid(input bit [3:0] pid);
		bit [5:0] i;  
		bit [7:0] pidOut;
		pidOut = {~pid,pid};
	
		for(i = 0; i<8; i++) begin
			inBit <= pidOut[i];
	  @(posedge clk);
		end              
	endtask: sendPid
	
	task sendAE (bit [3:0] endp);
		bit [5:0] i;  
		bit [6:0] addr = 7'd5;
		bit	[10:0]	addrOut; 

		addrOut = {endp,addr};
		
		on_crc = 1'b1;
		mux_sel = 1'b0;
		for(i = 0; i<11; i++) begin
			inBit <= addrOut[i];
	  	@(posedge clk);
			on_crc = 0;
		end          
	endtask: sendAE 

	task sendEOP;
		spe_sel = 1'b0;
		eop <= 1;
		@(posedge clk);
		@(posedge clk);
		eop <= 0;
		inBit <=1; 
		@(posedge clk);
		spe_sel = 1'b1;
	endtask: sendEOP
	
	task sendData(input bit [15:0] data);
		bit [5:0] i;  
		
		mux_sel = 1;
		on_crc = 1;
    
		for(i = 0; i<15; i++) begin
			inBit <= data[i];
    	@(posedge clk);
			on_crc = 0;
		end
		mux_sel = 0;
	endtask: sendData

	task resendData (input bit [15:0] data);
		
		@(posedge clk);		
		syncing = 1;
		
		$display("Sending sync...");
		sendSync;
		$display("Sending PID...");
		sendPid(4'b0011);
		syncing = 0;
		
		$display("Sending Data...");
		sendData(data);
		repeat(16) @(posedge clk);
		
		$display("Sending EOP...");
		sendEOP;
		sentTimes <= sentTimes+1;

	endtask
/*}}}*/

	//FSM_PROTCOL {{{
	enum bit [2:0] {IDLE, START, RESEND, END} nxt, curr;

	assign indicator = {sendingRequest,reading,writing};

	always_ff @(posedge clk, negedge rst_L) begin
			if(~rst_L)	curr <= IDLE;
			else	curr <= nxt;
	end

	always_comb begin
	done =0; resend = 0;
		case (curr)
			IDLE: begin
				{en_count, cl_count} = 2'b01;
				nxt = (indicator != 3'b0) ? START : curr;
			end

			START:begin
				{en_count, cl_count} = 2'b10;
				if (ack)
					nxt = END;
				else if (nak)
						nxt = RESEND;
				else if (count == 8'd255)
						nxt = RESEND;
				else
						nxt = curr;
			end 

			RESEND:begin
				{en_count, cl_count} = 2'b01;
				resend = 1'b1;
				nxt = (sentTimes == 3'd7) ? END : START;
			end

			END: begin
				{en_count, cl_count} = 2'b10;
				done = 1;
				nxt =  IDLE;
			end
		endcase
	end/*}}}*/
endmodule: usbHost

//RECEIVER MODULE {{{
module receiver 
	(input on, clk, rst_L, receiverRst,
		output bit done, ok, ack, nak,
		output bit [63:0] messageReceived,
		usbWires wires);

	logic bit_in;
	bit en_count, en_shift, in_crc16, start;
 	bit unstuffed, nrzied, old, on_stuff, on_cable;
  
	bit stall, clear, regRst, cl_count, en_pid; 
	
	bit [4:0] count;
	bit [15:0] crc16_out;
    bit [7:0] pid;

	crcCalc16 crc16(.in(in_crc16), .out(crc16_out), .*);
	counter c(.enable(en_count), .clear(cl_count), .on(1'b0), .*);
	SIPO_register message_reg(.in(unstuffed),.shift(en_shift),.rst_L(rst_L), .out(messageReceived), .*);
    SIPO_register #(8) pid_sync(.in(unstuffed), .shift(en_pid),.rst_L(rst_L), .out(pid), .*);
 	register delay(.inBit(nrzied), .outBit(old), .ld_reg(1'b1), .*);
  	nrzi_encoder nrziD(bit_in, old, nrzied);
  	unstuffBit unstuff(nrzied, on_stuff, clk, rst_L, unstuffed);
  	wireDecoder cable(/*.pos(wires.DP), .min(wires.DM),*/ .enable(on_cable), .out(bit_in),.*);

		// IDLE: receive SYNC, PID
	enum bit [2:0] {IDLE, SYNC, PID, CRC16, EOP} nxt,curr;
	
	//assign done = ((count == (crcType+6)));

	always_ff @(posedge clk, negedge rst_L) begin
		if (~rst_L) curr <= SYNC;
		else  curr <= nxt;
	end

	always_comb begin
		stall =0;
		if(~on)begin
				{on_stuff,on_cable,en_count,cl_count,
				 regRst,en_shift,ack,nak, en_pid} = 9'd0;
		end		
		else begin
			case (curr) 
				IDLE: begin
                	nxt = (on) ? SYNC:IDLE;
      			end
				SYNC:begin
             		$display($time,, "in SYNC, nxt = %s, bit_in is %d, nrzied is %d, unstuffed is %d, messageReceived is %b\n", nxt,bit_in, nrzied, unstuffed, pid);
                    on_stuff = 0;
                    on_cable = 1;
                    en_count = 0;
                    cl_count = 1;
                    en_shift = 0;
        		    //en_pid = ~(pid == 8'b10000000);
                    en_pid = 1;
//					en_count = 0;
	           		//cl_count = (pid == 8'b10000000);
  //                  cl_count = 0;
                    nxt = (pid == 8'b10000000) ? PID : SYNC; 
                	regRst = 1;
	            	if (pid == 8'b10000000)
                		$display("NOW IT SHOULD MOVE TO PID\n");
                end

              	PID: begin
                    $display($time,,"in PID, messageReceived is %b, count is %d, regRst is %d, clr_count is %d, unstuffed is %d, nrzied is %d, bit_in is %d\n", pid, count, regRst, cl_count, unstuffed, nrzied, bit_in);
                
		//		regRst = 1;
                	en_count = (count >= 5'd8) ? 0:1;
                	cl_count = 0;

                	en_shift= 0;
                	en_pid = (count >= 5'd8) ? 0:1;

                	on_stuff = 0;
                	on_cable = 1;
                	//nxt = (pid == 8'b00111100) ? CRC16 : curr;
                	regRst = 1;
               		// regRst = (pid == 8'b00011110) ? 0:1;
                	if  (count >= 5'd8) begin
                		if (pid == 8'b00101101) begin
                        	ack = 1;
                      	  	$display("an ACK is received!!\n");
                      	  	nxt = EOP;
                		end
                		else if (pid == 8'b10100101) begin
                        	nak = 1;
                        	$display("an NAK is received!!\n");  
                        	nxt = EOP;
                		end
                  		else if (pid == 8'b00111100) begin
                        	nxt = CRC16;
	                	end
						else
							nxt = SYNC;
    //	regRst = 0;
               		end
                	else begin 
                		$display("en_count is %d\n", en_count);
                    	ack = 0;
                    	nak = 0;
                    	nxt = curr;
  //                  	regRst = 1;
                   	//	en_count = 1;
                	end
            	end

        		CRC16: begin
                	{en_shift, en_count} = 2'b11;
                	in_crc16 = bit_in;
                	on_stuff = 1;
                	on_cable = 1;
               	 	en_pid = 0;
                	regRst = 1'b1;
                	nxt = (count == 5'd5) ? EOP : curr;
                	done = (count == 5'd5) ? 1:0 ;
                	ok = (crc16_out==16'b1000000000001101) ? 1:0;
        		end

        		EOP: begin
                	$display("in EOP\n");
                	on_stuff = 0;
                	on_cable = 1;
                	en_pid = 0;
                	{en_shift, en_count} = 2'b01;
                	nxt = (count == 5'd3) ? IDLE:curr;     
        		end
			endcase
		end
	end
   	    //0011
endmodule : receiver/*}}}*/

//CRC16 {{{
module crc16Sender (input bit in, on, stall, clk, rst_L,
		  						output bit bit_out, done);

	bit [6:0] count;
	bit [15:0] crc_out;
	bit crc_in, en_count,cl_count, 
			en_shift, ld_piso,
			piso_out, sel;
		
	crcCalc16 crc16(.in(crc_in), .out(crc_out),.*);
	
	PISO_register #(15) remainder_reg(.in(~crc_out[14:0]), .out(piso_out),
												.shift(en_shift), .load(ld_piso), .*);

	counter #(7) c(.enable(en_count),.clear(cl_count),.*);

	enum bit [1:0] {IDLE, MESSAGE, REMAINDER} nxt, curr;
	
	assign crc_in = (count == (7'd64)) ? (~crc_out[15]) : ((sel) ? piso_out : in);
	assign bit_out = crc_in;
	assign ld_piso = (count == (7'd64));
	assign done = (count == (7'd69));

	always_ff @(posedge clk, negedge rst_L) begin
			if (~rst_L | on) curr <= MESSAGE;
			else curr <= nxt;
	end
	
	always_comb begin
		if (stall) begin
				nxt = nxt;
				en_shift = en_shift;
				en_count = en_count;
				cl_count = cl_count;
				sel = sel;
		end
		else 
				case (curr)
					IDLE: begin 
						{en_shift,sel} = 2'd0;
						{en_count,cl_count} =2'b01;
						nxt = curr;
					end
					MESSAGE: begin
						{en_shift,sel} = 2'd0;
						{en_count,cl_count} =2'b10;
						nxt = (count == (7'd64)) ? REMAINDER : curr;
					end
					REMAINDER:begin
						{en_shift, sel} = 2'b11;
						{en_count,cl_count} =2'b10;
						nxt = (count == (7'd69)) ? IDLE : curr;
					end
				endcase
	end
endmodule : crc16Sender/*}}}*/

//CRC5 {{{
module crc5Sender (input bit in, on,syncing, stall, clk, rst_L,
		  						output bit bit_out, done);

	bit [4:0] count, crc_out;
	bit crc_in, en_count,cl_count, 
			en_shift, ld_piso,
			piso_out, sel;
		
	crcCalc5 crc5(.in(crc_in), .out(crc_out),.*);
	
	PISO_register #(4) remainder_reg(.in(~crc_out[3:0]), .out(piso_out),
												.shift(en_shift), .load(ld_piso), .*);

	counter c(.enable(en_count),.clear(cl_count),.*);

	enum bit [1:0] {IDLE, MESSAGE, REMAINDER} nxt, curr;
	
	assign crc_in = (count == (5'd11)) ? (~crc_out[4]) : ((sel) ? piso_out : in);
	assign bit_out = crc_in;
	assign ld_piso = (count == (5'd11));
	assign done = (count == (5'd16));

	always_ff @(posedge clk, negedge rst_L) begin
			if (~rst_L | on) curr <= MESSAGE;
			else curr <= nxt;
	end
	
	always_comb begin
		if (syncing) begin
				{en_shift,sel} = 2'd0;
				{en_count, cl_count} =2'b01;
				nxt = nxt;
		end
		else if (stall) begin
				nxt = nxt;
				en_shift = en_shift;
				en_count = en_count;
				sel = sel;
		end
		else 
				case (curr)
					IDLE: begin 
						{en_shift,sel} = 2'd0;
						{en_count, cl_count} =2'b01;
						nxt = curr;
					end
					MESSAGE: begin
						{en_shift,sel} = 2'd0;
						{en_count, cl_count} =2'b10;
						nxt = (count == (5'd11)) ? REMAINDER : curr;
					end
					REMAINDER:begin
						{en_shift, sel} = 2'b11;
						{en_count, cl_count} =2'b10;
						nxt = (count == (5'd16)) ? IDLE : curr;
					end
				endcase
	end
endmodule : crc5Sender/*}}}*/

//EXTRA MODULES/*{{{*/
	
module crcCalc5 (input bit in,stall,clk, on,rst_L,
		output bit [4:0] out);	
	bit [4:0] poly;
	
	assign out = poly;	

	always_ff @(posedge clk, negedge rst_L) begin
		if(~rst_L | on)
			poly <= 5'h1F;
		else if (stall)
			poly <= poly;
		else begin
			poly[4] <= poly[3];
			poly[3] <= poly[2];
			poly[2] <= poly[4]^poly[1]^in;
			poly[1] <= poly[0];
			poly[0] <= in ^ poly[4];
		end			
	end
endmodule : crcCalc5

module crcCalc16 (input bit in,stall,clk, on,rst_L,
		output bit [15:0] out);	
	bit [15:0] poly;
	
	assign out = poly;	

	always_ff @(posedge clk, negedge rst_L) begin
		if(~rst_L | on)
			poly <= 16'hFFFF;
		else if (stall)
			poly <= poly;
		else begin
			poly[15] <= poly[14];
			poly[14] <= poly[13];
			poly[13] <= poly[12];
			poly[12] <= poly[11];
			poly[11] <= poly[10];
			poly[10] <= poly[9];
			poly[9] <= poly[8];
			poly[8] <= poly[7];
			poly[7] <= poly[6];
			poly[6] <= poly[5];
			poly[5] <= poly[4];
			poly[4] <= poly[3];
			poly[3] <= poly[2];
			poly[2] <= poly[15]^poly[1]^in;
			poly[1] <= poly[0];
			poly[0] <= in ^ poly[15];
		end			
	end
endmodule : crcCalc16

module counter 
			#(parameter W = 5) 
			(input bit enable,clear,on, stall, clk, rst_L,
				output bit [W-1:0] count);

	always_ff @(posedge clk, negedge rst_L) begin
		if(~rst_L | clear | on)	count <= 'b0;
		else if(stall) count<=count;
		else if(enable)	count <= count + 1;
		else 		count <= count;
	end	
endmodule : counter

module mux2 (input bit in1, in2, sel,
							output bit out);
	assign out = (sel) ? in2 : in1;
endmodule : mux2

module register(input bit inBit,ld_reg, clk, rst_L,
								output bit outBit);
	always_ff @(posedge clk, negedge rst_L) begin
		if (~rst_L) begin
            outBit <= 1;
            end
		else if (ld_reg) outBit <= inBit;
		else outBit <= outBit;
        end
endmodule : register

module PISO_register
		#(parameter W = 4)	
			(input bit [W-1:0] in, input bit on, stall,
			load, shift, clk,rst_L,
			 output bit out);

	bit [W-2:0] memory;
	
	always_ff @(posedge clk, negedge rst_L) begin
			if(~rst_L | on) begin
					memory <='d0;
					out <= 'd0;
			end
			else if (stall) begin
					memory <= memory;
					out <= memory[W-2];
			end
			else if (load) begin
					memory <= in[W-2:0];
					out <= in[W-1];
			end
			else if (shift) begin
					memory <= memory << 1;
					out <= memory[W-2];
			end
			else begin
					memory <= memory;
					out <= memory[W-2];
			end
	end
endmodule : PISO_register
/*
module SIPO_register 
    (input bit in, stall, shift,clk, rst_L,                                                                                                                                                      
     output bit[7:0] out);
     always_ff @(posedge clk, negedge rst_L) begin
        if(~rst_L) begin
              out<= 64'd0;
        end
        else if (stall)
              out<=out;
        else if(shift) begin
*/

module SIPO_register 
   #(parameter W = 64)
   (input bit in, stall, shift,clk, rst_L,
											output bit[W-1:0] out);
	always_ff @(posedge clk, negedge rst_L) begin
			if(~rst_L) begin
					out<= 'd0;
			end
			else if (stall)
					out<=out;
			else if(shift) begin
					out <= out<<1;
					out[0] <= in;
			end
			else
					out<=out;
	end
endmodule : SIPO_register/*}}}*/

//Bit Stuffer {{{
//after 6 ones it will desregard the next bit so STOP IT!!!
module stuffBit (input bit in,on,clk,rst_L,
									output bit stall, out);

	bit [2:0] count; 
	bit mem;
	
	assign stall = ((count == 3'd5) & on);

	always_ff @(posedge clk, negedge rst_L) begin
		if(~rst_L | on)
				count <= 3'd0;
		else if (count == 3'd6) begin
				out <= mem;
			 	count <= 3'd0;
		end
		else if(count == 3'd5) begin
				out <= 3'd0;
				mem <= in;
				count <= count+1;
		end
		else if (in == 'b0) begin
				out <= in;
				count <= 3'd0;
		end
		else if (in == 'b1) begin
				out <= in;
				count <= count+1;
		end
	end	
endmodule : stuffBit/*}}}*/

//UNSTUFF BIT MODULE {{{
module unstuffBit(input bit in, on, clk, rst_L, 
	output bit out);

	bit[2:0] count;
    bit     mem, found, start;
	
	always_ff @(posedge clk, negedge rst_L) begin
        if (~rst_L) begin
			count <= 3'd0;
            found <= 1'd0;
            start <= 1'd0;
        end
        else if (on) begin
            mem <= in;
            
		    if (count == 3'd5 && in == 1'd0) begin
                found <= 1'd1;
			    count <= 3'd0;
		    end
		    else if (in == 1'b0) begin
			    count <= 3'd0;
		    end
		    else if (in == 'b1) begin
			    count <= count + 1;
		    end
            if (found) begin
                if (count == 3'd0)
                    out <= 1'b1;
                else
                    out <= in;
            end
            else begin
                if (!start) 
                    out <= mem;
            end
            if (start)
                start <= 1'd0;
        end
        else begin
        //$display("out = %d, in = %d\n", out, in);
            out <= in;
        end
	end

endmodule: unstuffBit/*}}}*/

// NRZI {{{
module nrzi_encoder (input logic in1, in2, output logic out);
	assign out = ~(in1^in2);
//    always_comb begin
//    $display("in1 is %d, in2 is %d, out is %d\n", in1, in2, out);
//end
endmodule : nrzi_encoder/*}}}*/

//DP, DM {{{
module wireCoder (input bit in, eop, enable,
				usbWires wires);
/*	always_comb
		if (~enable)
				{wires.DP, wires.DM} = 2'bzz; //High Z
		else if (eop)
				{wires.DP, wires.DM} = 2'b00; // SE0
		else
				{wires.DP, wires.DM} = (in) ? 2'b10 : 2'b01;
*/
	assign wires.DP = (~enable) ? 1'bz : ((eop) ? 1'b0 : in);
	assign wires.DM = (~enable) ? 1'bz : ((eop) ? 1'b0 : ~in);
endmodule : wireCoder /*}}}*/

//WIRE {{{
module wireDecoder (usbWires wires,
					input bit enable,
					output logic out);
	always_comb
		if (~enable)
			out = 1'bz;
		else
			casez({wires.DP,wires.DM})
				2'b01: out = 1'b0;
				2'b10: out = 1'b1;
				2'b00: out = 1'bz;
			endcase
endmodule : wireDecoder /*}}}*/

