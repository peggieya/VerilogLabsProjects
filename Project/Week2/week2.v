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
reg	VGA_CLK;   				//	VGA Clock
reg			VGA_HS;					//	VGA H_SYNC
reg		VGA_VS;					//	VGA V_SYNC
reg			VGA_BLANK_N;				//	VGA BLANK
	reg			VGA_SYNC_N;				//	VGA SYNC
	reg	VGA_R;   				//	VGA Red[9:0]
	reg	VGA_G;	 				//	VGA Green[9:0]
	reg	VGA_B;   				//	VGA Blue[9:0]
wire [2:0]rgb;
   assign rgb[2] = rgb[2];
   assign rgb[1] = rgb[1];
   assign rgb[0] = rgb[0];
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
		
		PB u0(.kb_data(), 
		.kb_clk(), 
		.ori_clkin(CLK_50),
		.vga_clk(VGA_CLK),
		.vga_blank_n(VGA_BLANK_N),
		.vga_sync_n(VGA_SYNC_N),
		.hsync(VGA_HS),
	   .vsync(VGA_VS), 
		.rgbout(rgb)
		);
	
	endmodule
	
module PB(kb_data, kb_clk, ori_clkin, /*led, led2, led3, led4,*/vga_clk,vga_blank_n,vga_sync_n,hsync, vsync, rgbout);
   input           kb_data;
   input           kb_clk;
   input           ori_clkin;
   
 //  output [6:0]    led;
 //  output [6:0]    led2;
 //  output [6:0]    led3;
  // output [6:0]    led4;
   output       hsync;
	reg          hsync;
   output          vsync;
   reg             vsync;
   output [2:0]    rgbout;
	output   vga_sync_n;
	output 			vga_clk;
   output 			vga_blank_n;
