module part6(SW, LEDR, LEDG, HEX2, HEX1, HEX0);
  input [16:0] SW;
  output [15:0] LEDR;
  output [8:0] LEDG;
  output [6:0] HEX2, HEX1, HEX0;

  assign LEDR = SW;
  
  reg [4:0] T0, T1;
  reg [3:0] Z0, Z1, S0, S1, S2;
  reg c1, c2;
  
  always
   begin
	  T0 = SW[11:8] + SW[3:0];
	  if(T0 > 9) begin
	    Z0 = 10;
		 c1 = 1;
	  end else begin
	    Z0 = 0;
		 c1 = 0;
	  end
	  S0 = T0 - Z0;
	 
	  T1 = SW[15:12] + SW[7:4] + c1;
	  if(T1>9) begin
	    Z1 = 10;
		 c2 = 1;
	  end else begin
	    Z1 = 0;
		 c2 = 0;
	  end
	  S1 = T1 - Z1;
	  S2 = c2;
	end
	 
  decoder_7seq D0 (S0, HEX0);
  decoder_7seq D1 (S1, HEX1);
  decoder_7seq D2 (S2, HEX2);

endmodule

module decoder_7seq(M, HEX0);
  input [3:0] M;
  output [6:0] HEX0;

  assign HEX0[0] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & M[2] & ~M[1] & ~M[0]);
  assign HEX0[1] = (~M[3] & M[2] & ~M[1] & M[0])|(~M[3] & M[2] & M[1] & ~M[0]);
  assign HEX0[2] = (~M[3] & ~M[2] & M[1] & ~M[0]);
  
  assign HEX0[3] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & M[2] & ~M[1] & ~M[0])|
                   (~M[3] & M[2] & M[1] & M[0])|(M[3] & ~M[2] & ~M[1] & M[0]);

  assign HEX0[4] = ~((~M[2] & ~M[1] & ~M[0])|(~M[3] & M[1] & ~M[0]));

  assign HEX0[5] = (~M[3] & ~M[2] & ~M[1] & M[0])|(~M[3] & ~M[2] & M[1] & ~M[0])|
						 (~M[3] & ~M[2] & M[1] & M[0])|(~M[3] & M[2] & M[1] & M[0]);

  assign HEX0[6] = (~M[3] & ~M[2] & ~M[1] & ~M[0])|(~M[3] & ~M[2] & ~M[1] & M[0])|
                   (~M[3] & M[2] & M[1] & M[0]);

endmodule