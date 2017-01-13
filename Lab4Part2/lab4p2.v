

module lab4p2(SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,KEY);

input [9:0] SW;

input [3:0] KEY;

output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;

output [9:0] LEDR;

assign HEX1 = 8'b10000000;

assign HEX2 = 8'b10000000;

assign HEX3 = 8'b10000000;

wire [7:0] D;

reg [7:0] Q=8'b00000001;

 always@(posedge KEY[0])

begin

   if(SW[9] == 1'b0)

    Q<=0;

 else Q<=D;

end

ALUreg m(

.A(SW[3:0]),

.B(Q[3:0]),

.select(KEY[3:1]),

.register(Q),

.ALUout(D),

);

assign LEDR = Q;

HEX h0(

.c3(SW[3]),

.c2(SW[2]),

.c1(SW[1]),

.c0(SW[0]),

.out(HEX0)

);

HEX h4(

.c3(Q[3]),

.c2(Q[2]),

.c1(Q[1]),

.c0(Q[0]),

.out(HEX4)

);

HEX h5(

.c3(Q[7]),

.c2(Q[6]),

.c1(Q[5]),

.c0(Q[4]),

.out(HEX5)

);

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


module FA(a,b,cin,cout,s);

input a,b,cin;

output s, cout;

assign s = a^b^cin;

assign cout = a&b|a&cin|b&cin;

endmodule

module ABadder(a,b,cin,cout,s);

input [3:0]a;

input [3:0]b;

input cin;

output cout;

output [3:0] s;

wire c1,c2,c3;

FA b0(

.a(a[0]),

.b(b[0]),

.cin(cin),

.cout(c1),

.s(s[0])

);

FA b1(

.a(a[1]),

.b(b[1]),

.cin(c1),

.cout(c2),

.s(s[1])

);

FA b2(

.a(a[2]),

.b(b[2]),

.cin(c2),

.cout(c3),

.s(s[2])

);

FA b3(

.a(a[3]),

.b(b[3]),

.cin(c3),

.cout(cout),

.s(s[3])

);

endmodule


module ALUreg(A,B,select,register,ALUout);

input [3:0] A;
input [3:0] B;
input [2:0] select;
input [7:0] register;
output[7:0]ALUout;

wire [3:0] s;

wire cout;

ABadder u(

.a(A),

.b(B),

.cin(0),

.cout(cout),

.s(s)

);

reg [7:0]ALUout;

always @(*)

begin

case(select[2:0])

3'b000: begin

    ALUout [3:0]=s;

    ALUout [4]=cout;

   end

3'b001: ALUout = A+B;

3'b010: ALUout = {A^B,A|B};

3'b011:if(A[0]|A[1]|A[2]|A[3]|B[0]|B[1]|B[2]|B[3] == 1)

   ALUout=8'b10000001;

  else

   ALUout=8'b00000000;

3'b100:if(A[0]&A[1]&A[2]&A[3]&B[0]&B[1]&B[2]&B[3] == 1)

   ALUout=8'b01111110;

  else

   ALUout =8'b00000000;

3'b101:

  begin

   ALUout[7:4] = B[3:0];

   ALUout[3:0] = A[3:0];

  end

3'b110: ALUout = A*B;

3'b111: ALUout =register;

default: ALUout=8'b00000000;

endcase

end



endmodule
