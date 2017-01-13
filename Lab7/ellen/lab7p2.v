//load X first then Y
//SW[6:0] to load X and Y
//SW[9:7] is the color
//X is [7:0] while Y is [6:0]
//KEY[3] fist load X
//KEY[1] is plot
//KEY[2] enable the whole screen clear to black
//KEY[0] active low reset

module lab7p2
	(   
		SW,
	   KEY,
		CLOCK_50,						//	On Board 50 MHz
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
   input [9:0] SW;
	input [3:0] KEY;
	input			CLOCK_50;				//	50 MHz
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
	
	
	wire go;
	wire goblack;
	wire plot;
	wire resetn;
	
	wire [7:0] x_POS;
	wire [6:0] y_POS;	
	wire [2:0] colour;
	wire writeEn;
	
	
	reg [7:0] x;
	reg [6:0] y;
	assign go=~KEY[3];
	assign goblack=~KEY[2];
	assign resetn = KEY[0];
	assign plot=~KEY[1];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.


	
	
	
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
	
	
	reg ld_x,ld_imag;
	
																																																																											
	
	
	
	
	//control


    reg [2:0] current_state, next_state; 
    
    localparam  S_LOAD_X        = 3'b000,
                S_LOAD_X_WAIT   = 3'b001,
                S_LOAD_Y        = 3'b010,
                PLOT		    	= 3'b011,
				    PLOT_WAIT          = 3'b100;

    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X; // Loop in current state until value is input
                S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_LOAD_Y; // Loop in current state until go signal goes low
                S_LOAD_Y: next_state = plot ? PLOT : S_LOAD_Y; // Loop in current state until value is input
                PLOT: next_state = plot? PLOT : PLOT_WAIT;
			      PLOT_WAIT: next_state = go?S_LOAD_X : PLOT_WAIT;
		default: next_state = S_LOAD_X;
		endcase
	end
  
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_x = 1'b0;
		  ld_imag= 1'b0;

        case (current_state)
            S_LOAD_X: begin
                ld_x = 1'b1;
                end
            PLOT: begin
                ld_imag = 1'b1;
                end
					 endcase
					 
    end // enable_signals
   
    // current_state registers
    always@(posedge CLOCK_50)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_X;
        else
            current_state <= next_state;
    end // state_FFS




 

//datapath
    wire [1:0]dt_x;
	 wire [1:0] dt_y;
	 reg [3:0] counter;
	 always@(posedge CLOCK_50)
	 begin
		if(ld_imag)
			counter <= counter + 1'b1;
	end
	assign dt_x = counter[1:0];
	assign dt_y = counter[3:2];
	wire [6:0] xout;
	
	
	integer bk_x=0,bk_y=0; //to clear all as black
	
	
    // Registers x,y with respective input logic
   always@(posedge CLOCK_50)
	begin:drawing
		x <= 0;
		y <= 0;
		if(goblack) begin
			if(bk_y < 120) begin
				if(bk_x < 160) begin
					x <= bk_x;
					y <= bk_y;
					bk_x = bk_x + 1;
					end
				else begin
					bk_x <= 0;
					bk_y <= bk_y + 1;
				end
			end
			else begin bk_x <= 0; bk_y <= 0; end
		end  
		else 
		if(ld_imag)
			begin
					x <= x_POS + dt_x;
					y <= y_POS + dt_y;
			end
	end
	
	regbit r1(SW[6:0],CLOCK_50,resetn,ld_x,xout[6:0]);//LOAD VALUE INTO X
	assign x_POS = {1'b0,xout[6:0]};
	assign y_POS = SW[6:0];
	assign colour = goblack? 3'b000 :SW[9:7];
	assign writeEn = goblack? 1 :ld_imag;

endmodule


module regbit(D,clock,reset,E,Q);
	input [6:0]D;
	input clock,reset,E;
	output reg [6:0]Q;
	
	always@(posedge clock)
		if(!reset)
			Q <= 0;
		else if(E)
			Q <= D;
endmodule
