module part2 (SW, LEDR, LEDG);
  input [17:0] SW;
  output [7:0] LEDG;
  output [15:0] LEDR;
  wire[7:0] X,Y;
  assign LEDR = SW;
  assign s = SW[17];
  assign X = SW[7:0];
  assign Y = SW[15:8];
  assign LEDG = (s)?(Y):(X);
endmodule