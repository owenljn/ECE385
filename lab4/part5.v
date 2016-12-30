module part5(CLOCK_50, LEDG, HEX0);
  input CLOCK_50;
  output [3:0] LEDG;
  output [0:6] HEX0;

  reg [3:0] Q = 4'b0001;
  
  Clock50to1 C0 (CLOCK_50, 0, Clk1);
  
  always @ ( posedge Clk1)
    Q <= {Q[2:0], Q[3]^Q[2]};

  assign LEDG = Q;
  QtoHEX Q0 (Q, HEX0);
endmodule

module Clock50to1 (Clk, Rst, Clk1);
  input Clk, Rst;
  output reg Clk1;

  reg [23:0]  count;

  always @(posedge Clk or negedge Rst)
    if(!Rst) begin
      count   <= 25'd2499999;
      Clk1 <= 1'b0;
    end else begin
      count   <= count + 25'h1ffffff;
      if(!count) begin
        count   <= 25'd2499999;
        Clk1 <= ~Clk1;
      end
    end

endmodule
//module Flip_Flop (Clk, D, Q);
//  input Clk, D;
//  output Q;
//  
//  wire Qm;
//  Dlatch D0 (~Clk, D, Qm);
//  Dlatch D1 (Clk, Qm, Q);
//endmodule
//
//module Dlatch (Clk, D, Q);
//	input Clk, D;
//	output Q;
//
//	wire R_g, S_g, Qa, Qb /* synthesis keep */ ;
//	assign S = D;
//	assign R = ~D;
//	assign S_g = S & Clk;
//	assign R_g = R & Clk;
//	assign Qa = ~(R_g | Qb);
//	assign Qb = ~(S_g | Qa);
//	assign Q = Qa;
//
//endmodule

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
