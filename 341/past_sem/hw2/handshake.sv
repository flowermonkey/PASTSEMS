typedef struct packed {
	bit[7:0] a;
	bit[7:0] b;
	bit[7:0] c;
	bit[7:0] d;
}pay;

interface problem2
	(input bit clk, reset_L);

	bit Free;
	bit Put;
	
	modport master(input Free, output Put, input clk, input reset_L);
	modport slave(input Put, output Free, input clk, input reset_L);

endinterface: problem2

interface prod_test
		(input bit clk, reset_L);
	bit Free;
	bit Put;
	pay payload;

	modport testp(input Free, output Put, output payload, input clk, input reset_L);
	modport pDuce(input Put, output Free, input payload, input clk, input reset_L);

endinterface: prod_test

interface cons_test
		(input bit clk, reset_L);
	bit Free;
	bit Put;
	pay payload;
	modport conSum(input Free, output Put, output payload,  input clk, input reset_L);
	modport testc(input Put, output Free, input payload, input clk, input reset_L);

endinterface: cons_test

module producer_fsm (problem2.master p, prod_test.pDuce tb,
					input logic [1:0] count,
					output bit load,en,clr);
	
	enum{listen, loading, speak} cur,nxt;

	always_ff @(posedge p.clk, negedge p.reset_L)
	begin
		if(~p.reset_L) cur <= listen;
		else cur <= nxt;
	end

	always_comb begin
		load =0; en = 0;clr=0;
		case(cur)
			listen:begin
				nxt = (tb.Put) ? loading : cur;
				tb.Free=1; clr=1;
			end

			loading:begin
				nxt = (p.Free) ? speak : cur;
				load = (tb.Put) ? 1 : 0;
				p.Put =1;
			end

			speak:begin
				nxt = (count==3) ? listen : cur;
				en = 1;
				p.Put=1;
			end
		endcase
	end
endmodule:producer_fsm

module consumer_fsm (problem2.slave c, cons_test.conSum tb,
					output logic en_c,clr_c);
	
	enum{listen, loading, speak} cur,nxt;

	always_ff @(posedge c.clk, negedge c.reset_L)
	begin
		if(~c.reset_L) cur <= listen;
		else cur <= nxt;
	end

	always_comb begin
		en_c = 0; clr_c =0;
		case(cur)
			listen:begin
				nxt = (c.Put) ? loading : cur;
				c.Free=1; clr_c=1;
			end

			loading:begin
				nxt = (tb.Free) ? speak : cur;
				en_c = (c.Put) ? 1 : 0;
				c.Free=0;
			end

			speak:begin
				nxt = listen;
				tb.Put=1;
			end
		endcase
	end
endmodule:consumer_fsm

module testproducer(prod_test.testp tb);
	initial begin
		tb.Put <=0;
		repeat (4) @(posedge tb.clk);
		tb.Put<=1;
		tb.payload<='h11223344;
		repeat (2) @(posedge tb.clk);
		tb.Put <= 0;
		repeat (4) @(posedge tb.clk);
	end
endmodule: testproducer

module testconsumer(cons_test.testc tb);
	initial begin
		tb.Free =1;
		repeat (8) @(posedge tb.clk);
	end
endmodule: testconsumer

module top;
	bit clk,reset_L,load,en,clr, en_c, clr_c; 
	pay payin,payout;
	bit [1:0] count;
	bit [7:0] s_out;

	problem2 prob(clk,reset_L);
	prod_test pt(clk,reset_L);
	cons_test ct(clk,reset_L);

	producer_fsm pfsm(.*, .p(prob.master),.tb(pt.pDuce));
	consumer_fsm cfsm(.*, .c(prob.slave),.tb(ct.conSum));
	testproducer tesp(.tb(pt.testp));
	testconsumer tesc(.tb(ct.testc));
	shift_register_SIPO out(s_out,clk,clr_c,en_c, payout);
	shift_register_PISO in(payin, clk, load,en,s_out);
	counter #(2) counter_p(clk,en,clr,2'b0,count);
endmodule: top

/////////////////*Library*//////////////////
module shift_register_SIPO
	(input bit [7:0] s_in,
	 input bit clk, clr, en,
	 output pay q);

	always_ff @(posedge clk) begin
	if (clr)
		q <= 'b0;
	else if (en) begin
        q <= q<<4;
		q[3:0] <= s_in;
	end
	else q<=q;	
	end
endmodule: shift_register_SIPO


module shift_register_PISO 
	(input  pay d,
	 input  bit clk, load, en, 
	 output bit [7:0] s_out);

pay q;

always_ff @(posedge clk)
begin
if (load)
	q <= d;
else if (en)
	begin
    s_out <= q<<4;	
	end
else
  q<=q;
end
endmodule: shift_register_PISO


module counter
#(parameter  w = 4)
	(input  logic clk,
	 input  logic en, clr,
	 input logic [w-1:0] d,
	 output logic [w-1:0] q);

	always_ff @(posedge clk) begin
  if (clr)
	 q <= 0;
  else if (en)
	 q <= q+1;
  else
	 q <= q;
  end
endmodule: counter
