module part7 (SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, KEY);
  input [15:0] SW;
  input [1:0] KEY;
  output [15:0] LEDR;
  output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

  // Use red lights to show inputs
  assign LEDR = SW;
  
  reg [15:0] A;
  wire [15:0] Q;

  always A = Q;

  Flip_Flop F15 (~KEY[1], SW[15], Q[15], ~KEY[0]);
  Flip_Flop F14 (~KEY[1], SW[14], Q[14], ~KEY[0]);
  Flip_Flop F13 (~KEY[1], SW[13], Q[13], ~KEY[0]);
  Flip_Flop F12 (~KEY[1], SW[12], Q[12], ~KEY[0]);
  Flip_Flop F11 (~KEY[1], SW[11], Q[11], ~KEY[0]);
  Flip_Flop F10 (~KEY[1], SW[10], Q[10], ~KEY[0]);
  Flip_Flop F9 (~KEY[1], SW[9], Q[9], ~KEY[0]);
  Flip_Flop F8 (~KEY[1], SW[8], Q[8], ~KEY[0]);
  Flip_Flop F7 (~KEY[1], SW[7], Q[7], ~KEY[0]);
  Flip_Flop F6 (~KEY[1], SW[6], Q[6], ~KEY[0]);
  Flip_Flop F5 (~KEY[1], SW[5], Q[5], ~KEY[0]);
  Flip_Flop F4 (~KEY[1], SW[4], Q[4], ~KEY[0]);
  Flip_Flop F3 (~KEY[1], SW[3], Q[3], ~KEY[0]);
  Flip_Flop F2 (~KEY[1], SW[2], Q[2], ~KEY[0]);
  Flip_Flop F1 (~KEY[1], SW[1], Q[1], ~KEY[0]);
  Flip_Flop F0 (~KEY[1], SW[0], Q[0], ~KEY[0]);

  HEX_7seg H7 (A[15:12], HEX7);
  HEX_7seg H6 (A[11:8], HEX6);
  HEX_7seg H5 (A[7:4], HEX5);
  HEX_7seg H4 (A[3:0], HEX4);
  HEX_7seg H3 (SW[15:12], HEX3);
  HEX_7seg H2 (SW[11:8], HEX2);
  HEX_7seg H1 (SW[7:4], HEX1);
  HEX_7seg H0 (SW[3:0], HEX0);
  
endmodule

module D_latch (Clk, D, Q, Rst);
  input D, Clk, Rst;
  output reg Q;
  always @ (D, Clk, Rst)
    if (Clk)
      Q = D;
	 else 
	   if (Rst)
	     Q = 0;
endmodule

module Flip_Flop (Clk, D, Q, Rst);
  input D, Clk, Rst;
  output Q;

  wire Qm;
  D_latch D0 (~Clk, D, Qm, Rst);
  D_latch D1 (Clk, Qm, Q, Rst);
endmodule

module HEX_7seg (M, HEX);
  input [15:0] M;
  output reg [0:6] HEX;

  always 
    begin
      case(M)
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
		