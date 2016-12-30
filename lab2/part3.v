module part2(SW, LEDR, LEDG);
  input [8:0] SW;
  output [8:0] LEDR;
  output [4:0] LEDG;

  assign LEDR = SW;

  wire c1, c2, c3;

  FullAdder F0 (SW[0], SW[4], SW[8], c1, LEDG[0]);
  FullAdder F1 (SW[1], SW[5], c1, c2, LEDG[1]);
  FullAdder F2 (SW[2], SW[6], c2, c3, LEDG[2]);
  FullAdder F3 (SW[3], SW[7], c3, LEDG[4], LEDG[3]);

endmodule

module FullAdder(a, b, ci, c0, s);
  input a, b, ci;
  output c0, s;

  wire x;

  assign x = a^b;
  assign c0 = (ci & x)|(b & ~x);
  assign s = ci^x;

endmodule