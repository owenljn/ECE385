module part6(SW, LEDR);
  input [1:0] SW;
  output [2:0]LEDR;

  wire Q;
  
  D_latch D2 (SW[1], SW[0], LEDR[0]);
  Flip_Flop F0 (SW[1], SW[0], LEDR[1]);
  Flip_Flop F1 (~SW[1], SW[0], LEDR[2]);
endmodule

module D_latch (Clk, D, Q);
  input D, Clk;
  output reg Q;
  always @ (D, Clk)
    if (Clk)
      Q = D;
endmodule

module Flip_Flop (Clk, D, Q);
  input D, Clk;
  output Q;

  wire Qm;
  D_latch D0 (~Clk, D, Qm);
  D_latch D1 (Clk, Qm, Q);
endmodule
