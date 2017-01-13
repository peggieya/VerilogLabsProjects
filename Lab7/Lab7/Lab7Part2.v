module Lab7Part2(KEY,
     SW,
     CLOCK_50,
     VGA_CLK,         // VGA Clock
     VGA_HS,       // VGA H_SYNC
     VGA_VS,       // VGA V_SYNC
     VGA_BLANK_N,     // VGA BLANK
     VGA_SYNC_N,      // VGA SYNC
     VGA_R,         // VGA Red[9:0]
     VGA_G,        // VGA Green[9:0]
     VGA_B         // VGA Blue[9:0]
    ); 
  input [9:0]SW;   //SW[9:7] Colour, SW[6:0] is for coordinates
  input [3:0]KEY;  //KEY[0] Low Resetn, KEY[1] Plot, KEY[2] Screen Goes Black, KEY[3] Load Register
  input CLOCK_50;
  
  wire [2:0]colour;
  wire [6:0]coordinates;
  wire resetn, plot, s_black, load;
  
  assign colour = SW[9:7];
  assign coordinates = SW[6:0];
  assign resetn = KEY[0];
  assign plot = ~KEY[1];
  assign s_black = ~KEY[2];
  assign load = ~KEY[3];
  
  output   VGA_CLK;       // VGA Clock
  output   VGA_HS;      // VGA H_SYNC
  output   VGA_VS;      // VGA V_SYNC
  output   VGA_BLANK_N;    // VGA BLANK
  output   VGA_SYNC_N;    // VGA SYNC
  output [9:0]VGA_R;        // VGA Red[9:0]
  output [9:0]VGA_G;       // VGA Green[9:0]
  output [9:0]VGA_B;        // VGA Blue[9:0]
  
  wire [7:0] coord_x;
  wire [6:0] coord_y;
  wire [2:0] out_colour;
  reg writeEn;
  
  wire write;
  
  always@(*) begin
   writeEn = 1'b0;
   if(s_black)
    writeEn = 1'b1;
   else
    writeEn = write;
  end
  
  vga_adapter VGA(
    .resetn(resetn),
    .clock(CLOCK_50),
    .colour(out_colour),
    .x(coord_x),
    .y(coord_y),
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
  
  wire ld_x,ld_y;
  wire [3:0]count;
  
  control c0(.load(load),
    .plot(plot),
    .clk(CLOCK_50),
    .resetn(resetn),
    .ld_x(ld_x),
    .ld_y(ld_y),
    .ld_plot(write),
    //.count(count)
     );
  datapath d0(.resetn(resetn),
     .clk(CLOCK_50),
     .ld_x(ld_x),
     .ld_y(ld_y),
     .ld_plot(write),
     .coordinates(coordinates),
     //.count(count),
     .colour(colour),
     .out_colour(out_colour),
     .coord_x(coord_x),
     .coord_y(coord_y),
     .s_black(s_black));
  
 endmodule

module control(input load,plot,clk,resetn,
      output reg ld_x,ld_y,ld_plot
      );
  
  
  reg [4:0] count;
  reg [5:0] current_state, next_state;
  localparam  S_LOAD_X     = 5'd0,
             S_LOAD_X_WAIT   = 5'd1,
             S_LOAD_Y     = 5'd2,
             S_LOAD_Y_WAIT   = 5'd3,
             S_WAIT_P     = 5'd4,
             S_PLOT_0     = 5'd7,
     S_PLOT_1     = 5'd8;     
      
  
  // Next state logic aka our state table
  always@(*)
  begin: state_table
          case (current_state)
              S_LOAD_X: next_state = load ? S_LOAD_X_WAIT : S_LOAD_X;
    S_LOAD_X_WAIT: next_state = load ? S_LOAD_X_WAIT : S_LOAD_Y;
    S_LOAD_Y: next_state = load ? S_LOAD_Y_WAIT : S_LOAD_Y;
    S_LOAD_Y_WAIT: next_state = load ? S_LOAD_Y_WAIT : S_WAIT_P;
    S_WAIT_P: next_state = plot ? S_PLOT_0 : S_WAIT_P;
    S_PLOT_0: next_state = S_PLOT_1;   
    S_PLOT_1: next_state = (count == 5'b10000) ? S_LOAD_X : S_PLOT_1;
          default: next_state = S_LOAD_X;
      endcase
  end // state_table
   
  // Output logic aka all of our datapath control signals
  always @(*)
  begin: enable_signals
      // By default make all our signals 0
      ld_x = 1'b0;
      ld_y = 1'b0;
  ld_plot = 1'b0;

     case (current_state)
          S_LOAD_X: begin
      ld_x = 1'b1;
      end
     S_LOAD_Y: begin
      ld_y = 1'b1;
      end
     S_PLOT_0: begin
      ld_plot = 1'b1;
      end
     S_PLOT_1: begin
      ld_plot = 1'b1;
      end
      // default: // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
      endcase
  end // enable_signals
   
  // current_state registers
  always@(posedge clk)
  begin: state_FFs
      if(!resetn) begin
          current_state <= S_LOAD_X;
     count <= 5'd0;
     end
      else begin
          current_state <= next_state;
     if (current_state == S_PLOT_1)
      count <= count + 1'b1;
     end
  end // state_FFS
 endmodule

module datapath(input resetn, clk, ld_x,ld_plot,ld_y, s_black,
     input [6:0]coordinates,
     //input [3:0]count,
     input [2:0]colour,
     output reg [2:0] out_colour,
     output reg [7:0] coord_x,
     output reg [6:0] coord_y
  );
  
  reg [7:0]x;
  reg [6:0]y;
  reg p;
  reg [14:0] bcount;
  
  // Registers p, y, x with respective input logic
  always@(posedge clk) begin
      if(!resetn) begin
          x <= 8'b0;
          y <= 7'b0;
     p <= 1'b0;
      end
      else begin
          if(ld_x)
              x <= {1'b0,coordinates};
          if(ld_y)
              y <= coordinates;
          if(ld_plot)
              p <= 1'b1;
   end
   end
  
  reg [4:0] count;
  
  always@(posedge clk) begin
   if (!resetn)
    count <= 5'd0;
   if (p) begin
    if(count == 5'b10000)
     count <= 5'd0;
    else
     count <= count + 1'b1;
    end
  end
  
  
  // Output result register
  always@(posedge clk) begin
      if(!resetn) begin
          coord_x <= 8'd0;
     coord_y <= 7'd0;
     out_colour <= 3'b000;
     bcount <= 15'd0;
      end
      else begin
          if(p) begin
              coord_x <= x + count[1:0];
    coord_y <= y + count[3:2];
    out_colour <= colour;
      end
     if (s_black) begin
      bcount <= bcount + 1'b1;
      coord_x <= x + bcount[7:0];
      coord_y <= y + bcount[14:8];
      out_colour <= 3'b000;
     end
    end 
  end
 endmodule
