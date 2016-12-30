module part6(KEY0, CLOCK_50, LEDG, HEX0, HEX1, HEX2, HEX3);
  input KEY0;
  input CLOCK_50;
  output [15:0] LEDR;
  output [0:6] HEX0, HEX1, HEX2, HEX3;
  
  wire [15:0] Q;
  wire reset;
  reg [15:0] lfsr = 16'b0000000000000001;

  Clock50to1 C0 (CLOCK_50, 0, Clk1);

  always @ ( posedge Clk1)
    reset <= 1;
	 assign LE1 <= {lfsr[14]^lfsr[16]};
	 assign LE2 <= lfsr[13]^LE1;
    lfsr <= {lfsr[15:0], lfsr[11]^LE2};

  assign Q = lfsr;
  assign LEDR = Q;
  QtoHEX Q0 (Q[3:0], HEX0);
  QtoHEX Q1 (Q[7:4], HEX1);
  QtoHEX Q2 (Q[11:8], HEX2);
  QtoHEX Q3 (Q[16:12], HEX3);
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
