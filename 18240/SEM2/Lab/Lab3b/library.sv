module comparator
 #(parameter w = 4)
 (input logic [w-1:0] A, B,
  output logic AltB, AeqB, AgtB);
	always_comb begin
		AltB = (A<B);
		AgtB = (A>B);
		AeqB = (A==B);
	end
endmodule: comparator

module adder
#(parameter w =4)
	(input logic [w-1:0] A, B,
	 input logic Cin,
	 output logic [w-1:0] sum,
	 output logic Cout);

assign	{Cout,sum} = A + B + Cin;

endmodule: adder

module mux
#(parameter w = 4)
	(input logic [w-1:0] in0, in1,
	 input logic sel,
	 output logic [w-1:0] out);

always_comb begin
	if(sel=='d1)
	out = in1;
	else 
	out = in0;
end
endmodule: mux


module register
#(parameter w = 4)
	(input logic clk, load, clr,
	 input logic [w-1:0] data_in,
	 output logic [w-1:0] data_out);

always_ff @(posedge clk) begin
if (clr)
	data_out <= 0;
else if (load) 
	data_out <= data_in;
	else
	data_out <= data_out;
	end

endmodule: register

module shift_register_SIPO
#(parameter w = 4)
	(input logic s_in, clk, clr, en,
	 output logic [w-1:0] q);

	always_ff @(posedge clk) begin
	if (clr)
		q <= 'b0;
	else if (en) begin
        	q <= q<<1;
		q[0] <= s_in;
	end
	else q<=q;	
	end
endmodule: shift_register_SIPO


module shift_register_PISO 
#(parameter w = 4)
	(input  logic [w-1:0] d,
	 input  logic clk, load, en, 
	 output logic s_out);

logic [w-1:0] q;

always_ff @(posedge clk)
begin
if (load)
	q <= d;
else if (en)
	begin
    s_out <= q[w-1];
	q <= q << 1;
	q[0] <= 0;
	end
else
  q<=q;
end
endmodule: shift_register_PISO


module counter
#(parameter  w = 4)
	(input  logic clk, up,
	 input  logic en, clr, load,
	 input logic [w-1:0] d,
	 output logic [w-1:0] q);

	always_ff @(posedge clk) begin
  if (clr)
	 q <= 0;
  else if (load) 
	 q <= d;
  else if (en && up)
	 q <= q+1;
  else if (en && ~up)
	 q <= q-1;
  else
	 q <= q;
  end
endmodule: counter

module counter_BCD
	(input logic clk, up,
	 input logic en, clr, load,
	 input logic [7:0] d,
	 output logic [7:0] q);

	always_ff @(posedge clk) begin

  if (clr)
	 q  <= 8'd0;
  else if (load) 
	 q <= d;
  else if (en && up) begin
	 if (q[3:0]==4'h9) begin 
		  q[3:0] <= 4'h0;
		  if(q[7:4]==4'h9)
		  q <= 8'd0;
		  else
		  q[7:4] <= q[7:4]+1;
	 end
	 else
		  q[3:0] <= q[3:0] + 1;
  end
  else if (en && ~up) begin
	 if (q[3:0]==4'h0) begin 
		  q[3:0] <= 4'h9;
			 if(q[7:4]==4'h0)
			 q <= 8'h99;
			 else
			 q[7:4] <= q[7:4]-1;
	 end
	 else
		  q[3:0] <= q[3:0] - 1;
	 end

else
	q <= q;
end
endmodule: counter_BCD

module secdeddecoder(
        input logic [12:0] incode,
        output logic [3:0] syndrome,
        output logic oneerr, twoerr,
        output logic [12:0] outcode);

        iscorrect isc(.incode(incode), .syndrome(syndrome), .oneerr(oneerr), .twoerr(twoerr));
        makesyndrome makes(.incode(incode), .syndrome(syndrome));
        makecorrect makec(.incode(incode), .oneerr(oneerr), .twoerr(twoerr), .syndrome(syndrome), .outcode(outcode));
endmodule

module makesyndrome(
	input logic [12:0]incode,
	output logic [3:0] syndrome);
	
	logic d7,d6,d5,d4,p3,d3,d2,d1,p2,d0,p1,p0,gp;

	assign {d7,d6,d5,d4,p3,d3,d2,d1,p2,d0,p1,p0,gp} = incode;
	
	assign syndrome[0]=p0^d0^d1^d3^d4^d6;
	assign syndrome[1]=p1^d0^d2^d3^d5^d6;
	assign syndrome[2]=p2^d1^d2^d3^d7;
	assign syndrome[3]=p3^d4^d5^d6^d7;
endmodule

module iscorrect(
	input logic [12:0] incode,
	input logic [3:0] syndrome,
	output logic oneerr, twoerr);

	logic d7,d6,d5,d4,p3,d3,d2,d1,p2,d0,p1,p0,gp;
	
	assign {d7,d6,d5,d4,p3,d3,d2,d1,p2,d0,p1,p0,gp} = incode;

	//gp is global parity bit
	assign parity = d7^d6^d5^d4^p3^d3^d2^d1^p2^d0^p1^p0;
	
	always_comb
	begin
		oneerr = 0;
		twoerr = 0;

		if (gp != parity)
		begin
		    if (syndrome == 4'd0)
		    begin
			oneerr = 1;
			twoerr = 1;
		    end
		    else 
		    begin
			oneerr = 1;
		    end
		end
		else
		begin
		   if (syndrome != 4'd0)
		   begin
			twoerr = 1;
		   end
		end	
	  end		
endmodule

module makecorrect(
	input logic [12:0] incode,
	input logic oneerr, twoerr,
	input logic [3:0] syndrome,
	output logic [12:0] outcode);

	always_comb
	begin
		outcode = incode;

		if(oneerr == 1 && twoerr == 1)
		begin
			outcode[0] = ~incode[0];
		end
		else if(oneerr == 1)
		begin
			outcode[syndrome] = ~incode[syndrome];		
		end
		
		//can't do anything otherwise
	end
endmodule
