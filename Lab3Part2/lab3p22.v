
module lab3p22(SW,LEDR);

input [9:0]SW;

output [9:0]LEDR;

wire c1,c2,c3;

FA b0(

.a(SW[4]),

.b(SW[0]),

.cin(SW[8]),

.cout(c1),

.s(LEDR[0])

);

FA b1(

.a(SW[5]),

.b(SW[1]),

.cin(c1),

.cout(c2),

.s(LEDR[1])

);

FA b2(

.a(SW[6]),

.b(SW[2]),

.cin(c2),

.cout(c3),

.s(LEDR[2])

);

FA b3(

.a(SW[7]),

.b(SW[3]),

.cin(c3),

.cout(LEDR[9]),

.s(LEDR[3])

);

endmodule

module FA(a,b,cin,cout,s);

input a,b,cin;

output s, cout;

assign s = a^b^cin;

assign cout = a&b|a&cin|b&cin;



endmodule
