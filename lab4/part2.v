// 3 LEs are used for 4-bit counter, Fmax is 771.01 MHz
module part2(CLOCK_50, Clr, EN, LEDG);
  input CLOCK_50, Clr, EN;
  output [3:0] LEDG;

  wire [3:0] T, Q;

  Tflipflop T0 (CLOCK_50, Clr, EN, Q[0]);
  assign T[0] = EN & Q[0];

  Tflipflop T1 (CLOCK_50, Clr, T[0], Q[1]);
  assign T[1] = T[0] & Q[1];

  Tflipflop T2 (CLOCK_50, Clr, T[1], Q[2]);
  assign T[2] = T[1] & Q[2];

  Tflipflop T3 (CLOCK_50, Clr, T[2], Q[3]);

  assign LEDG = Q;

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
