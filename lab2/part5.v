module part5(SW, LEDR, LEDG, HEX2, HEX1, HEX0);
  input [16:0] SW;
  output [15:0] LEDR;
  output [8:0] LEDG;
  output [6:0] HEX2, HEX1, HEX0;

  assign LEDR = SW;

  // Check if A1 or A0 or B1 or B0 is greater than 9
  wire [3:0] eA1, eA0, eB1, eB0;
  Comparator C0 (SW[15:12], eA1);
  Comparator C1 (SW[11:8], eA0);
  Comparator C2 (SW[7:4], eB1);
  Comparator C3 (SW[3:0], eB0);
  assign LEDG[8] = eA1|eA0|eB1|eB0;

  // Add A0 and B0, need SW[16] as the carry in bit
  wire c1, c2, c3;
  wire [4:0] S0;

  FullAdder F0 (SW[8], SW[0], SW[16], c1, S0[0]);
  FullAdder F1 (SW[9], SW[1], c1, c2, S0[1]);
  FullAdder F2 (SW[10], SW[2], c2, c3, S0[2]);
  FullAdder F3 (SW[11], SW[3], c3, S0[4], S0[3]);

  // Display sum of A0 and B0 on HEX0
  wire z0;
  wire [3:0] A0B0, M0;

  ComparatorS C4 (S0, z0);
  CircuitA A0 (S0[3:0], A0B0);
  mux4bit2to1 MUX0 (z0, S0[3:0], A0B0, M0);
  // Since z0 will be passed to addition of A1 and B1
  // then there's no need to add CircuitB regardless
  // the sum of A0 and B0 is greater than 9 or not
  decoder_7seq D0 (M0, HEX0);

  // Add A1 and B1, z0 will be the carry in bit
  wire c4, c5, c6;
  wire [4:0] S1;
  
  FullAdder F4 (SW[12], SW[4], z0, c4, S1[0]);
  FullAdder F5 (SW[13], SW[5], c4, c5, S1[1]);
  FullAdder F6 (SW[14], SW[6], c5, c6, S1[2]);
  FullAdder F7 (SW[15], SW[7], c6, S1[4], S1[3]);

  // Display sum of A1 and B1 on HEX1 and HEX2
  wire z1;
  wire [3:0] A1B1, M1;

  ComparatorS C5 (S1, z1);
  CircuitA A1 (S1[3:0], A1B1);
  mux4bit2to1 MUX1 (z1, S1[3:0], A1B1, M1);
  CircuitB B0 (z1, HEX2);
  decoder_7seq D1 (M1, HEX1);
  
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

// Note CircuitA is modified to transfer 4-bit signal
module CircuitA(V, A);
  input [3:0] V;
  output [3:0] A;

  assign A[0] = V[0];
  assign A[1] = ~V[1];
  assign A[2] = (V[2]&V[1])|(~V[3] & ~V[1]);
  assign A[3] = (~V[3] & V[1]);

endmodule

module mux4bit2to1(z, S, A, M);
  input z;
  input [3:0] S, A;
  output [3:0] M;

  assign M = ({4{~z}} & S)|({4{z}} & A);

endmodule

module CircuitB(z, HEX);
  input z;
  output [6:0] HEX;
  
  assign HEX[0] = z;
  assign HEX[2:1] = 2'b00;
  assign HEX[5:3] = {3{z}};
  assign HEX[6] = 1;

endmodule

module decoder_7seq(M, HEX0);
  input [3:0] M;
  output [6:0] HEX0;

  assign HEX0[0] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & M[2] & ~M[1] & ~M[0]);
  assign HEX0[1] = (~M[3] & M[2] & ~M[1] & M[0])|(~M[3] & M[2] & M[1] & ~M[0]);
  assign HEX0[2] = (~M[3] & ~M[2] & M[1] & ~M[0]);
  
  assign HEX0[3] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & M[2] & ~M[1] & ~M[0])|
                   (~M[3] & M[2] & M[1] & M[0])|(M[3] & ~M[2] & ~M[1] & M[0]);

  assign HEX0[4] = ~((~M[2] & ~M[0])|(M[1] & ~M[0]));

  assign HEX0[5] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & ~M[2] & M[1] & ~M[0])|
						 (~M[3] & ~M[2] & M[1] & M[0])|(~M[3] & M[2] & M[1] & M[0]);

  assign HEX0[6] = (~M[3] & ~M[2] & ~M[1] & ~M[0])|(~M[3] & ~M[2] & ~M[1] & M[0])|
                   (~M[3] & M[2] & M[1] & M[0]);

endmodule