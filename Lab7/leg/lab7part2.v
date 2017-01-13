// Part 2 skeleton

module lab7part2
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		SW,
		// Your inputs and outputs here
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input	CLOCK_50;				//	50 MHz
	input [3:0]KEY;
	input [9:0]SW;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	
		
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
wire loadx,loady,turnblack,colourfrominput;
wire [3:0]countersix;
reg [7:0]xposition;
reg [6:0]yposition;
wire start;

always@(*)
begin
if(loadx)
xposition={1'b0,SW[6:0]};
if(loady)
yposition=SW[6:0];

end
wire temp;
control con(
.clock(CLOCK_50),
.black(~KEY[2]),
.plot(~KEY[1]),
.resetn(KEY[0]),
.go(~KEY[3]),
.countersix(countersix),

.loadx(loadx),
.loady(loady),
.plotenable(writeEn),
.colourfrominput(colourfrominput),
.turnblack(turnblack),
.start(start),
.temp(temp)
);
wire [14:0]blackcounter;
datapath dat(
.clock(CLOCK_50),
.resetn(KEY[0]),
.xycoor(SW[6:0]),
.xposition(xposition),
.yposition(yposition),
.colourinput(SW[9:7]),
.oldcountersix(countersix),

.loadx(loadx),
.loady(loady),
.plotenable(writeEn),
.colourfrominput(colourfrominput),
.turnblack(turnblack),
.start(start),
.temp(temp),

.countersix(countersix),
.x(x),
.y(y),
.colour(colour),
.oldblackcounter(blackcounter),
.blackcounter(blackcounter)
);

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn||turnblack||start),
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
	
	
endmodule

module control(
input clock,
input black,
input plot,
input resetn,
input go,
input [3:0]countersix,

output reg loadx,
output reg loady,
output reg plotenable,
output reg colourfrominput,
output reg turnblack,
output reg start,
output reg temp
);

reg [4:0] current_state, next_state;

localparam actstart=5'd0,
				actloadx=5'd1,
				actloadxwait=5'd2,
				actloady=5'd3,
				actcolourfrominput=5'd4,
				actplot=5'd5,
				actturnblack=5'd6,
				acttemp=5'd7;
				
always@(*)
	begin
		case(current_state)
		actstart:next_state=go? actloadx:actstart;
		
				actloadx:
				begin
				if(black)
				next_state=actturnblack;
				else if(go)
				next_state=actloadx;
				else if(!go)
				next_state=actloadxwait;
				end
				actloadxwait:
				begin
				if(black)
				next_state=actturnblack;
				else
				next_state=go? actloady:actloadxwait;
				end
				actloady:
				begin
				if(black)
				next_state=actturnblack;
				else
				next_state=go? actloady: actcolourfrominput;
				end
				actcolourfrominput:
				begin
				if(black)
				next_state=actturnblack;
				else
				next_state=plot? actplot: actcolourfrominput;
				end
				
				actplot:
					begin
					if(black)
					next_state=actturnblack;
					else if(go)
					next_state=actloadx;
					else
					
					next_state=actplot;
					end
				actturnblack:next_state=black? actturnblack:acttemp;
				acttemp:next_state=actcolourfrominput;
				
				
				default: next_state = actstart;
		endcase
	end
	
	always @(*)
    begin// enable_signals
        // By default make all our signals 0
			loadx=0;
			loady=0;
			plotenable=0;
			colourfrominput=0;
			turnblack=0;
		 start=0;
		 temp=0;
		 case (current_state)
		 actstart:start=1'd1;
			  actloadx:loadx=1'd1;
			  actloady:loady=1'd1;
			  actcolourfrominput:colourfrominput=1'd1;			  
			  actplot:plotenable=1'b1;			  
			  actturnblack:turnblack=1'd1;
			  acttemp:temp=1'd1;
			
		 endcase
	 end
	
always@(posedge clock)
    begin//: state_FFs
        if(!resetn)
            current_state <= actstart;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
input clock,
input resetn,
input [6:0]xycoor,
input [7:0]xposition,
input [6:0]yposition,
input [3:0]colourinput,
input [3:0]oldcountersix,

input loadx,
input loady,
input plotenable,
input colourfrominput,
input turnblack,
input start,
input temp,

output reg [3:0]countersix,
output reg [7:0]x,
output reg [6:0]y,
output reg [3:0] colour,

input [14:0]oldblackcounter,
output reg [14:0]blackcounter
);

always@(posedge clock) 
	begin
	countersix=oldcountersix;
	x=xposition;
	y=yposition;
	//colour=3'd0;
	if(loadx)
			begin
			blackcounter=0;
		x={1'b0,xycoor};
		//xposition={1'b0,xycoor};
		end
		
		else if(loady)
		begin
		blackcounter=0;
		y=xycoor;
		//yposition=xycoor;
		end
		
	else if(plotenable)
		begin
		blackcounter=0;

		countersix=oldcountersix+4'd1;
		
		x=xposition+countersix[1:0];
		y=yposition+countersix[3:2];
		
		end
	else if(colourfrominput)
	begin
	blackcounter=0;
		colour=colourinput;
		end
	else if(temp)
	begin
	
	x=xposition;
	y=yposition;
	end
	
	else if(!resetn||turnblack||start)
		begin
		//colour=3'd0;
		//countersix=oldcountersix+4'd1;
		
		//x=xposition+countersix[1:0];
		//y=yposition+countersix[3:2];
		
		colour=3'd0;
		x=oldblackcounter[7:0];
		y=oldblackcounter[14:8];
		blackcounter=oldblackcounter+15'b1;
		end
	end

endmodule
	
	