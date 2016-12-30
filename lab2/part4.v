module part4(SW, LEDR, LEDG, HEX4, HEX6, HEX0, HEX1);
  input [8:0] SW;
  output [6:0] HEX6, HEX4, HEX1, HEX0;
  output [8:0] LEDR, LEDG;

  assign LEDR[8:0] = SW[8:0];

  // Check whether A and B are greater than 9
  wire [3:0] eA, eB;
  wire [8:0] LEDG;
  Comparator C0 (SW[3:0], eB);
  Comparator C1 (SW[7:4], eA);
  assign LEDG[8] = eA|eB;
  
  // Display A and B
  wire [3:0] A, M_A, B, M_B;

  CircuitA A0 (SW[7:4], A);
  CircuitA A1 (SW[3:0], B);
  mux4bit2to1 M0 (0, SW[7:4], A, M_A);
  mux4bit2to1 M1 (0, SW[3:0], B, M_B);
  decoder_7seq D0 (M_A, HEX6);
  decoder_7seq D1 (M_B, HEX4);

  // Add A and B
  wire c1, c2, c3;
  wire [4:0] sum;
  assign LEDG[4:0] = sum[4:0];

  FullAdder F0 (SW[0], SW[4], SW[8], c1, sum[0]);
  FullAdder F1 (SW[1], SW[5], c1, c2, sum[1]);
  FullAdder F2 (SW[2], SW[6], c2, c3, sum[2]);
  FullAdder F3 (SW[3], SW[7], c3, sum[4], sum[3]);

  // Display the results
  wire z;
  wire [3:0] S, M;
  ComparatorS C2 (sum[4:0], z);
  CircuitA A2 (sum[3:0], S);
  mux4bit2to1 M2 (z, sum[3:0], S, M);
  CircuitB B0 (z, HEX1);
  decoder_7seq D2 (M, HEX0);

endmodule

module FullAdder (a, b, ci, co, s);
  input a, b, ci;
  output co, s;

  wire x;

  assign x = a^b;
  assign co = (ci & x)|(b & ~x);
  assign s = ci^x;

endmodule

module Comparator(V, e);
  input [3:0] V;
  output e;

  assign e = V[3]&(V[2]|V[1]);

endmodule

module ComparatorS(S, z);
  input [4:0] S;
  output z;

  assign z = S[4]|(S[3]&(S[2]|S[1]));

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

 // CircuitA needs to be modified to translate 4-bits input
module CircuitA(V, A);
  input [3:0] V;
  output [3:0] A;

  assign A[0] = V[0];
  assign A[1] = ~V[1];
  assign A[2] = (V[2]&V[1])|(~V[3] & ~V[1]);
  assign A[3] = (~V[3] & V[1]);

endmodule

module CircuitB(z, HEX);
  input z;
  output [6:0] HEX;
  
  assign HEX[0] = z;
  assign HEX[2:1] = 2'b00;
  assign HEX[5:3] = {3{z}};
  assign HEX[6] = 1;

endmodule

module mux4bit2to1(z, S, A, M);
  input z;
  input [3:0] S, A;
  output [3:0] M;

  assign M = ({4{~z}} & S)|({4{z}} & A);

endmodule