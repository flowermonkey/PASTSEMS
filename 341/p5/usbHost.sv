`default_nettype none

// Write your usb host here.  Do not modify the port list.
module usbHost
  (input logic clk, rst_L, 
  usbWires wires);
	
//Counter Variables
	bit en_count, cl_count;
	bit [7:0] count; 	

//Receiver Variables
	bit receive, receiverDone, receiverOK, ack, nak;
	bit [63:0] messageReceived;

//Sender Variables
	bit senderOn, senderDone;
	bit [7:0] pid;
	bit [3:0] endp;
	bit [63:0] data;

//FSM Variables
	bit [2:0] indicator;
	bit sendingRequest, reading, writing;
	bit [1:0] [3:0] sentTimes;
	bit [63:0] mempage, dataToSend; 
	bit messageOK, finished, finished_bad;

	sender S(.dataIN(data),.*);

	receiver R(.on(receive),.done(receiverDone),.ok(receiverOK), .*);

	counter #(8) c(.enable(en_count), .on(1'b0), .clear(cl_count), .stall(), .*);
	
	/* Tasks needed to be finished to run testbenches */

//READ DATA {{{
	task readData
  // host sends memPage to thumb drive and then gets data back from it
  // then returns data and status to the caller
  (input  bit [15:0]  mempage, // Page to write
   output bit [63:0] data, // array of bytes to write
   output bit        success);
		$display("READING...");	

		host.reading <= 1;
		host.mempage[15:0] <= mempage; 
		@(posedge clk);
		host.reading <= 0;
		@(posedge clk);
	
		wait (finished);
		
		data <= host.messageReceived;
		success <= host.receiverOK;
		@(posedge clk);
		host.reading <= 0;
  endtask: readData /*}}}*/
	
//WRITE DATA {{{
  task writeData
  // Host sends memPage to thumb drive and then sends data
  // then returns status to the caller
  (input  bit [15:0]  mempage, // Page to write
   input  bit [63:0] data, // array of bytes to write
   output bit        success);
		$display("WRITING...");	

		host.writing <= 1;
		host.mempage[15:0] <= mempage; 
		host.dataToSend <= data;
		@(posedge clk);
		host.writing <= 0;
		@(posedge clk);

		wait (host.finished);

		success <= (host.finished & ~host.finished_bad);
		host.writing <= 0;
		@(posedge clk);
  endtask: writeData/*}}}*/

	//FSM_PROTOCOL {{{
	enum bit [4:0] {IDLE, OUT_0, DATA_SEND_0, ACK_NAK_0, IN, DATA_READ, 
					SEND_ACK_NAK, OUT_1, DATA_SEND_1, ACK_NAK_1} nxt, curr;

	always_ff @(posedge clk, negedge rst_L) begin
			if(~rst_L)	curr <= IDLE;
			else	curr <= nxt;
	end

	always_comb begin
		indicator = {sendingRequest,reading,writing};
		finished = 0;
		finished_bad = 0;
		case (curr)
			IDLE: begin	
				senderOn = 0;
				receive = 0;
				
				sentTimes[0] = 4'd0;
				sentTimes[1] = 4'd0;

				{en_count,cl_count} = 2'b01;
				nxt = ((indicator != 0) & (mempage != 64'd0) ) ? OUT_0 : curr;
			end
			
			OUT_0: begin
				senderOn = 1;
				receive = 0;
					
				pid =8'b1000_0111;
				endp=4'b0010; 
				{en_count,cl_count} = 2'b01;
				nxt = (senderDone) ? DATA_SEND_0: curr;  
			end
			
			DATA_SEND_0: begin
				senderOn = 1;
				receive = 0;
				
				pid = 8'b1100_0011;
				data[48] = mempage[15];
				data[49] = mempage[14];
				data[50] = mempage[13];
				data[51] = mempage[12];
				data[52] = mempage[11];
				data[53] = mempage[10];
				data[54] = mempage[9];
				data[55] = mempage[8];
				data[56] = mempage[7];
				data[57] = mempage[6];
				data[58] = mempage[5];
				data[59] = mempage[4];
				data[60] = mempage[3];
				data[61] = mempage[2];
				data[62] = mempage[1];
				data[63] = mempage[0];
				data[47:0] = 0;
				
				{en_count,cl_count} = 2'b01;
				nxt = (senderDone) ? ACK_NAK_0 : curr;

			end
			
			ACK_NAK_0: begin
				receive =  1; 
				senderOn = 0;
				en_count = 1;
				cl_count = 0;
				
				sentTimes[0] = (count==0) ? (sentTimes[0] + 1) : sentTimes[0];

				if (ack) 	
					unique case (indicator) 
						3'b100:begin
							nxt = IDLE;
							indicator[2] = 0;
							finished = 1;
						end
						3'b010: nxt = IN;
						3'b001: nxt = OUT_1;
					endcase
				else if (sentTimes == 3'd7) begin
					nxt = IDLE;
					finished = 1;
					finished_bad = 1;
				end
				else if (nak | count > 8'd255)
					nxt = DATA_SEND_0;
				else
					nxt = curr;
			end
	
			IN: begin
				senderOn =1;
				receive = 0;

				pid =8'b1001_0110;
				endp=4'b0001; 
				{en_count,cl_count} = 2'b10;
				nxt = (senderDone) ? DATA_READ : curr;
			end

			DATA_READ: begin
				receive = 1;
				senderOn = 0;
				{en_count,cl_count} = 2'b10;
				
				pid =8'b1100_0011;
				data = messageReceived;
				
				messageOK = receiverOK;

				nxt = (receiverDone) ? SEND_ACK_NAK : curr;
			end
			
			SEND_ACK_NAK: begin
				receive = 0;
				senderOn = 1;
				{en_count,cl_count} = 2'b10;

				pid = (messageOK) ? 8'b0100_1011 : 8'b0101_1010;
				indicator[1] = ~(senderDone);
				nxt = (senderDone) ? IDLE : curr;
				finished = (senderDone);
			end

			OUT_1: begin
				senderOn = 1;
				receive = 0;
					
				pid =8'b1000_0111;
				endp=4'b0001; 
				{en_count,cl_count} = 2'b01;
				nxt = ((dataToSend != 0)) ? ((senderDone) ? DATA_SEND_1: curr) : curr;  
			end

			DATA_SEND_1: begin
				senderOn = 1;
				receive = 0;
				
				pid = 8'b1100_0011;
				data[0] = dataToSend[63];
				data[1] = dataToSend[62];/*{{{*/
				data[2] = dataToSend[61];
				data[3] = dataToSend[60];
				data[4] = dataToSend[59];
				data[5] = dataToSend[58];
				data[6] = dataToSend[57];
				data[7] = dataToSend[56];
				data[8] = dataToSend[55];
				data[9] = dataToSend[54];
				data[10] = dataToSend[53];
				data[11] = dataToSend[52];
				data[12] = dataToSend[51];
				data[13] = dataToSend[40];
				data[14] = dataToSend[49];
				data[15] = dataToSend[48];
				data[16] = dataToSend[47];
				data[17] = dataToSend[46];
				data[18] = dataToSend[45];
				data[19] = dataToSend[44];
				data[20] = dataToSend[43];
				data[21] = dataToSend[42];
				data[22] = dataToSend[41];
				data[23] = dataToSend[40];
				data[24] = dataToSend[39];
				data[25] = dataToSend[38];
				data[26] = dataToSend[37];
				data[27] = dataToSend[36];
				data[28] = dataToSend[35];
				data[29] = dataToSend[34];
				data[30] = dataToSend[33];
				data[31] = dataToSend[32];
				data[32] = dataToSend[31];
				data[33] = dataToSend[30];
				data[34] = dataToSend[29];
				data[35] = dataToSend[28];
				data[36] = dataToSend[27];
				data[37] = dataToSend[26];
				data[38] = dataToSend[25];
				data[39] = dataToSend[24];
				data[40] = dataToSend[23];
				data[41] = dataToSend[22];
				data[42] = dataToSend[21];
				data[43] = dataToSend[20];
				data[44] = dataToSend[19];
				data[45] = dataToSend[18];
				data[46] = dataToSend[17];
				data[47] = dataToSend[16];
				data[48] = dataToSend[15];
				data[49] = dataToSend[14];
				data[50] = dataToSend[13];
				data[51] = dataToSend[12];
				data[52] = dataToSend[11];
				data[53] = dataToSend[10];
				data[54] = dataToSend[9];
				data[55] = dataToSend[8];
				data[56] = dataToSend[7];
				data[57] = dataToSend[6];
				data[58] = dataToSend[5];
				data[59] = dataToSend[4];
				data[60] = dataToSend[3];
				data[61] = dataToSend[2];
				data[62] = dataToSend[1];
				data[63] = dataToSend[0];/*}}}*/
				
				{en_count,cl_count} = 2'b01;
				nxt = (senderDone) ? ACK_NAK_1 : curr;

			end
		
			ACK_NAK_1: begin
				receive =  1; 
				senderOn = 0;
				en_count = 1;
				cl_count = 0;
				
				sentTimes[1] = (count==0) ? (sentTimes[1] + 1) : sentTimes[1];

				if (ack) begin
					indicator[0] = 0;
					nxt = IDLE;
					finished = 1;
				end
				else if (sentTimes == 3'd7) begin
					nxt = IDLE;
					finished = 1;
					finished_bad = 1;
				end
				else if (nak| count > 8'd255)
					nxt = DATA_SEND_1;
				else
					nxt = curr;
			end
		endcase
	end/*}}}*/
endmodule: usbHost

//SENDER MODULE {{{
module sender
    (input bit senderOn, clk, rst_L, 
     input bit [7:0] pid, 
     input bit [3:0] endp,
     input bit [63:0] dataIN,
     output bit senderDone,
	 usbWires wires);  

    bit syncing,sel2, crced1, crced2;
    bit [10:0] addEnd;
    bit inBit, nBit, crced, eop, stuffed, in2, mux2_out, spe_sel;
    bit load_piso, shift_piso, ld_nrzi;
    bit en_count, cl_count, stall, on_crc5, on_crc16, on_stuff, en_cable;
    bit [63:0] data;
	bit [7:0] sync, count;
    bit [6:0] addr;
    

    PISO_register #(64) shiftIn64(data, stall, load_piso, shift_piso, clk, rst_L, inBit);

    crc5Sender bitStreamEncoder5(.in(inBit), .bit_out(crced1),.on(on_crc5), .*);
	crc16Sender bitStreamEncoder16(.in(inBit), .bit_out(crced2),.on(on_crc16), .*);
	
    mux2 b(.in1(crced1), .in2(crced2), .sel(sel2), .out(crced));
	stuffBit 	bitStuffer(.in(crced), .out(stuffed),.on(on_stuff), .*);
	
	nrzi_encoder nrzi(.in1(stuffed),.in2(in2),.out(nBit)); 
	register bitReg(.inBit(nBit), .outBit(in2), .ld_reg(ld_nrzi), .*);
	
	mux2 speSelector(.in1(nBit), .in2(inBit), .sel(spe_sel), .out(mux2_out));
	wireCoder cable(.in(mux2_out),.enable(en_cable),.*);
	
	counter #(8) c(.enable(en_count), .on(1'b0), .clear(cl_count), .*);
	
    enum bit [2:0] {IDLE, SYNC, PID, ADDRENDP, CRC16, EOP} nxt, curr;

    always_ff @(posedge clk, negedge rst_L) begin
        if (~rst_L) curr <= IDLE;
        else curr <= nxt;
    end

    assign sync = 8'b0000_0001;
    assign addr = 7'b1010000;
    assign addEnd[10:4] = addr;
    assign addEnd[3:0] = endp;

    always_comb begin	
        if (~senderOn) begin
    		{senderDone, syncing, sel2, eop, spe_sel, load_piso, shift_piso, ld_nrzi,
				en_count, cl_count,  on_crc5, on_crc16, on_stuff, en_cable} = 13'b0;
        end
        else begin
    		{senderDone, syncing, sel2, eop, spe_sel, load_piso, shift_piso, ld_nrzi,
				en_count, cl_count,  on_crc5, on_crc16, on_stuff, en_cable} = 13'b0;
            case (curr)
                IDLE: begin
                 //  load_piso = senderOn;
                 //  data[63:56] = sync;
                    cl_count =  1;
                    nxt = (senderOn) ? SYNC : IDLE;
				 // shift_piso = senderOn;
                end
                SYNC: begin
               // $display("in SYNC, count is %d, eight is %b\n", count, eight);
                    en_cable =(count > 1);
                    ld_nrzi = (count > 1);
					syncing = (count > 1);
					
					en_count = 1;
                   
				  	shift_piso = 1 ;
                    load_piso = (count == 8'd0);
                    data[63:56] = sync;

					nxt = (count == 8'd7) ? PID: SYNC;
                    cl_count = (count == 8'd7) ? 1:0;
                end
                PID: begin
                   //$display("in PID, count is %d\n", count);
					
                    ld_nrzi = 1;
					en_cable = 1;
                    syncing = (count < 8'd7);

					en_count = 1;
                    cl_count = (count == 8'd7) ? 1:0;
                   	
					shift_piso = 1;
					load_piso = (count == 8'd0);						
                    data[63:56] = pid;

                    on_stuff = (count == 8'd7); //START BIT STUFFING 
					
                    if ((pid == 8'b1000_0111) || (pid == 8'b1001_0110)) begin
                      //  $display("changing to addrenpd\n");
                        nxt = (count == 8'd7) ? ADDRENDP : curr;
                    end
                    else if (pid == 8'b1100_0011) begin
                        nxt = (count == 8'd7) ? CRC16: curr;
					end
                    else if ((pid == 8'b0100_1011) || (pid == 8'b0101_1010))
                        nxt = (count == 8'd7) ? EOP: curr;
                    else
                        nxt = SYNC; 
                end
                CRC16: begin 
//                $display("in CRC16, count is %d\n", count);

					on_crc16 = (count == 8'd0);
                    ld_nrzi = 1;
					en_cable = 1;
                    sel2 = 1;
					
					en_count = 1;

                    shift_piso = 1;
                	load_piso = (count == 8'd0);
					data = dataIN;
                    
					nxt = (count == 8'd81) ? EOP : curr;
                    cl_count = (count == 8'd81) ? 1:0;
                end
                ADDRENDP: begin
					on_crc5 = (count == 8'd0);
                    //$display("in ADDRENDP, count is %d, addend is %b\n", count, addEnd);
                    ld_nrzi = 1;
					en_cable = 1;
                    
                    en_count = 1;
                    
					shift_piso = 1;
                	load_piso = (count == 8'd0);
					data[63:53] = addEnd;

                    nxt = (count == 8'd17) ? EOP: curr;
					cl_count = (count == 8'd17) ? 1:0;
                end    
                    
                EOP: begin
//                   $display("in EOP, count is %d, inBit is %d\n", count, inBit);
					en_cable = 1;
                    en_count = 1;
                    eop = (count < 2);
                    spe_sel = 1;
					
                	load_piso = (count == 8'd0);
					data = 64'h4000_0000_0000_0000;
					
					senderDone = (count == 2);
                    nxt = (count == 2) ? IDLE: EOP;
                end
                endcase
           end     
        end
endmodule: sender /*}}}*/

//RECEIVER MODULE {{{
module receiver 
	(input bit  on, clk, rst_L,
		output bit ack, nak,done,ok,
		output bit [63:0] messageReceived,
		usbWires wires);

	logic bit_in;
	bit en_count, en_shift, in_crc16, start;
 	bit unstuffed, nrzied, old, on_stuff, on_cable, on_syncing;
  
	bit stall, clear, regRst, cl_count, en_pid; 
	
	bit [7:0] count;
	bit crc16_out;
    bit [7:0] pid;

	crc16Sender crc16(.in(unstuffed), .syncing(on_syncing), .bit_out(crc16_out), .*);
	counter #(8) c(.enable(en_count), .clear(cl_count), .on(1'b0), .*);
	SIPO_register message_reg(.in(crc16_out),.shift(en_shift),.rst_L(rst_L), .out(messageReceived), .*);
    SIPO_register #(8) pid_sync(.in(crc16_out), .shift(en_pid),.rst_L(rst_L), .out(pid), .*);
 	register delay(.inBit(nrzied), .outBit(old), .ld_reg(1'b1), .*);
  	nrzi_encoder nrziD(bit_in, old, nrzied);
  	unstuffBit unstuff(nrzied, on_stuff, clk, rst_L, unstuffed);
  	wireDecoder cable(.enable(on_cable), .out(bit_in),.*);

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
                    on_stuff = 0;
                    on_cable = 1;
                    on_syncing = 1;
                    en_count = 0;
                    cl_count = 1;
                    en_shift = 0;
                    en_pid = 1;
                    nxt = (pid == 8'b10000000) ? PID : SYNC; 
                	regRst = 1;
                end

              	PID: begin
                	en_count = (count >= 5'd8) ? 0:1;
                	cl_count = 0;

                	en_shift= 0;
                	en_pid = (count >= 5'd8) ? 0:1;
                    on_syncing = 1;
                	on_stuff = 0;
                	on_cable = 1;
                	regRst = 1;
                	if  (count >= 5'd8) begin
                		if (pid == 8'b00101101) begin
                        	ack = 1;
                      	  	nxt = EOP;
                		end
                		else if (pid == 8'b10100101) begin
                        	nak = 1;
                        	nxt = EOP;
                		end
                  		else if (pid == 8'b00111100) begin
                        	nxt = CRC16;
	                	end
						else
							nxt = SYNC;
               		end
                	else begin 
                    	ack = 0;
                    	nak = 0;
                    	nxt = curr;
                	end
            	end

        		CRC16: begin
                	{en_shift, en_count} = 2'b11;
                	in_crc16 = bit_in;
                	on_stuff = 1;
                	on_cable = 1;
               	 	en_pid = 0;
                    on_syncing = 0;
                	regRst = 1'b1;
                	nxt = (count == 5'd5) ? EOP : curr;
                	done = (count == 5'd5) ? 1:0 ;
                	ok = (crc16_out==16'b1000000000001101) ? 1:0;
        		end

        		EOP: begin
                	on_stuff = 0;
                    on_syncing = 1;
                	on_cable = 1;
                	en_pid = 0;
                	{en_shift, en_count} = 2'b01;
                	nxt = (count == 5'd3) ? IDLE:curr;     
        		end
			endcase
		end
	end
endmodule : receiver/*}}}*/

//CRC16 {{{
module crc16Sender (input bit in, on, syncing, stall, clk, rst_L,
		  						output bit bit_out);

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
						nxt = (count == (7'd80)) ? IDLE : curr;
					end
				endcase
	end
endmodule : crc16Sender/*}}}*/

//CRC5 {{{
module crc5Sender (input bit in, on,syncing, stall, clk, rst_L,
		  						output bit bit_out);

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
			poly[15] <= poly[14]^in^poly[15];
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
			(input bit [W-1:0] in, input bit stall,
			load, shift, clk,rst_L,
			 output bit out);

	bit [W-2:0] memory;
	
	always_ff @(posedge clk, negedge rst_L) begin
			if(~rst_L) begin
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

