module part1(SW, HEX0, HEX1);
  input [3:0] SW;
  output [6:0] HEX1, HEX0;

  wire z;
  wire [3:0] A, M;

  assign A[3] = 0;

  Comparator C0 (SW[3:0], z);
  CircuitA A0 (SW[2:0], A[2:0]);
  mux4bit2to1 M0 (z, SW[3:0], A, M);
  CircuitB B0 (z, HEX1);
  decoder_7seq D0 (M, HEX0);
  
endmodule

// Since only 4-bit binary input allowed then 15 is the largest decimal number 
// that can be displayed so if z is 1, then d1 must only display 1.
module Comparator(V, z);
  input [3:0] V;
  output z;

  assign z = V[3]&(V[2]|V[1]);

endmodule

module CircuitA(V, A);
  input [2:0] V;
  output [2:0] A;

  assign A[0] = V[0];
  assign A[1] = ~V[1];
  assign A[2] = V[2]&V[1];

endmodule

module CircuitB(z, HEX1);
  input z;
  output [6:0] HEX1;
  
  assign HEX1[0] = z;
  assign HEX1[2:1] = 2'b00;
  assign HEX1[5:3] = {3{z}};
  assign HEX1[6] = 1;

endmodule

module mux4bit2to1(z, S, A, M);
  input z;
  input [3:0] S, A;
  output [3:0] M;

  assign M = ({4{~z}} & S)|({4{z}} & A);

endmodule

module decoder_7seq(M, HEX0);
  input [3:0] M;
  output [6:0] HEX0;

  assign HEX0[0] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & M[2] & ~M[1] & ~M[0]);
  assign HEX0[1] = (~M[3] & M[2] & ~M[1] & M[0])|(~M[3] & M[2] & M[1] & ~M[0]);
  assign HEX0[2] = (~M[3] & ~M[2] & M[1] & ~M[0]);
  
  assign HEX0[3] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & M[2] & ~M[1] & ~M[0])|
                   (~M[3] & M[2] & M[1] & M[0])|(M[3] & ~M[2] & ~M[1] & M[0]);

  assign HEX0[4] = ~((~M[2] & ~M[1] & ~M[0])|(~M[3] & M[1] & ~M[0]));

  assign HEX0[5] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & ~M[2] & M[1] & ~M[0])|
						 (~M[3] & ~M[2] & M[1] & M[0])|(~M[3] & M[2] & M[1] & M[0]);

  assign HEX0[6] = (~M[3] & ~M[2] & ~M[1] & ~M[0])|(~M[3] & ~M[2] & ~M[1] & M[0])|
                   (~M[3] & M[2] & M[1] & M[0]);

 endmodule