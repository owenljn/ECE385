module part4 (SW, LEDR);
	input [1:0] SW;
	output [1:0] LEDR;
	
   wire Q;
	
	Dlatch D0 (SW[1], SW[0], LEDR[0]);

endmodule

module Dlatch (Clk, D, Q);
	input Clk, D;
	output Q;

	wire R_g, S_g, Qa, Qb /* synthesis keep */ ;
	assign S = D;
	assign R = ~D;
	assign S_g = S & Clk;
	assign R_g = R & Clk;
	assign Qa = ~(R_g | Qb);
	assign Qb = ~(S_g | Qa);
	assign Q = Qa;

endmodule