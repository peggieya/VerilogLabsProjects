module lab4p22(SW, KEY, HEX0, HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);


input [9:0] SW;
input [3:0] KEY;

output [7:0] LEDR;

output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;

reg [7:0] ALUout;
reg [7:0] ALUreg;

assign  LEDR [7:0] =ALUout;


wire [3:0] A;
wire [3:0] B;


assign A = SW [3:0];


assign HEX1 = 7'b0000000;
assign HEX2 = 7'b0000000;
assign HEX3 = 7'b0000000;


assign B=ALUreg [3:0];


always @ (posedge KEY[0])
begin


if (SW[9]==0)
ALUreg<= 8'b00000000;
else
ALUreg<=ALUout;

end
binary_to_hex a1 (A, HEX0);

binary_to_hex a3 (ALUreg[3:0], HEX4) ;

binary_to_hex a4 (ALUreg [7:4], HEX5) ;

wire [7:0] case0;

wire [7:0] A_and_B;
assign A_and_B = {A,B};
rp_carry_adder adder0(A_and_B, case0);


		
integer A_int;
always @(A)
A_int=A;



always @ (*) 
begin 

case ((KEY[3:1]))

3'b000: 
begin
 ALUout=case0;
 end

3'b001:
begin
ALUout [7:5] =3'b000;
 ALUout [4:0]=A+B;
end
3'b010:
begin
 ALUout[7]=A[3]^B[3] ;
 ALUout[6]=A[2]^B[2] ;
 ALUout[5]= A[1]^B[1];
 ALUout[4]=A[0]^B[0] ;
 ALUout[3]= A[3]|B[3];
 ALUout[2]= A[2]|B[2];
 ALUout[1]= A[1]|B[1];
 ALUout[0]= A[0]|B[0];
 end
3'b011:
begin



if (|(A_and_B))
 ALUout = 8'b10000001;
else 
 ALUout = 8'b00000000;




end


3'b100:
begin


if (&(A_and_B))
 ALUout = 8'b01111110;
else 
 ALUout = 8'b00000000;


end


3'b101:
begin

ALUout = ALUreg << A_int;
end

3'b110:  
begin 

ALUout=A*B;

end

3'b111:
ALUout=ALUreg;


default:
ALUout = 8'b00000000;

endcase

end
endmodule 


module binary_to_hex (SW, HEX0);


input [3:0] SW;
output [6:0] HEX0;

assign HEX0[0] = ~((SW[3] | SW[2] | SW[1] | ~SW[0]) & (~SW[3] | SW[2] | ~SW[1] | ~SW[0]) & (~SW[3] | ~SW[2] | SW[1] | ~SW[0]) && (SW[3] | ~SW[2] | SW[1] | SW[0]));



assign HEX0[1] = ~((SW[3] | ~SW[2] | SW[1] | ~SW[0]) & (SW[3] | ~SW[2] | ~SW[1] | SW[0]) & (~SW[3] | SW[2] | ~SW[1] | ~SW[0])&
						
						(~SW[3] | ~SW[2] | SW[1] | SW[0]) & (~SW[3] | ~SW[2] | ~SW[1] | SW[0]) & (~SW[3] | ~SW[2] | ~SW[1] | ~SW[0]) );
						
						

assign HEX0[2] = ~((SW[3] | SW[2] | ~SW[1] | SW[0]) & (~SW[3] | ~SW[2] | SW[1] | SW[0]) &
		(~SW[3] | ~SW[2] | ~SW[1] | SW[0])   & (~SW[3] | ~SW[2] | ~SW[1] | ~SW[0]));


assign HEX0[3] = ~((SW[3] | SW[2] | SW[1] | ~SW[0]) & (SW[3] | ~SW[2] | SW[1] | SW[0]) & (SW[3] | ~SW[2] | ~SW[1] | ~SW[0]) &

						 & (~SW[3] | SW[2] | ~SW[1] | SW[0]) & (~SW[3] | ~SW[2] | ~SW[1] | ~SW[0]));


						
assign HEX0[4] = ~((SW[3] | SW[2] | SW[1] | ~SW[0]) & (SW[3] | SW[2] | ~SW[1] | ~SW[0]) & (SW[3] | ~SW[2] | SW[1] | SW[0])&
						
						(SW[3] | ~SW[2] | SW[1] | ~SW[0]) & (SW[3] | ~SW[2] | ~SW[1] | ~SW[0]) & (~SW[3] | SW[2] | SW[1] | ~SW[0]));
						

assign HEX0[5] = ~((SW[3] | SW[2] | SW[1] | ~SW[0]) & (SW[3] | SW[2] | ~SW[1] | SW[0]) & (SW[3] | SW[2] | ~SW[1] | ~SW[0])&
						
						(SW[3] | ~SW[2] | ~SW[1] | ~SW[0]) & (~SW[3] | ~SW[2] | SW[1] | ~SW[0]) );
						
assign HEX0[6] = ~((SW[3] | SW[2] | SW[1] | SW[0]) & (SW[3] | SW[2] | SW[1] | ~SW[0]) & (SW[3] | ~SW[2] | ~SW[1] | ~SW[0])&

						(~SW[3] | ~SW[2] | SW[1] | SW[0]) );
						
						endmodule
						

						//this code is a ripple carry adder


module rp_carry_adder(SW, LEDR);

input [7:0] SW;

output [7:0] LEDR;

//assign SW[8] = 0'b0

wire [3:0] carry;

fa x0 (SW[4], SW[0], 1'b0, carry[0], LEDR[0]);

fa x1 (SW[5], SW[1], carry[0], carry[1], LEDR[1]);

fa x2 (SW[6], SW[2], carry[1], carry[2], LEDR[2]);

fa x3 (SW[7], SW[3], carry[2], carry[3], LEDR[3]);

assign LEDR[4] = carry[3];
assign LEDR [7:5] = 3'b000;

endmodule







module fa (a,b,cin,cout,si);

input a, b, cin;

output cout, si;

assign si= cin ^ a ^ b;

assign cout= a&cin | a&b| b&cin ;

endmodule

