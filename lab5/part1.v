module part1(SW, LEDG, LEDR);
	input [8:0] SW;
	output [4:0] LEDG;
	output [8:0] LEDR;
	
	wire [3:0] sum;
	wire carry;
	
	assign {carry, sum} = SW[3:0] + SW[7:4] + SW[8];
	assign LEDG[3:0] = sum;
	assign LEDG[4] = carry;
	assign LEDR = SW;
	
endmodule
