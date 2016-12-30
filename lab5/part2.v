// Active-low async reset works immediately as soon as it's applied 
// while sync reset waits for the clock to have effect
module part2(SW, KEY, LEDR, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input [7:0] SW;
	input [3:0] KEY;
	output [8:0] LEDR;
   output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

	wire [7:0] Sum;
   reg [7:0] A, S;
   reg Overflow;

   always @ (negedge KEY[1] or negedge KEY[0]) begin
     if (KEY[1] == 0) begin
       A = SW[7:0];
       S = Sum;
       Overflow <= overflow;
	  end
     if (KEY[0] == 0) begin
       A = 8'b00000000;
       S = 8'b00000000;
       Overflow <= 0;
	  end
	end

	EightBitAdder A0 (A, S, Sum, overflow);

   assign LEDR[7:0] = Sum[7:0];
   assign LEDR[8] = Overflow;

   QtoHEX H7 (A[7:4], HEX7);
   QtoHEX H6 (A[3:0], HEX6);
   QtoHEX H5 (S[7:4], HEX5);
   QtoHEX H4 (S[3:0], HEX4);
   QtoHEX H1 (Sum[7:4], HEX1);
   QtoHEX H0 (Sum[3:0], HEX0);

   assign HEX3 = 7'b1111111;
   assign HEX2 = 7'b1111111;
endmodule

module EightBitAdder(A, S, Sum, overflow);
	input [7:0] A, S;
	output [7:0] Sum;
	output overflow;
	
	wire [7:0] sum;
	wire carry;

	assign {carry, sum} = A[7:0] + S[7:0];
	assign Sum = sum;
	assign overflow = carry;
	
endmodule

module QtoHEX (Q, HEX);
  input [15:0] Q;
  output reg [0:6] HEX;

  always begin
    case (Q)
      0:HEX=7'b0000001;
      1:HEX=7'b1001111;
      2:HEX=7'b0010010;
      3:HEX=7'b0000110;
      4:HEX=7'b1001100;
      5:HEX=7'b0100100;
      6:HEX=7'b0100000;
      7:HEX=7'b0001111;
      8:HEX=7'b0000000;
      9:HEX=7'b0001100;
      10:HEX=7'b0001000;
      11:HEX=7'b1100000;
      12:HEX=7'b0110001;
      13:HEX=7'b1000010;
      14:HEX=7'b0110000;
      15:HEX=7'b0111000;
    endcase
  end
endmodule
