module part5(SW, LEDR, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
  input [17:0] SW;
  output [17:0] LEDR;
  output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

  assign HEX7 = 7'b1111111;
  assign HEX6 = 7'b1111111;
  assign HEX5 = 7'b1111111;
  assign HEX4 = 7'b1111111;

  multiplier M0 (SW[7:4], SW[3:0], LEDR[7:0]);

  QtoHEX H1 (SW[7:4], HEX1);
  QtoHEX H0 (SW[3:0], HEX0);
  QtoHEX H3 (LEDR[7:4], HEX3);
  QtoHEX H2 (LEDR[3:0], HEX2);

endmodule

// implements a 4-bit by 4-bit multiplier with 8-bit result
module multiplier (A, B, P);
  input [3:0] A, B;
  output [7:0] P;

  wire c0, c1, c2;

  wire [3:0] A1, A2, A3, B1, B2, B3, S1, S2, S3;

  assign P[0] = A[0] & B[0];

  // First 4-bit full-adder
  assign A1[0] = A[1] & B[0];
  assign A1[1] = A[2] & B[0];
  assign A1[2] = A[3] & B[0];
  assign A1[3] = 0;
  assign B1[0] = A[0] & B[1];
  assign B1[1] = A[1] & B[1];
  assign B1[2] = A[2] & B[1];
  assign B1[3] = A[3] & B[1];
  // Second 4-bit full-adder
  assign A2[0] = S1[1];
  assign A2[1] = S1[2];
  assign A2[2] = S1[3];
  assign A2[3] = c0;
  assign B2[0] = A[0] & B[2];
  assign B2[1] = A[1] & B[2];
  assign B2[2] = A[2] & B[2];
  assign B2[3] = A[3] & B[2];
  // Third 4-bit full-adder
  assign A3[0] = S2[1];
  assign A3[1] = S2[2];
  assign A3[2] = S2[3];
  assign A3[3] = c1;
  assign B3[0] = A[0] & B[3];
  assign B3[1] = A[1] & B[3];
  assign B3[2] = A[2] & B[3];
  assign B3[3] = A[3] & B[3];

  fulladder4bit F0 (A1, B1, ci, S1, c0);
  fulladder4bit F1 (A2, B2, c0, S2, c1);
  fulladder4bit F2 (A3, B3, c1, S3, c2);
  
  assign P[1] = S1[0];
  assign P[2] = S2[0];
  assign P[6:3] = S3[3:0];
  assign P[7] = c2;

endmodule

module fulladder4bit (a, b, ci, s, co);
  input [3:0] a, b;
  input ci;
  output co, s;

  wire [3:0] e, S;

  assign e[0] = a[0] ^ b[0];
  assign S[0] = e[0] ^ ci;
  assign c0 = (b[0] & ~e[0]) | (e[0] & ci);

  assign e[1] = a[1] ^ b[1];
  assign S[1] = e[1] ^ c0;
  assign c1 = (b[1] & ~e[1]) | (e[1] & c0);

  assign e[2] = a[2] ^ b[2];
  assign S[2] = e[2] ^ c1;
  assign c2 = (b[2] & ~e[2]) | (e[2] & c1);

  assign e[3] = a[3] ^ b[3];
  assign S[3] = e[3] ^ c2;
  assign co = (b[3] & ~e[3]) | (e[3] & c2);

  assign s = S;

endmodule

module QtoHEX (Q, HEX);
  input [15:0] Q;
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