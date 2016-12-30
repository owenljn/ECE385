// 14 LEs needed, and Fmax is 355.87MHz, difference is the T flipflop now has a adder to flip outputs of Q which acts like a multiplexer
module part3 (SW, KEY, HEX0, HEX1, HEX2, HEX3);
  input [1:0] SW;
  input [1:0] KEY;
  output [0:6] HEX0, HEX1, HEX2, HEX3;

  wire [15:0] T, Q;

  Tflipflop T0 (KEY[0], SW[0], SW[1], Q[0]);
  assign T[0] = SW[1] & Q[0];

  Tflipflop T1 (KEY[0], SW[0], T[0], Q[1]);
  assign T[1] = T[0] & Q[1];

  Tflipflop T2 (KEY[0], SW[0], T[1], Q[2]);
  assign T[2] = T[1] & Q[2];

  Tflipflop T3 (KEY[0], SW[0], T[2], Q[3]);
  assign T[3] = T[2] & Q[3];

  Tflipflop T4 (KEY[0], SW[0], T[3], Q[4]);
  assign T[4] = T[3] & Q[4];

  Tflipflop T5 (KEY[0], SW[0], T[4], Q[5]);
  assign T[5] = T[4] & Q[5];

  Tflipflop T6 (KEY[0], SW[0], T[5], Q[6]);
  assign T[6] = T[5] & Q[6];

  Tflipflop T7 (KEY[0], SW[0], T[6], Q[7]);
  assign T[7] = T[6] & Q[7];

  Tflipflop T8 (KEY[0], SW[0], T[7], Q[8]);
  assign T[8] = T[7] & Q[8];

  Tflipflop T9 (KEY[0], SW[0], T[8], Q[9]);
  assign T[9] = T[8] & Q[9];

  Tflipflop T10 (KEY[0], SW[0], T[9], Q[10]);
  assign T[10] = T[9] & Q[10];

  Tflipflop T11 (KEY[0], SW[0], T[10], Q[11]);
  assign T[11] = T[10] & Q[11];

  Tflipflop T12 (KEY[0], SW[0], T[11], Q[12]);
  assign T[12] = T[11] & Q[12];

  Tflipflop T13 (KEY[0], SW[0], T[12], Q[13]);
  assign T[13] = T[12] & Q[13];

  Tflipflop T14 (KEY[0], SW[0], T[13], Q[14]);
  assign T[14] = T[13] & Q[14];

  Tflipflop T15 (KEY[0], SW[0], T[14], Q[15]);

  QtoHEX H0 (Q[3:0], HEX0);
  QtoHEX H1 (Q[7:4], HEX1);
  QtoHEX H2 (Q[11:8], HEX2);
  QtoHEX H3 (Q[15:12], HEX3);

endmodule

module Tflipflop (Clk, Clr, EN, Q);
  input Clk, Clr, EN;
  output reg Q;
  
  always @ (posedge Clk)
    if (Clr)
	   Q = 0;
	 else if (EN)
	   Q <= Q+1;
endmodule

module QtoHEX (Q, HEX);
  input [3:0] Q;
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