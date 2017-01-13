module lab5p1(SW,HEX0,HEX1,KEY);
input [1:0]SW;
input [3:0]KEY;
output [6:0] HEX0;
output [6:0] HEX1;
wire [7:0]outQ;
counter u0(SW[1],SW[0],KEY[0],outQ);
HEX A0(
.c3(outQ[7]),
.c2(outQ[6]),
.c1(outQ[5]),
.c0(outQ[4]),
.out(HEX1)
);
HEX A1(
.c3(outQ[3]),
.c2(outQ[2]),
.c1(outQ[1]),
.c0(outQ[0]),
.out(HEX0)
);
endmodule

module counter(e,reset,ck,q);
input e,reset,ck;
output[7:0]q;
wire[6:0]temp;
assign temp[0]=q[0]&e;
assign temp[1]=q[1]&temp[0];
assign temp[2]=q[2]&temp[1];
assign temp[3]=q[3]&temp[2];
assign temp[4]=q[4]&temp[3];
assign temp[5]=q[5]&temp[4];
assign temp[6]=q[6]&temp[5];

Ttype u0(.Enable(e),.clear(reset),.clock(ck),.Q(q[0]));
Ttype u1(.Enable(temp[0]),.clear(reset),.clock(ck),.Q(q[1]));

Ttype u2(.Enable(temp[1]),.clear(reset),.clock(ck),.Q(q[2]));

Ttype u3(.Enable(temp[2]),.clear(reset),.clock(ck),.Q(q[3]));

Ttype u4(.Enable(temp[3]),.clear(reset),.clock(ck),.Q(q[4]));

Ttype u5(.Enable(temp[4]),.clear(reset),.clock(ck),.Q(q[5]));

Ttype u6(.Enable(temp[5]),.clear(reset),.clock(ck),.Q(q[6]));

Ttype u7(.Enable(temp[6]),.clear(reset),.clock(ck),.Q(q[7]));

endmodule



module Ttype(Enable,clear,clock,Q);
input Enable,clear,clock;
output Q;
reg Q;
always@(posedge clock)
if(!clear)
begin
Q<=1'b0;
end
else if(Enable) begin
Q<=Enable^Q;
end

endmodule


module HEX(c3,c2,c1,c0,out);
input c3,c2,c1,c0;
output [6:0]out;
assign out[0]=~((c3|c2|c1|~c0)&(c3|~c2|c1|c0)&(~c3|c2|~c1|~c0)&(~c3|~c2|c1|~c0));
assign out[1]=~((c3|~c2|~c1|c0)&(c3|~c2|c1|~c0)&(~c3|c2|~c1|~c0)&(~c3|~c2|c1|c0)&(~c3|~c2|~c1|c0)&(~c3|~c2|~c1|~c0));
assign out[2]=~((c3|c2|~c1|c0)&(~c3|~c2|c1|c0)&(~c3|~c2|~c1|c0)&(~c3|~c2|~c1|~c0));
assign out[3]=~((c3|c2|c1|~c0)&(c3|~c2|c1|c0)&(c3|~c2|~c1|~c0)&(~c3|c2|c1|~c0)&(~c3|c2|~c1|c0)&(~c3|~c2|~c1|~c0));
assign out[4]=~((c3|c2|c1|~c0)&(c3|c2|~c1|~c0)&(c3|~c2|c1|c0)&(c3|~c2|c1|~c0)&(c3|~c2|~c1|~c0)&(~c3|c2|c1|~c0));
assign out[5]=~((c3|c2|c1|~c0)&(c3|c2|~c1|c0)&(c3|c2|~c1|~c0)&(c3|~c2|~c1|~c0)&(~c3|~c2|c1|~c0));
assign out[6]=~((c3|c2|c1|c0)&(c3|c2|c1|~c0)&(c3|~c2|~c1|~c0)&(~c3|~c2|c1|c0));
endmodule
