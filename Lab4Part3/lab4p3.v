module lab4p3(SW,KEY,LEDR);

input [9:0]SW;

input [3:0]KEY;

output [7:0]LEDR;

wire [7:0]w1;

wire [7:0]q1;

wire [7:0]q2;

rotate u1(.DATA_IN(SW[7:0]),.ParallelLoadn(KEY[1]),.RotateRight(KEY[2]),.ASRight(KEY[3]),.clock(KEY[0]),.reset(SW[9]),.Q(q1));


ASrotate u2(.DATA_IN(SW[7:0]),.ParallelLoadn(KEY[1]),.RotateRight(KEY[2]),.ASRight(KEY[3]),.clock(KEY[0]),.reset(SW[9]),.Q(q2));


mux2to1 u3(.x(q1[7:0]),

.y(q2[7:0]),

.s(KEY[3]),

.m(w1[7:0])

);


mux2to1 u4(.x(q1[7:0]),

.y(w1[7:0]),

.s(KEY[2]),

.m(LEDR)

);


endmodule


module rotate(DATA_IN,ParallelLoadn,RotateRight,ASRight,clock,reset,Q);

input ParallelLoadn, RotateRight, ASRight, clock,reset;

input [7:0]DATA_IN;

output [7:0]Q;

subcir u7(.right(Q[6]),.left(Q[0]),.loadleft(RotateRight),.D(DATA_IN[7]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[7]));

subcir u6(.right(Q[5]),.left(Q[7]),.loadleft(RotateRight),.D(DATA_IN[6]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[6]));

subcir u5(.right(Q[4]),.left(Q[6]),.loadleft(RotateRight),.D(DATA_IN[5]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[5]));

subcir u4(.right(Q[3]),.left(Q[5]),.loadleft(RotateRight),.D(DATA_IN[4]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[4]));

subcir u3(.right(Q[2]),.left(Q[4]),.loadleft(RotateRight),.D(DATA_IN[3]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[3]));

subcir u2(.right(Q[1]),.left(Q[3]),.loadleft(RotateRight),.D(DATA_IN[2]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[2]));

subcir u1(.right(Q[0]),.left(Q[2]),.loadleft(RotateRight),.D(DATA_IN[1]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[1]));

subcir u0(.right(Q[7]),.left(Q[1]),.loadleft(RotateRight),.D(DATA_IN[0]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[0]));

endmodule


module ASrotate(DATA_IN,ParallelLoadn,RotateRight,ASRight,clock,reset,Q);

input ParallelLoadn, RotateRight, ASRight, clock,reset;

input [7:0]DATA_IN;

output [7:0]Q;

subcir u7(.right(Q[6]),.left(Q[7]),.loadleft(RotateRight),.D(DATA_IN[7]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[7]));

subcir u6(.right(Q[5]),.left(Q[7]),.loadleft(RotateRight),.D(DATA_IN[6]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[6]));

subcir u5(.right(Q[4]),.left(Q[6]),.loadleft(RotateRight),.D(DATA_IN[5]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[5]));

subcir u4(.right(Q[3]),.left(Q[5]),.loadleft(RotateRight),.D(DATA_IN[4]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[4]));

subcir u3(.right(Q[2]),.left(Q[4]),.loadleft(RotateRight),.D(DATA_IN[3]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[3]));

subcir u2(.right(Q[1]),.left(Q[3]),.loadleft(RotateRight),.D(DATA_IN[2]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[2]));

subcir u1(.right(Q[0]),.left(Q[2]),.loadleft(RotateRight),.D(DATA_IN[1]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[1]));

subcir u0(.right(Q[7]),.left(Q[1]),.loadleft(RotateRight),.D(DATA_IN[0]),.loadn(ParallelLoadn),.clock(clock),.reset(reset),.Q(Q[0]));

endmodule 



module mux2to1(x,y,s,m);

input x,y,s;

output m;

assign m=(~s&x)|(s&y);

endmodule




module myDFF(input d,ck,resetn,output reg q);

always@(posedge ck)

if(!resetn)

q<=0;

else

q<=d;

endmodule


module subcir(right,left,loadleft,D,loadn,clock,reset,Q);

input right,left;

input loadleft,D,loadn,clock,reset;

output Q;

wire w1,w2;


mux2to1 u0(.x(right),

.y(left),

.s(loadleft),

.m(w1)

);

mux2to1 u1(.x(D),

.y(w1),

.s(loadn),

.m(w2)

);


myDFF u(w2,clock,reset,Q);

endmodule

