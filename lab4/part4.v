// Note need to use 26-bit counter to count to 5x10^7 MHz.
module part4 (CLOCK_50, HEX0, LEDG);
  input CLOCK_50;
  output [0:6] HEX0;
  output [1:0] LEDG;

  // 2^26 > 5x10^7, 2^25 < 5x10^7,26-bit is the least needed
  wire [25:0] Q;
  wire [15:0] Q2;
  reg Clr, Clr2;

  Counter26bit C0 (CLOCK_50, Clr, 1, Q);
  Counter4bit C1 (Clr, Clr2, 1, Q2);

  // This always block compares output from 26-bit counter and CLOCK_50,
  // sends clear signal to 26-bit counter and 4-bit counter
  always @ (negedge CLOCK_50) begin
    if (Q >= 50000000) begin
      Clr = 1;
    end else begin
      Clr = 0;
    end
  end

  // This always block sends clear signal to 4-bit counter
  always @ (negedge Clr) begin
    if (Q2 >= 9) begin
      Clr2 = 1;
    end else begin
      Clr2 = 0;
    end
  end

  // Use a T type flip flop to simulate the clear signal if number is greater than 9
  Tflipflop T0 (Clr, 0, 1, LEDG[0]);


  QtoHEX Q0 (Q2, HEX0);
endmodule

// This counter counts to 2^26 then reset the counter and passes clear signal to 4-bit counter
module Counter26bit (Clk, Clr, EN, Q);
  input EN, Clk, Clr;
  output [25:0] Q;

  wire [25:0] T, Qs;

  Tflipflop T0 (Clk, Clr, EN, Qs[0]);
  assign T[0] = EN & Qs[0];

  Tflipflop T1 (Clk, Clr, T[0], Qs[1]);
  assign T[1] = T[0] & Qs[1];

  Tflipflop T2 (Clk, Clr, T[1], Qs[2]);
  assign T[2] = T[1] & Qs[2];

  Tflipflop T3 (Clk, Clr, T[2], Qs[3]);
  assign T[3] = T[2] & Qs[3];

  Tflipflop T4 (Clk, Clr, T[3], Qs[4]);
  assign T[4] = T[3] & Qs[4];

  Tflipflop T5 (Clk, Clr, T[4], Qs[5]);
  assign T[5] = T[4] & Qs[5];

  Tflipflop T6 (Clk, Clr, T[5], Qs[6]);
  assign T[6] = T[5] & Qs[6];

  Tflipflop T7 (Clk, Clr, T[6], Qs[7]);
  assign T[7] = T[6] & Qs[7];

  Tflipflop T8 (Clk, Clr, T[7], Qs[8]);
  assign T[8] = T[7] & Qs[8];

  Tflipflop T9 (Clk, Clr, T[8], Qs[9]);
  assign T[9] = T[8] & Qs[9];

  Tflipflop T10 (Clk, Clr, T[9], Qs[10]);
  assign T[10] = T[9] & Qs[10];

  Tflipflop T11 (Clk, Clr, T[10], Qs[11]);
  assign T[11] = T[10] & Qs[11];

  Tflipflop T12 (Clk, Clr, T[11], Qs[12]);
  assign T[12] = T[11] & Qs[12];

  Tflipflop T13 (Clk, Clr, T[12], Qs[13]);
  assign T[13] = T[12] & Qs[13];

  Tflipflop T14 (Clk, Clr, T[13], Qs[14]);
  assign T[14] = T[13] & Qs[14];

  Tflipflop T15 (Clk, Clr, T[14], Qs[15]);
  assign T[15] = T[14] & Qs[15];

  Tflipflop T16 (Clk, Clr, T[15], Qs[16]);
  assign T[16] = T[15] & Qs[16];

  Tflipflop T17 (Clk, Clr, T[16], Qs[17]);
  assign T[17] = T[16] & Qs[17];

  Tflipflop T18 (Clk, Clr, T[17], Qs[18]);
  assign T[18] = T[17] & Qs[18];

  Tflipflop T19 (Clk, Clr, T[18], Qs[19]);
  assign T[19] = T[18] & Qs[19];

  Tflipflop T20 (Clk, Clr, T[19], Qs[20]);
  assign T[20] = T[19] & Qs[20];

  Tflipflop T21 (Clk, Clr, T[20], Qs[21]);
  assign T[21] = T[20] & Qs[21];

  Tflipflop T22 (Clk, Clr, T[21], Qs[22]);
  assign T[22] = T[21] & Qs[22];

  Tflipflop T23 (Clk, Clr, T[22], Qs[23]);
  assign T[23] = T[22] & Qs[23];

  Tflipflop T24 (Clk, Clr, T[23], Qs[24]);
  assign T[24] = T[23] & Qs[24];

  Tflipflop T25 (Clk, Clr, T[24], Qs[25]);

  assign Q = Qs;
endmodule

// This 4-bit counter is used to count number from 0 to 9 and receives clear signal from 26-bit coutner
module Counter4bit (Clk, Clr, EN, Q);
  input Clk, Clr, EN;
  output [15:0] Q;

  wire [15:0] T, Qs;

  Tflipflop T0 (Clk, Clr, EN, Qs[0]);
  assign T[0] = EN & Qs[0];

  Tflipflop T1 (Clk, Clr, T[0], Qs[1]);
  assign T[1] = T[0] & Qs[1];

  Tflipflop T2 (Clk, Clr, T[1], Qs[2]);
  assign T[2] = T[1] & Qs[2];

  Tflipflop T3 (Clk, Clr, T[2], Qs[3]);


  assign Q = Qs;
endmodule

module Tflipflop (Clk, Clr, EN, Q);
  input Clk, Clr, EN;
  output reg Q;
  
  always @ (posedge Clk)
    if (Clr)
	   Q = 0;
	 else if (EN)
	   Q = ~Q;
endmodule


module QtoHEX (Q, HEX);
  input [3:0] Q;
  output reg [0:6] HEX;

  always begin
    case(Q)
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
    endcase
  end
endmodule