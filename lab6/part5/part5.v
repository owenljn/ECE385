module part5 (CLOCK_50, AUD_DACDAT);
	input CLOCK_50;
	output AUD_DACDAT;

	reg [16:0] counter;

	always @(posedge CLOCK_50) 
		if (counter == 113636) 
			counter <= 0; 
		else 
			counter <= counter+1;

	reg AUD_DACDAT;
	always @ (posedge CLOCK_50)
		if (counter == 113636)
			AUD_DACDAT = ~AUD_DACDAT;

endmodule
