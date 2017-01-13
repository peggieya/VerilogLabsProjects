`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module lab2(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;
    
	 mux4to1 u(
	     .u(SW[0]),
		  .v(SW[1]),
		  .w(SW[2]),
		  .x(SW[3]),
		  .s(SW[9:8]),
		  .out(LEDR[0])
		  );
endmodule

module mux4to1(u,v,w,x,s,out);
    input u,v,w,x;
	 input [1:0]s;
	 output out;
	 wire conn1,conn2;
	 mux2to1 u0(
        .x(u),
        .y(v),
        .s(s[0]),
        .m(conn1)
        );
    mux2to1 u1(
        .x(w),
        .y(x),
        .s(s[0]),
        .m(conn2)
        );

    mux2to1 u2(
        .x(conn1),
        .y(conn2),
        .s(s[1]),
        .m(out)
        );
endmodule 	 
	 
module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    //assign m = s & y | ~s & x;
    // OR
    assign m = s ? y : x;

endmodule