module part3(SW, LEDR, LEDG);
  input [17:0] SW;
  output [17:0] LEDR;
  output [2:0] LEDG;

  assign s0 = SW[15];
  assign s1 = SW[16];
  assign s2 = SW[17];

  wire [2:0] u,v,w,x,y,Mux1,Mux2,Mux3;

  assign u = SW[14:12];
  assign v = SW[11:9];
  assign w = SW[8:6];
  assign x = SW[5:3];
  assign y = SW[2:0];

  assign Mux1 = (s0)?(v):(u);
  assign Mux2 = (s0)?(x):(w);
  assign Mux3 = (s1)?(Mux2):(Mux1);

  assign LEDR = SW;
  assign LEDG = (s2)?(y):(Mux3);

endmodule