//	output			d;
   
   wire            ori_clk;
   reg [3:0]       count;
   reg [26:0]      count_sec;
   reg             clk;
   wire            clk_for;
   
   reg [8:0]       hcnt;
   reg [9:0]       vcnt;
   reg [2:0]       rgb;
   
   reg             win_sign;
   reg             life_sign;
   
   wire            rst;
   wire [3:0]      dout;
   wire [3:0]      dout2;
   wire [3:0]      dout3;
   wire [3:0]      dout4;
   reg             clkin;
   reg             clkin2;
   reg             clk6;
   reg             clk62;
   
   reg [7:0]       box1_x;
   reg [8:0]       box1_y;
   reg [7:0]       box2_x;
   reg [8:0]       box2_y;
   reg [7:0]       boy_x;
   reg [8:0]       boy_y;
   reg [7:0]       brick1_x;
   reg [8:0]       brick1_y;
   reg [7:0]       brick2_x;
   reg [8:0]       brick2_y;
   reg [7:0]       brick3_x;
   reg [8:0]       brick3_y;
   reg [7:0]       pos1_x;
   reg [8:0]       pos1_y;
   reg [7:0]       pos2_x;
   reg [8:0]       pos2_y;
   wire [7:0]      data_in;
   wire            data_ready;
   reg             start;
   reg             push_reset;
	reg 	[2:0]		 win_num;
	wire clk100hz;
   
   parameter [2:0] clbrick = 3'b100;
   parameter [2:0] clpos = 3'b111                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ;
   parameter [2:0] clboy = 3'b001;
   parameter [2:0] clbox = 3'b110;
   parameter [2:0] clback = 3'b000;
   parameter [2:0] clgrid = 3'b101;
   parameter [2:0] clin = 3'b011;
   
 //  div_clk U0(.clk(ori_clk),.rst(rst),.clk1khz(clk1khz),.clk100hz(clk100hz),.clk1mhz(clk1mhz));
   cnt10 U1(.Q(dout), .CLK(clkin), .ACLR(rst));
   
   cnt6 U2(.Q(dout2[2:0]), .CLK(clk6), .ACLR(rst));
   
   cnt10 U3(.Q(dout3), .CLK(clkin2), .ACLR(rst));
   
   cnt6 U4(.Q(dout4[2:0]), .CLK(clk62), .ACLR(rst));
   

   
   keyboard U9(.kb_data(kb_data), .kb_clk(kb_clk), .clk(clk), .reset(push_reset), .data(data_in), .data_ready(data_ready));
   
   assign dout2[3] = 1'b0;
   assign dout4[3] = 1'b0;
   assign rst = (~(start & push_reset));
   assign vga_clk = clk;
	assign vga_sync_n = 1'b0;
	assign vga_blank_n = vsync & hsync;
   
   always @(posedge clk)
      if (data_ready == 1'b1)
         case (data_in)
            8'h5A :
               start <= 1'b0;
            8'h2D :
               push_reset <= 1'b0;
            default :
               ;
         endcase
      else
      begin
         start <= 1'b1;
         push_reset <= 1'b1;
      end
   
   
   always @(posedge clk)
   begin: xhdl0
      reg [29:0]      num;
      if (life_sign == 1'b0)
         clkin <= 1'b0;
      else if (clk == 1'b1)
      begin
         if (num == 2000000)
         begin
            num = 0;
            clkin <= (~clkin);
         end
         else
            num = num + 1;
      end
   end
   
   
   always @(dout)
      if (dout == 9)
         clk6 <= 1'b0;
      else
         clk6 <= 1'b1;
   
   
   always @(dout2)
      if (dout2 == 5)
         clkin2 <= 1'b0;
      else
         clkin2 <= 1'b1;
   
   
   always @(dout3)
      if (dout3 == 9)
         clk62 <= 1'b0;
      else
         clk62 <= 1'b1;
   
   
   always @(posedge ori_clk )
   begin
      
      begin
         count <= count + 1;
         count_sec <= count_sec + 1;
      end
      if (count == 4)
      begin
         clk <= (~(clk));
         count <= 4'b0000;
      end
   end
   
   assign clk_for = count_sec[21];
   assign rgbout[2] = rgb[2];
   assign rgbout[1] = rgb[1];
   assign rgbout[0] = rgb[0];
   
   
   always @(posedge hsync or negedge push_reset)
      if (push_reset == 1'b0)
      begin
         vsync <= 1'b1;
         vcnt <= 10'b0000000000;
      end
      else 
      begin
         if (vcnt < 526)
            vcnt <= vcnt + 1;
         else
            vcnt <= 10'b0000000000;
         if (vcnt >= 524 & vcnt < 526)
            vsync <= 1'b0;
         else
            vsync <= 1'b1;
      end
   
   
   always @(posedge clk or negedge push_reset)
      if (push_reset == 1'b0)
      begin
         hcnt <= 9'b000000000;
         hsync <= 1'b1;
      end
      else 
      begin
         if (hcnt < 126)
            hcnt <= hcnt + 1;
         else
            hcnt <= 9'b000000000;
         if (hcnt > 116 & hcnt < 126)
            hsync <= 1'b0;
         else
            hsync <= 1'b1;
      end
   
   
   always @(posedge clk)
      
      begin
         if (hcnt >= 16 & hcnt <= 91 & vcnt >= 63 & vcnt <= 385)
         begin
            if (life_sign == 1'b1)
            begin
               if (hcnt == 16 | hcnt == 31 | hcnt == 46 | hcnt == 61 | hcnt == 76 | hcnt == 91 | vcnt == 64 | vcnt == 128 | vcnt == 192 | vcnt == 256 | vcnt == 320 | vcnt == 384 | vcnt == 65 | vcnt == 129 | vcnt == 193 | vcnt == 257 | vcnt == 321 | vcnt == 385)
                  rgb <= clgrid;
               else if (hcnt > boy_x + 1 & hcnt < boy_x + 14 & vcnt > boy_y + 8 & vcnt < boy_y + 51)
                  rgb <= clboy;
               else if (hcnt > box1_x + 1 & hcnt < box1_x + 14 & vcnt > box1_y + 8 & vcnt < box1_y + 51)
                  rgb <= clbox;
               else if (hcnt > box2_x + 1 & hcnt < box2_x + 14 & vcnt > box2_y + 8 & vcnt < box2_y + 51)
                  rgb <= clbox;
               else if (hcnt > pos1_x + 2 & hcnt < pos1_x + 12 & vcnt > pos1_y + 15 & vcnt < pos1_y + 40)
                  rgb <= clpos;
               else if (hcnt > pos2_x + 2 & hcnt < pos2_x + 12 & vcnt > pos2_y + 15 & vcnt < pos2_y + 40)
                  rgb <= clpos;
               else if (hcnt > brick1_x + 1 & hcnt < brick1_x + 14 & vcnt > brick1_y + 8 & vcnt < brick1_y + 51)
                  rgb <= clbrick;
               else if (hcnt > brick2_x + 1 & hcnt < brick2_x + 14 & vcnt > brick2_y + 8 & vcnt < brick2_y + 51)
                  rgb <= clbrick;
               else if (hcnt > brick3_x + 1 & hcnt < brick3_x + 14 & vcnt > brick3_y + 8 & vcnt < brick3_y + 51)
                  rgb <= clbrick;
               else
                  rgb <= clin;
            end
/*            else if (win_sign == 1'b0)
            begin
               
               if (count_sec[23] == 1'b1)
               begin
                  if ((hcnt > 31 & hcnt < 37 & vcnt > 250 & vcnt < 280) | (hcnt > 33 & hcnt < 42 & vcnt > 295 & vcnt < 320) | (hcnt > 42 & hcnt < 45 & vcnt > 280 & vcnt < 320) | (hcnt > 30 & hcnt < 33 & vcnt > 330 & vcnt < 350) | (hcnt > 37 & hcnt < 40 & vcnt > 330 & vcnt < 350) | (hcnt > 27 & hcnt < 30 & vcnt > 360 & vcnt < 380) | (hcnt > 35 & hcnt < 38 & vcnt > 360 & vcnt < 380))
                     
                     rgb <= 3'b001;
                  else if (hcnt > 45 & hcnt < 55 & vcnt > 275 & vcnt < 325)
                     rgb <= 3'b110;
                  else
                     rgb <= 3'b000;
               end
               else
                  if ((hcnt > 29 & hcnt < 35 & vcnt > 250 & vcnt < 280) | (hcnt > 31 & hcnt < 40 & vcnt > 295 & vcnt < 320) | (hcnt > 40 & hcnt < 43 & vcnt > 280 & vcnt < 320) | (hcnt > 30 & hcnt < 33 & vcnt > 330 & vcnt < 350) | (hcnt > 35 & hcnt < 38 & vcnt > 330 & vcnt < 350) | (hcnt > 29 & hcnt < 32 & vcnt > 360 & vcnt < 380) | (hcnt > 37 & hcnt < 40 & vcnt > 360 & vcnt < 380))
                     
                     rgb <= 3'b001;
                  else if (hcnt > 43 & hcnt < 53 & vcnt > 275 & vcnt < 325)
                     rgb <= 3'b110;
                  else
                     rgb <= 3'b000;
            end
				*/
 /*           else
               
               if ((vcnt > 190 & vcnt < 201) & ((hcnt > 29 & hcnt < 38) | (hcnt > 46 & hcnt < 53) | hcnt == 60 | hcnt == 61 | hcnt == 68 | hcnt == 69 | (hcnt > 74 & hcnt < 83)))
                  rgb <= clbox;
               else if ((vcnt > 200 & vcnt < 211) & (hcnt == 30 | hcnt == 31 | hcnt == 38 | hcnt == 39 | hcnt == 45 | hcnt == 46 | hcnt == 53 | hcnt == 54 | (hcnt > 59 & hcnt < 64) | hcnt == 68 | hcnt == 69 | hcnt == 75 | hcnt == 76))
                  rgb <= clbox;
               else if ((vcnt > 210 & vcnt < 221) & (hcnt == 30 | hcnt == 31 | hcnt == 38 | hcnt == 39 | hcnt == 45 | hcnt == 46 | hcnt == 53 | hcnt == 54 | hcnt == 60 | hcnt == 61 | hcnt == 64 | hcnt == 65 | hcnt == 68 | hcnt == 69 | (hcnt > 74 & hcnt < 83)))
                  rgb <= clbox;
               else if ((vcnt > 220 & vcnt < 231) & (hcnt == 30 | hcnt == 31 | hcnt == 38 | hcnt == 39 | hcnt == 45 | hcnt == 46 | hcnt == 53 | hcnt == 54 | hcnt == 60 | hcnt == 61 | (hcnt > 65 & hcnt < 70) | hcnt == 75 | hcnt == 76))
                  rgb <= clbox;
               else if ((vcnt > 230 & vcnt < 241) & ((hcnt > 29 & hcnt < 38) | (hcnt > 46 & hcnt < 53) | hcnt == 60 | hcnt == 61 | hcnt == 68 | hcnt == 69 | (hcnt > 74 & hcnt < 83)))
                  rgb <= clbox;
               else
                  rgb <= clgrid;
         end
			*/
   /*      else
            
            if (vcnt > 450 & vcnt < 490 & hcnt > 16 & hcnt < 91)
            begin
               if (life_sign == 1'b1)
               begin
                  if ((dout2 > 0 & hcnt < 20 & hcnt > 15) | (dout2 > 1 & hcnt < 25 & hcnt > 20) | (dout2 > 2 & hcnt < 30 & hcnt > 25) | (dout2 > 3 & hcnt < 35 & hcnt > 30) | (dout2 > 4 & hcnt < 40 & hcnt > 35))
                     rgb <= 3'b100;
                  else
                     rgb <= clback;
               end
            end
            
            else if (vcnt > 400 & vcnt < 440 & hcnt > 16 & hcnt < 91)
            begin
               if (life_sign == 1'b1)
               begin
                  if (((dout == 0 | dout > 0) & hcnt < 20 & hcnt > 15) | (dout > 0 & hcnt < 25 & hcnt > 20) | (dout > 1 & hcnt < 30 & hcnt > 25) | (dout > 2 & hcnt < 35 & hcnt > 30) | (dout > 3 & hcnt < 40 & hcnt > 35) | (dout > 4 & hcnt < 45 & hcnt > 40) | (dout > 5 & hcnt < 50 & hcnt > 45) | (dout > 6 & hcnt < 55 & hcnt > 50) | (dout > 7 & hcnt < 60 & hcnt > 55) | (dout > 8 & hcnt < 65 & hcnt > 60))
                     rgb <= 3'b100;
                  else
                     rgb <= clback;
               end
               else
                  rgb <= 3'b010;
            end
				*/
            else
               
               rgb <= 3'b000;
					
      end
   
   assign ori_clk = ori_clkin;
   
   
   always @( posedge clk or negedge push_reset)
      if (push_reset == 1'b0)
      begin
         win_sign <= 1'b0;
			win_num <= 3'b0;
         life_sign <= 1'b0;
         boy_x <= 8'b00111101;  //3D
         boy_y <= 9'b001000001;  //41
         box1_x <= 8'b00011111;   //1F
         box1_y <= 9'b011000001;  //C1
         box2_x <= 8'b00101110;   //2E
         box2_y <= 9'b100000001;  //101
         brick1_x <= 8'b00111101;  //3D
         brick1_y <= 9'b010000001;  //81
         brick2_x <= 8'b00101110;   //2E
         brick2_y <= 9'b011000001;   //C1
         brick3_x <= 8'b00111101;    //3D
         brick3_y <= 9'b011000001;  //C1
         pos1_x <= 8'b00010000;      //10
         pos1_y <= 9'b101000001;  //141
         pos2_x <= 8'b00101110;   //2E
         pos2_y <= 9'b101000001;  //141
      end
      
      else 
      begin
         if (start == 1'b0)
         begin
            life_sign <= 1'b1;
            if (win_sign <= 1'b0)
            case(win_num)
					3'b000:begin
               boy_x <= 8'b00111101;
               boy_y <= 9'b001000001;
               box1_x <= 8'b00011111;
               box1_y <= 9'b011000001;
               box2_x <= 8'b00101110;
               box2_y <= 9'b100000001;
               brick1_x <= 8'b00111101;
               brick1_y <= 9'b010000001;
               brick2_x <= 8'b00101110;
               brick2_y <= 9'b011000001;
               brick3_x <= 8'b00111101;
               brick3_y <= 9'b011000001;
               pos1_x <= 8'b00010000;
               pos1_y <= 9'b101000001;
               pos2_x <= 8'b00101110;
               pos2_y <= 9'b101000001;
            end
				
				3'b001:begin
               boy_x <= 8'h4c;
               boy_y <= 9'h141;
               box1_x <= 8'h1f;
               box1_y <= 9'hc1;
               box2_x <= 8'h1f;
               box2_y <= 9'h101;
               brick1_x <= 8'h3d;
               brick1_y <= 9'hc1;
               brick2_x <= 8'h3d;
               brick2_y <= 9'h101;
               brick3_x <= 8'h3d;
               brick3_y <= 9'h141;
               pos1_x <= 8'h4c;
               pos1_y <= 9'hc1;
               pos2_x <= 8'h4c;
               pos2_y <= 9'h101;
            end
				
				3'b010:begin
               boy_x <= 8'h3d;
               boy_y <= 9'h141;
               box1_x <= 8'h1f;
               box1_y <= 9'h81;
               box2_x <= 8'h1f;
               box2_y <= 9'h101;
               brick1_x <= 8'h3d;
               brick1_y <= 9'h81;
               brick2_x <= 8'h2e;
               brick2_y <= 9'h101;
               brick3_x <= 8'h2e;
               brick3_y <= 9'h141;
               pos1_x <= 8'h3d;
               pos1_y <= 9'hc1;
               pos2_x <= 8'h4c;
               pos2_y <= 9'h141;
            end
				
				3'b011:begin
               boy_x <= 8'h10;
               boy_y <= 9'h141;
               box1_x <= 8'h2e;
               box1_y <= 9'h101;
               box2_x <= 8'h2e;
               box2_y <= 9'h81;
               brick1_x <= 8'h10;
               brick1_y <= 9'h101;
               brick2_x <= 8'h2e;
               brick2_y <= 9'hc1;
               brick3_x <= 8'h3d;
               brick3_y <= 9'hc1;
               pos1_x <= 8'h10;
               pos1_y <= 9'hc1;
               pos2_x <= 8'h4c;
               pos2_y <= 9'hc1;
            end
				
				3'b100:begin
               brick1_x <= 8'b00010000;
               brick1_y <= 9'b011000001;
               brick2_x <= 8'b00111101;
               brick2_y <= 9'b011000001;
               brick3_x <= 8'b00111101;
               brick3_y <= 9'b101000001;
               pos1_x <= 8'b00111101;
               pos1_y <= 9'b010000001;
               pos2_x <= 8'b01001100;
               pos2_y <= 9'b011000001;
               box1_x <= 8'b00011111;
               box1_y <= 9'b011000001;
               box2_x <= 8'b00011111;
               box2_y <= 9'b100000001;
               boy_x <= 8'b00101110;
               boy_y <= 9'b011000001;
            end
				default:begin  
				   boy_x <= 8'h10;
               boy_y <= 9'h141;
               box1_x <= 8'h10;
               box1_y <= 9'hc1;
               box2_x <= 8'h4c;
               box2_y <= 9'hc1;
               brick1_x <= 8'h10;
               brick1_y <= 9'h101;
               brick2_x <= 8'h2e;
               brick2_y <= 9'hc1;
               brick3_x <= 8'h3d;
               brick3_y <= 9'hc1;
               pos1_x <= 8'h10;
               pos1_y <= 9'hc1;
               pos2_x <= 8'h4c;
               pos2_y <= 9'hc1;;end
				endcase 
	
            else
            begin
               
               life_sign <= 1'b0;
            end
         end
         
         else if ((box1_x == pos1_x & box1_y == pos1_y & box2_x == pos2_x & box2_y == pos2_y) | (box2_x == pos1_x & box2_y == pos1_y & box1_x == pos2_x & box1_y == pos2_y))
         begin
            if (win_sign == 1'b0 && win_num <= 4 && data_ready == 1'b1 && data_in==8'h5A ) begin
               win_sign <= 1'b0;
					win_num <= win_num + 1;
					end
				else if(win_sign == 1'b0 && win_num > 4 )begin//finish
				    win_sign <= 1'b1;
					 win_num <= 0;
				end
            else
               life_sign <= 1'b0;
         end
         
         else if (life_sign == 1'b1)//boy is alive
         begin
            
            if (data_ready == 1'b1)
               case (data_in)
                  8'h6B :
                     if (boy_x == box1_x + 15 & boy_y == box1_y)
                     begin
                        if ((box1_x == box2_x + 15 & box1_y == box2_y) | (box1_x == brick1_x + 15 & box1_y == brick1_y) | (box1_x == brick2_x + 15 & box1_y == brick2_y) | (box1_x == brick3_x + 15 & box1_y == brick3_y) | box1_x == 16)
                           boy_x <= boy_x + 0;
                        else
                        begin
                           box1_x <= box1_x - 15;
                           boy_x <= boy_x - 15;
                        end
                     end
                     else if (boy_x == box2_x + 15 & boy_y == box2_y)
                     begin
                        if ((box2_x == box1_x + 15 & box2_y == box1_y) | (box2_x == brick1_x + 15 & box2_y == brick1_y) | (box2_x == brick2_x + 15 & box2_y == brick2_y) | (box2_x == brick3_x + 15 & box2_y == brick3_y) | box2_x == 16)
                           boy_x <= boy_x - 0;
                        else
                        begin
                           box2_x <= box2_x - 15;
                           boy_x <= boy_x - 15;
                        end
                     end
                     else if (boy_x == 16 | (boy_x == brick1_x + 15 & boy_y == brick1_y) | (boy_x == brick2_x + 15 & boy_y == brick2_y) | (boy_x == brick3_x + 15 & boy_y == brick3_y))
                        boy_x <= boy_x - 0;
                     else
                        boy_x <= boy_x - 15;
                  
                  8'h74 :
                     if (boy_x == box1_x - 15 & boy_y == box1_y)
                     begin
                        if ((box1_x == box2_x - 15 & box1_y == box2_y) | (box1_x == brick1_x - 15 & box1_y == brick1_y) | (box1_x == brick2_x - 15 & box1_y == brick2_y) | (box1_x == brick3_x - 15 & box1_y == brick3_y) | box1_x == 76)
                           boy_x <= boy_x + 0;
                        else
                        begin
                           box1_x <= box1_x + 15;
                           boy_x <= boy_x + 15;
                        end
                     end
                     else if (boy_x == box2_x - 15 & boy_y == box2_y)
                     begin
                        if ((box2_x == box1_x - 15 & box2_y == box1_y) | (box2_x == brick1_x - 15 & box2_y == brick1_y) | (box2_x == brick2_x - 15 & box2_y == brick2_y) | (box2_x == brick3_x - 15 & box2_y == brick3_y) | box2_x == 76)
                           boy_x <= boy_x - 0;
                        else
                        begin
                           box2_x <= box2_x + 15;
                           boy_x <= boy_x + 15;
                        end
                     end
                     else if (boy_x == 76 | (boy_x == brick1_x - 15 & boy_y == brick1_y) | (boy_x == brick2_x - 15 & boy_y == brick2_y) | (boy_x == brick3_x - 15 & boy_y == brick3_y))
                        boy_x <= boy_x - 0;
                     else
                        boy_x <= boy_x + 15;
                  
                  8'h75 :
                     if (boy_y == box1_y + 64 & boy_x == box1_x)
                     begin
                        if ((box1_y == box2_y + 64 & box1_x == box2_x) | (box1_y == brick1_y + 64 & box1_x == brick1_x) | (box1_y == brick2_y + 64 & box1_x == brick2_x) | (box1_y == brick3_y + 64 & box1_x == brick3_x) | box1_y == 65)
                           boy_y <= boy_y + 0;
                        else
                        begin
                           box1_y <= box1_y - 64;
                           boy_y <= boy_y - 64;
                        end
                     end
                     else if (boy_y == box2_y + 64 & boy_x == box2_x)
                     begin
                        if ((box2_y == box1_y + 64 & box2_x == box1_x) | (box2_y == brick1_y + 64 & box2_x == brick1_x) | (box2_y == brick2_y + 64 & box2_x == brick2_x) | (box2_y == brick3_y + 64 & box2_x == brick3_x) | box2_y == 65)
                           boy_y <= boy_y - 0;
                        else
                        begin
                           box2_y <= box2_y - 64;
                           boy_y <= boy_y - 64;
                        end
                     end
                     else if (boy_y == 65 | (boy_y == brick1_y + 64 & boy_x == brick1_x) | (boy_y == brick2_y + 64 & boy_x == brick2_x) | (boy_y == brick3_y + 64 & boy_x == brick3_x))
                        boy_y <= boy_y - 0;
                     else
                        boy_y <= boy_y - 64;
                  
                  8'h72 :
                     if (boy_y == box1_y - 64 & boy_x == box1_x)
                     begin
                        if ((box1_y == box2_y - 64 & box1_x == box2_x) | (box1_y == brick1_y - 64 & box1_x == brick1_x) | (box1_y == brick2_y - 64 & box1_x == brick2_x) | (box1_y == brick3_y - 64 & box1_x == brick3_x) | box1_y == 321)
                           boy_y <= boy_y + 0;
                        else
                        begin
                           box1_y <= box1_y + 64;
                           boy_y <= boy_y + 64;
                        end
                     end
                     else if (boy_y == box2_y - 64 & boy_x == box2_x)
                     begin
                        if ((box2_y == box1_y - 64 & box2_x == box1_x) | (box2_y == brick1_y - 64 & box2_x == brick1_x) | (box2_y == brick2_y - 64 & box2_x == brick2_x) | (box2_y == brick3_y - 64 & box2_x == brick3_x) | box2_y == 321)
                           boy_y <= boy_y - 0;
                        else
                        begin
                           box2_y <= box2_y + 64;
                           boy_y <= boy_y + 64;
                        end
                     end
                     else if (boy_y == 321 | (boy_y == brick1_y - 64 & boy_x == brick1_x) | (boy_y == brick2_y - 64 & boy_x == brick2_x) | (boy_y == brick3_y - 64 & boy_x == brick3_x))
                        boy_y <= boy_y - 0;
                     else
                        boy_y <= boy_y + 64;
                  default :
                     ;
               endcase
         end
      end
   
endmodule




module keyboard(kb_data, kb_clk, clk, reset, data, data_ready);
   input            kb_data;
   input            kb_clk;
   input            clk;
   input            reset;
   output [7:0]     data;
   reg [7:0]        data;
   output           data_ready;
   
   
   reg [9:0]        master;
   reg [9:0]        slave;
   reg              clk_in;
   
   parameter [1:0]  status_s0 = 0,
                    status_makecode = 1;
   reg [1:0]        state;
   
   reg [3:0]        counter;
   reg              data_in;
   reg              data_in_delay;
   
   
   always @(posedge clk or negedge reset)
      if (reset == 1'b0)
         clk_in <= 1'b0;
      else 
         clk_in <= kb_clk;
   
   
   always @(negedge clk_in or negedge reset)
   begin: masterp
      if (reset == 1'b0)
         master <= 10'b0000000000;
      else 
         master <= {kb_data, slave[9:1]};
   end
   
   
   always @(negedge reset or posedge clk_in)
   begin: slavep
      if (reset == 1'b0)
         slave <= 10'b0000000000;
      else 
         slave <= master;
   end
   
   
   always @(negedge reset or negedge clk_in)
   begin: xhdl0
      reg [3:0]        counter_in;
      if (reset == 1'b0)
         counter_in = 0;
      else 
      begin
         if (master[9:2] == 8'hF0)
            counter_in = 10;
         else if (counter_in == 11)
            counter_in = 1;
         else
            counter_in = counter_in + 1;
      end
      counter <= counter_in;
   end
   
   
   always @(posedge clk_in or negedge reset)
      if (reset == 1'b0)
      begin
         state <= status_makecode;
         data <= 8'b00000000;
         data_in <= 1'b0;
      end
      else 
      begin
         if (counter == 10)
            case (state)
               status_makecode :
                  if (master[8:1] == 8'hF0)
                     state <= status_s0;
                  else
                  begin
                     data <= master[8:1];
                     data_in <= 1'b1;
                  end
               status_s0 :
                  state <= status_makecode;
            endcase
         else
            data_in <= 1'b0;
      end
   
   assign data_ready = data_in & ((~data_in_delay));
   
   always @(posedge clk or negedge reset)
      if (reset == 1'b0)
         data_in_delay <= 1'b0;
      else 
         data_in_delay <= data_in;
   
endmodule

module cnt6(Q, CLK, ACLR);
   output [2:0] Q;
   input        CLK;
   input        ACLR;
   
   reg [2:0]    count;
   wire         reset;
   wire         clk_in;
   
   assign Q = count;
   assign reset = ACLR;
   assign clk_in = CLK;
   
   
   always @(posedge clk_in or posedge reset )
      if (reset == 1'b1)
         count <= {3{1'b0}};
      else 
      begin
         if (count == 3'b101)
            count <= 3'b000;
         else
            count <= count + 1;
      end
   
endmodule


module cnt10(Q, CLK, ACLR);
   output [3:0] Q;
   input        CLK;
   input        ACLR;
   
   reg [3:0]    count;
   wire         reset;
   wire         clk_in;
   
   assign Q = count;
   assign reset = ACLR;
   assign clk_in = CLK;
   
   
   always @(posedge clk_in or posedge reset )
      if (reset == 1'b1)
         count <= {4{1'b0}};
      else 
      begin
         if (count == 4'b1001)
            count <= 4'b0000;
         else
            count <= count + 1;
      end
   
endmodule
