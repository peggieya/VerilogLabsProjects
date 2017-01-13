`timescale 1ns / 1ns

module hexdecoder(s0,s1,s2,s3,h0,h1,h2,h3,h4,h5,h6);
	input s0;
	input s1;
	input s2;
	input s3;
	output h0,h1,h2,h3,h4,h5,h6;
	assign h0=!((s3|s2|s1|~s0)&(s3|~s2|s1|s0)&(~s3|s2|~s1|~s0)&(~s3|~s2|s1|~s0));
	assign h1=!(((s3|~s2|s1)|~s0)&(s3|~s2|~s1|s0)&(~s3|s2|~s1|~s0)&(~s3|~s2|s1|s0)&(~s3|~s2|~s1|s0)&(~s3|~s2|~s1|~s0));
	assign h2=!((s3|s2|~s1|s0)&(~s3|~s2|s1|s0)&(~s3|~s2|~s1|s0)&(~s3|~s2|~s1|~s0));
	assign h3=!((s3|s2|s1|~s0)&(s3|~s2|s1|s0)&(s3|~s2|~s1|~s0)&(~s3|s2|s1|~s0)&(~s3|s2|~s1|s0)&(~s3|~s2|~s1|~s0));
	assign h4=!((s3|s2|s1|~s0)&(s3|s2|~s1|~s0)&(s3|~s2|s1|s0)&(s3|~s2|s1|~s0)&(s3|~s2|~s1|~s0)&(~s3|s2|s1|~s0));
	assign h5=!((s3|s2|s1|~s0)&(s3|s2|~s1|s0)&(s3|s2|~s1|~s0)&(s3|~s2|~s1|~s0)&(~s3|~s2|s1|~s0));
	assign h6=!((s3|s2|s1|s0)&(s3|s2|s1|~s0)&(s3|~s2|~s1|~s0)&(~s3|~s2|s1|s0));
endmodule

module mux2to1(x, y, s, m);
    input x; 
    input y; 
    input s; 
    output m; 
    assign m = s ? y : x;
endmodule

module adder(ci,a,b,s,c0);
	input ci,a,b;
	output s,c0;
	assign s=(a^b)^ci;
	mux2to1 m1(.x(b),
           .y(ci),
			  .s(a^b),
			  .m(c0)
			  );
endmodule

module FullAdder(s0,s1,s2,s3,s4,s5,s6,s7,s8,L0,L1,L2,L3,L9);
	input s0,s1,s2,s3,s4,s4,s5,s6,s7,s8;
	output L0,L1,L2,L3,L9; 
	wire conn1,conn2,conn3;
	adder adder1(.ci(s8),
        .a(s0),
		  .b(s1),
		  .s(L0),
		  .c0(conn1)
		  );
	adder adder2(.ci(conn1),
        .a(s2),
		  .b(s3),
		  .s(L1),
		  .c0(conn2)
		  );		  
	adder adder3(.ci(conn2),
        .a(s4),
		  .b(s5),
		  .s(L2),
		  .c0(conn3)
		  );		  
	adder adder4(.ci(conn3),
        .a(s6),
		  .b(s7),
		  .s(L3),
		  .c0(L9)
		  );	  
endmodule

module ORandXOR(a,b,out);
	input [3:0] a,b;
	output [7:0] out;
	assign out = {a^b,a|b};
endmodule

module Case3(a,b,w1);
	input [3:0] a,b;
	output w1;
	assign w1=|{a,b};
endmodule

module Case4(a,b, w2);
	input [3:0] a,b;
	output w2;
	assign w2=&{a,b};
endmodule

module Case5(a,b,out);
	input [3:0] a,b;
	output [7:0] out;
	assign out = {~a,b};
endmodule







module lastp2(SW,LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
   wire Clock;
	wire [7:0]d;//register input
	reg [7:0]q;//register output
	wire Reset_b;
	wire [3:0] A;
	wire [3:0] B;
	wire [2:0] muxSelect;
	wire [4:0] w1,w2;
	
	input [9:0] SW;
	input [3:0] KEY;
   
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	assign A = SW[3:0];//A is Data
   assign Clock = KEY[0];
	assign Reset_b = SW[9];
	assign LEDR = q;
	assign muxSelect = KEY[3:1];
	
	reg [7:0] ALUout;
	wire [7:0] ALUout1, ALUout2, ALUout3, ALUout4, ALUout5,ALUout6, ALUout7, ALUout8;
	assign d = ALUout;
	assign B = 	q[3:0];
	
	hexdecoder H0(.s0(SW[0]),
	              .s1(SW[1]),
	              .s2(SW[2]),
	              .s3(SW[3]),
	              .h0(HEX0[0]),
	              .h1(HEX0[1]),
	              .h2(HEX0[2]),
	              .h3(HEX0[3]),
	              .h4(HEX0[4]),
	              .h5(HEX0[5]),
	              .h6(HEX0[6])
					  );
					  
	hexdecoder H1(.s0(0),
	              .s1(0),
	              .s2(0),
	              .s3(0),
	              .h0(HEX1[0]),
	              .h1(HEX1[1]),
	              .h2(HEX1[2]),
	              .h3(HEX1[3]),
	              .h4(HEX1[4]),
	              .h5(HEX1[5]),
	              .h6(HEX1[6])
					  );
	
	hexdecoder H2(.s0(0),
	              .s1(0),
	              .s2(0),
	              .s3(0),
	              .h0(HEX2[0]),
	              .h1(HEX2[1]),
	              .h2(HEX2[2]),
	              .h3(HEX2[3]),
	              .h4(HEX2[4]),
	              .h5(HEX2[5]),
	              .h6(HEX2[6])
					  );
					  
	hexdecoder H3(.s0(0),
	              .s1(0),
	              .s2(0),
	              .s3(0),
	              .h0(HEX3[0]),
	              .h1(HEX3[1]),
	              .h2(HEX3[2]),
	              .h3(HEX3[3]),
	              .h4(HEX3[4]),
	              .h5(HEX3[5]),
	              .h6(HEX3[6])
					  );
	
	hexdecoder H4(.s0(q[0]),
	              .s1(q[1]),
	              .s2(q[2]),
	              .s3(q[3]),
	              .h0(HEX4[0]),
	              .h1(HEX4[1]),
	              .h2(HEX4[2]),
	              .h3(HEX4[3]),
	              .h4(HEX4[4]),
	              .h5(HEX4[5]),
	              .h6(HEX4[6])
					  );
					  
	hexdecoder H5(.s0(q[4]),
	              .s1(q[5]),
	              .s2(q[6]),
	              .s3(q[7]),
	              .h0(HEX5[0]),
	              .h1(HEX5[1]),
	              .h2(HEX5[2]),
	              .h3(HEX5[3]),
	              .h4(HEX5[4]),
	              .h5(HEX5[5]),
	              .h6(HEX5[6])
					  );
					  
					  
	Case3 c3(.a(A[3:0]),
				.b(B[3:0]),
				.w1(w1)	
			   );
	Case4 c4(.a(A[3:0]),
				.b(B[3:0]),
				.w2(w2)	
				);
					
					
	/*Case5 c3(.a(SW[3:0]),
				.b(SW[7:4]),
				.out(ALUout5)	
					);*/
					
					
	ORandXOR o1(.a(SW[3:0]),
					.b(SW[7:4]),
					.out(ALUout2[7:0])	
					);
					
					
	FullAdder f1(.s0(A[0]),
					 .s1(A[1]),
					 .s2(A[2]),
					 .s3(A[3]),
					 .s4(B[0]),
					 .s5(B[1]),
					 .s6(B[2]),
					 .s7(B[3]),
					 .L0(ALUout1[0]),
					 .L1(ALUout1[1]),
					 .L2(ALUout1[2]),
					 .L3(ALUout1[3]),
					 .L9(ALUout1[4])
     	        ); 

  always @(posedge Clock)
    begin
		if(Reset_b==1'b0)
			q<=0;
		else
			q<=d;
    end

  always@(*)
  begin
		case(muxSelect)
			3'b000: ALUout = ALUout1;//0 
	
			3'b001: ALUout = A + B;//1
	
			3'b010: ALUout = ALUout2;//2

			3'b011: ALUout = w1 ? 8'b10000001:8'b00000000;//3
	
			3'b100: ALUout = w2 ? 8'b01111110:8'b00000000;//4
		
			3'b101: ALUout = B << A;//5
			
			3'b110: ALUout = A * B;//6
			
			3'b111: ALUout = q;
			
			//3'b101: ALUout = ALUout5;//This option seemed to be canceled in this lab. Line reserved for possible future usage
	
			default ALUout = 8'b11111111;
		endcase
	end
endmodule

	
	