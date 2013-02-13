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
		$display("READING...");	
    
		receive = 1'b0; 
		@(posedge clk);		

//Sending OUT 
		$display("Sending OUT Packet...");		
		sendIN_OUT (4'd4, 4'b0001);

//Sending memPage 
		$display("Sending DATA- memPage Packet...");	
		sendDataPacket (mempage);
		ack_nak (mempage);

//Sending IN
/*
		$display("Sending IN Packet...");	
		sendIN_OUT (4'd8, 4'b1001);

*/

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
		$display("WRITING...");	

		receive = 1'b0; 
		@(posedge clk);		

		on_bitStuff = 0;
		on_crc = 0;
 		{mux_sel, spe_sel} = 2'b01;
		
		en_cable = 1;
		ld_reg = 1;

//Sending OUT 
		$display("Sending OUT Packet...");	
		sendIN_OUT (4'd4, 4'b0001);

//Sending memPage 
		$display("Sending DATA-memPage...");	
		sendDataPacket (mempage);
		ack_nak (mempage);

//Senging OUT
/*		$display("Sending OUT Packet...");	
		sendIN_OUT (4'd8, 4'b0001);
*/

//Sending Data 
/*		$display("Sending DATA - DATA Packet...");	
		sendDataPacket (data);
*/	 	

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

	task ack_nak (input bit [63:0] data);
		{en_count, cl_count} = 2'b01;
		
		@(posedge clk);		
		receive = 1'b1; 
		{en_count, cl_count} = 2'b10;
		
		for (sentTimes = 0; sentTimes <4'd8; sentTimes++) begin	
			while (({ack,nak}) == 0) begin
				if (count == 8'd255) break;
				@(posedge clk);		
			end

			if(ack) 
				break;
			else if (nak)
 				sendDataPacket(data); 
		end
		receive = 1'b0; 
	endtask
	
	task sendIN_OUT (input bit [3:0] endp, pid);
		syncing = 1;
		sendSync;
		sendPid(pid);
		syncing = 0;

		sendAE (endp);
		repeat(6) @(posedge clk);
		sendEOP;
				
		en_cable = 0;
		ld_reg = 0;
	endtask

	task sendDataPacket (input bit [63:0] data);
		@(posedge clk);		
		en_cable = 1;
		ld_reg = 1;
		syncing = 1;
		
		sendSync;
		sendPid(4'b0011);
		syncing = 0;
		
		sendData(data);
		repeat(16) @(posedge clk);
		sendEOP;

		en_cable = 0;
		ld_reg = 0;
	endtask
/*}}}*/


