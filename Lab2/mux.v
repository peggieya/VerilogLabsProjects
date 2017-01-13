`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux4to1(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;
    wire conn1,conn2;
    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .m(conn1)
        );
    mux2to1 u1(
        .x(SW[2]),
        .y(SW[3]),
        .s(SW[9]),
        .m(conn2)
        );

    mux2to1 u2(
        .x(conn1),
        .y(conn2),
        .s(SW[8]),
        .m(LEDR[0])
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
