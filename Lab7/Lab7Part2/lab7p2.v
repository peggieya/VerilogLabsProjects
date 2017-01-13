module datapath(ld_x,ld_y,black,resetn,we,clear,ck,colorin,colour,x,y);
input ld_x,ld_y,black,resetn,we,ck,clear;
input [2:0]colorin;
output reg [2:0]colour;
output reg [7:0]x;
output reg [6:0]y;

reg [7:0]x0;
reg [6:0]y0;

always@(posedge ck)
begin 

if(!we)begin
x<=x0;
end

else if(ld_x&&we&&x<x0+2'd3)begin
x<=x+1'b1;
end

else if(ld_x&&we&&x==x0+2'd3)begin
x<=x0;
end

else x<=x;
end

always@(posedge ck)
begin 

if(!we)begin
y<=y0;
end

else if(ld_y&&we&&y<y0+3'd4&&x==x+2'd3)begin
y<=y+1'b1;
end

else if(ld_y&&we&&y==y0+3'd5&&x==x0)begin
y<=y0;
end

else y<=y;
end

always@(posedge ck)begin
if(black|clear) colour<=3'b000;
else colour<=colorin;
end
endmodule

module control(resetn,ck,ld_x,ld_y,writeEn,clear,go);
input resetn,ck,go;
output reg ld_x,ld_y,writeEn,clear;
reg [2:0] current_state, next_state;

localparam  S_LOAD_x       = 5'd0,//00000
            S_LOAD_x_WAIT   = 5'd1,//00001
            S_LOAD_y        = 5'd2,//00010
            S_LOAD_y_WAIT   = 5'd3;//00011

always@(*)
begin: state_table 
    case (current_state)
          S_LOAD_x: next_state = go ? S_LOAD_x_WAIT : S_LOAD_x; // Loop in current state until value is input
          S_LOAD_x_WAIT: next_state = go ? S_LOAD_x_WAIT : S_LOAD_y; // Loop in current state until go signal goes low
         S_LOAD_y: next_state = go ? S_LOAD_y_WAIT : S_LOAD_y; // Loop in current state until value is input
         S_LOAD_y_WAIT: next_state = go ? S_LOAD_y_WAIT : S_LOAD_x;
        default:     next_state = S_LOAD_x;
   endcase
end//state_table

always@(*)
begin: enable_signals
ld_x=1'b0;
ld_y=1'b0;

case(current_state)
  S_LOAD_x:begin
 ld_x = 1'b1;

  end
S_LOAD_y:begin
ld_y = 1'b1;

end
endcase
end//enable_signals


always@(posedge ck)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_x;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

// Part 2 skeleton

module lab7p2
    (
        CLOCK_50,                       //  On Board 50 MHz
        // Your inputs and outputs here
		  SW,
		  KEY,
        // The ports below are for the VGA output.  Do not change.
        VGA_CLK,                        //  VGA Clock
        VGA_HS,                         //  VGA H_SYNC
        VGA_VS,                         //  VGA V_SYNC
        VGA_BLANK_N,                        //  VGA BLANK
        VGA_SYNC_N,                     //  VGA SYNC
        VGA_R,                          //  VGA Red[9:0]
        VGA_G,                          //  VGA Green[9:0]
        VGA_B                           //  VGA Blue[9:0]
    );

    input           CLOCK_50;               //  50 MHz
    // Declare your inputs and outputs here
	 input [9:0]SW;// 9:7 - color, 6:0 - input X,Y
	 input [3:0]KEY;// 3 - load X(7b), 2 - black, 1 - plot, 0 - reset
    // Do not change the following outputs
    output          VGA_CLK;                //  VGA Clock
    output          VGA_HS;                 //  VGA H_SYNC
    output          VGA_VS;                 //  VGA V_SYNC
    output          VGA_BLANK_N;                //  VGA BLANK
    output          VGA_SYNC_N;             //  VGA SYNC
    output  [9:0]   VGA_R;                  //  VGA Red[9:0]
    output  [9:0]   VGA_G;                  //  VGA Green[9:0]
    output  [9:0]   VGA_B;                  //  VGA Blue[9:0]
    
    wire resetn;
    assign resetn = KEY[0];
    
	 wire [2:0]colorin;
	 wire ld_x,ld_y,black,clear;
	 assign colorin=SW[9:7];
	 assign black=~KEY[2];
	 assign go=~KEY[3];
    // Create the colour, x, y and writeEn wires that are inputs to the controller.

    wire [2:0] colour;
    wire [7:0] x;
    wire [6:0] y;
    wire writeEn;

    // Create an Instance of a VGA controller - there can be only one!
    // Define the number of colours as well as the initial background
    // image file (.MIF) for the controller.
    vga_adapter VGA(
            .resetn(resetn),
            .clock(CLOCK_50),
            .colour(colour),
            .x(x),
            .y(y),
            .plot(writeEn),
            /* Signals for the DAC to drive the monitor. */
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            .VGA_HS(VGA_HS),
            .VGA_VS(VGA_VS),
            .VGA_BLANK(VGA_BLANK_N),
            .VGA_SYNC(VGA_SYNC_N),
            .VGA_CLK(VGA_CLK));
        defparam VGA.RESOLUTION = "160x120";
        defparam VGA.MONOCHROME = "FALSE";
        defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
        defparam VGA.BACKGROUND_IMAGE = "black.mif";
            
    // Put your code here. Your code should produce signals x,y,colour and writeEn
    // for the VGA controller, in addition to any other functionality your design may require.
    datapath u0(ld_x,ld_y,black,resetn,writeEn,clear,CLOCK_50,colorin,colour,x,y);
    control u1(resetn,CLOCK_50,ld_x,ld_y,writeEn,clear,go);
endmodule