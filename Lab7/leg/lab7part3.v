// Part 2 skeleton

module lab7part3
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		SW,
		LEDR,
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

	input			CLOCK_50;				//	50 MHz
	input [0:0]KEY;
	input [9:7]SW;
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
	wire [3:0]countersix;
wire [3:0]countersixblack;
wire gonext;
wire drawabox,delay,erase,update;
wire selectdelay;
wire [7:0]xposition;
wire [6:0]yposition;
wire xfilp,yfilp;

wire [19:0]counter1;
wire [3:0]counter2;
output [9:0]LEDR;
assign LEDR[3:0]=countersix;
assign LEDR[9]=gonext;
assign LEDR[8]=delay;
assign LEDR[7]=selectdelay;
control con(
.resetn(resetn),
.clock(CLOCK_50),
.countersix(countersix),
.countersixblack(countersixblack),
.gonext(gonext),
.selectdelay(selectdelay),

.drawabox(drawabox),
.delay(delay),
.erase(erase),
.update(update)
);
reg turnblack;
wire [4:0]counterblack;
datapath dat(
.rawclock(CLOCK_50),
.resetn(resetn),
	
.oldcountersix(countersix),
.oldxposition(xposition),
.oldyposition(yposition),
.oldxfilp(xfilp),
.oldyfilp(yfilp),
.colourinput(SW[9:7]),
	
.drawabox(drawabox),
.delay(delay),
.erase(erase),
.update(update),

.countersix(countersix),
.gonext(gonext),
.xposition(xposition),
.yposition(yposition),
.xfilp(xfilp),
.yfilp(yfilp),
.x(x),
.y(y),
.colour(colour),
.writeEn(writeEn),

.oldcounter1(counter1),
.counter1(counter1),
.oldcounter2(counter2),
.counter2(counter2),
.oldcountersixblack(countersixblack),
.countersixblack(countersixblack),

.oldselectdelay(selectdelay),
.selectdelay(selectdelay),
.oldcounterblack(counterblack),
.counterblack(counterblack)	
);
always@(*)
begin
if(counterblack==5'd16)
turnblack=0;
else
turnblack=1;
end
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn||turnblack),
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
	
	
endmodule

module control(
input resetn,
input clock,
input [3:0]countersix,
input [3:0]countersixblack,
input gonext,
input selectdelay,

output reg drawabox,
output reg delay,
output reg erase,
output reg update
);

reg [4:0] current_state, next_state;

localparam actdrawabox=5'd0,
				actdelay=5'd1,
				acterase=5'd2,
				actupdate=5'd3;
				
always@(*)
	begin
		case(current_state)
			actdrawabox:next_state=(selectdelay)? actdelay:actdrawabox;
			actdelay:next_state=(gonext)?acterase:actdelay;
				acterase:next_state=(countersixblack==4'd15)? actupdate:acterase;
				actupdate:next_state=actdrawabox;
				default: next_state=actdrawabox;
		endcase
	end
	
always@(*)
	begin
					drawabox=0;
					delay=0;
					erase=0;
					update=0;
					
			case(current_state)
			actdrawabox:drawabox=1'd1;
			actdelay:delay=1'd1;
					acterase:erase=1'd1;
					actupdate:update=1'd1;
			endcase
	end
	
	always@(posedge clock)
    begin//: state_FFs
        if(!resetn)
            current_state <= actdrawabox;
        else
            current_state <= next_state;
    end // state_FFS
endmodule


module datapath(
	input rawclock,
	input resetn,
	
	input [3:0]oldcountersix,
	input [7:0]oldxposition,
	input [6:0]oldyposition,
	input oldxfilp,
	input oldyfilp,
	input [2:0]colourinput,
	
	input drawabox,
input delay,
input erase,
input update,
input oldselectdelay,

output reg [3:0]countersix,
output gonext,
output reg [7:0]xposition,
output reg [6:0]yposition,
output reg xfilp,
output reg yfilp,
output reg [7:0]x,
output reg [6:0]y,
output reg [2:0] colour,
output reg writeEn,

input [19:0] oldcounter1,
output reg [19:0]counter1,
input [3:0] oldcounter2,
output reg [3:0]counter2,
	input [3:0]oldcountersixblack,
output reg [3:0]countersixblack,

output reg selectdelay,

input [4:0]oldcounterblack,
output reg [4:0]counterblack
	
);
wire secondclock;
assign secondclock=(oldcounter1==20'd833334)? 1'b1:1'b0;
assign gonext=(oldcounter2==4'd15)? 1'b1:1'b0;



always@(posedge rawclock)
	begin
		counter1=oldcounter1;
		counter2=oldcounter2;
		countersix=oldcountersix;
		countersixblack=oldcountersixblack;
		xposition=oldxposition;
		yposition=oldyposition;
		xfilp=oldxfilp;
		yfilp=oldyfilp;
		writeEn=0;//only draw and erase can be 1
		//colour=??????????????
selectdelay=oldselectdelay;
counterblack=oldcounterblack;
		if(!resetn)
			begin
			if(counterblack!=5'd16)
			begin
			writeEn=1'b1;
			colour=3'd0;
			
				
				
		x=xposition+counterblack[1:0];
		y=yposition+counterblack[3:2];
		if(counterblack!=5'd16)
				counterblack=oldcounterblack+1'd1;
		
			end
		else
				begin
						x<=0;
				y<=0;
				xposition<=0;
				yposition<=0;
				colour<=colourinput;
				countersix<=0;
				writeEn<=1'b1;
				counter1<=0;
				counter2<=0;
				countersixblack<=0;
				xfilp<=0;
				yfilp<=0;
						selectdelay=0;
				end
				
			end
		else if(drawabox)
			begin
				writeEn=1'b1;
				colour=colourinput;
				countersix=oldcountersix+4'd1;
				x=xposition+countersix[1:0];
				y=yposition+countersix[3:2];
				if(countersix==4'd15)
					selectdelay=1'b1;
					
					
					counterblack=0;
					
					
			end
		else if(delay)//////////////////??????????????????????????????????????????????????????????????????????????????????
			begin
			selectdelay=1'b0;
			countersix=0;
			if((!secondclock))
				begin
					counter1=oldcounter1+1'd1;
				end
			if(secondclock)
				begin
					counter2=oldcounter2+1'd1;
					counter1=0;
				end

			
		counterblack=0;
		
			end
			
		else if(erase)
			begin
			counter1=0;
			counter2=0;
			writeEn=1'b1;
			colour=3'd0;
		countersixblack=oldcountersixblack+4'd1;
		x=xposition+countersixblack[1:0];
		y=yposition+countersixblack[3:2];
			
			end
		else if(update)
			begin
				countersixblack=0;
				if(yposition==7'd116||(yposition==0&&xposition!=0))
				yfilp=~oldyfilp;
				if((xposition==0&&yposition!=0)||xposition==8'd156)
				xfilp=~oldxfilp;
				
				
				if(xfilp==0&&yfilp==0)
				begin
				xposition=oldxposition+1'd1;
				yposition=oldyposition+1'd1;
				end
				
				
				if(xfilp==0&&yfilp==1)
				begin
				xposition=oldxposition+1'd1;
				yposition=oldyposition-1'd1;
				end
				
				
				if(xfilp==1&&yfilp==0)
				begin
				xposition=oldxposition-1'd1;
				yposition=oldyposition+1'd1;
				end
				
				
				if(xfilp==1&&yfilp==1)
				begin
				xposition=oldxposition-1'd1;
				yposition=oldyposition-1'd1;
				end
			
			countersix=0;
			
			
			counterblack=0;
			
			end
end

endmodule



