module ps2lab1(
  // Clock Input (50 MHz)
  input  CLOCK_50,
  //  Push Buttons
  input  [3:0]  KEY,
  //  DPDT Switches 
  input  [17:0]  SW,
  //  LEDs
  output  [8:0]  LEDG,  //  LED Green[8:0]
  output  [17:0]  LEDR,  //  LED Red[17:0]
  //  PS2 data and clock lines		
  input	PS2_DAT,
  input	PS2_CLK,
  //  GPIO Connections
  inout  [35:0]  GPIO_0, GPIO_1,
//	LCD Module 16X2
  output LCD_ON,	// LCD Power ON/OFF
  output LCD_BLON,	// LCD Back Light ON/OFF
  output LCD_RW,	// LCD Read/Write Select, 0 = Write, 1 = Read
  output LCD_EN,	// LCD Enable
  output LCD_RS,	// LCD Command/Data Select, 0 = Command, 1 = Data
  inout [7:0] LCD_DATA	// LCD Data bus 8 bits
);

//  set all inout ports to tri-state
assign  GPIO_0    =  36'hzzzzzzzzz;
assign  GPIO_1    =  36'hzzzzzzzzz;

wire RST;
assign RST = KEY[0];


// Connect dip switches to red LEDs
assign LEDR[17:0] = SW[17:0];

// turn off green LEDs
assign LEDG = 0;

wire reset = 1'b0;
wire [7:0] scan_code;

reg [7:0] history[1:4];
wire read, scan_ready;

oneshot pulser(
   .pulse_out(read),
   .trigger_in(scan_ready),
   .clk(CLOCK_50)
);

keyboard kbd(
  .keyboard_clk(PS2_CLK),
  .keyboard_data(PS2_DAT),
  .clock50(CLOCK_50),
  .reset(reset),
  .read(read),
  .scan_ready(scan_ready),
  .scan_code(scan_code)
);

lcdlab3 lcdlab (
  .CLOCK_50(CLOCK_50),	//	50 MHz clock
  .KEY(KEY),      //	Pushbutton[3:0]
  .history1(history1), .history2(history2), .history3(history3), .history4(history4),
  .GPIO_0(GPIO_0),
  .GPIO_1(GPIO_1),	//	GPIO Connections
//	LCD Module 16X2
  .LCD_ON(LCD_ON),	// LCD Power ON/OFF
  .LCD_BLON(LCD_BLON),	// LCD Back Light ON/OFF
  .LCD_RW(LCD_RW),	// LCD Read/Write Select, 0 = Write, 1 = Read
  .LCD_EN(LCD_EN),	// LCD Enable
  .LCD_RS(LCD_RS),	// LCD Command/Data Select, 0 = Command, 1 = Data
  .LCD_DATA(LCD_DATA)	// LCD Data bus 8 bits
);

always @(posedge scan_ready)
begin
	history[4] <= history[3];
	history[3] <= history[2];
	history[2] <= history[1];
	history[1] <= scan_code;
end

wire [7:0] history1, history2, history3, history4;
assign history1 = history[1];
assign history2 = history[2];
assign history3 = history[3];
assign history4 = history[4];

endmodule
