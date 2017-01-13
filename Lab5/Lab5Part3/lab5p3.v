module lab5p3(SW,KEY,CLOCK_50,LEDR);
input [2:0]SW;
input CLOCK_50;
input [1:0]KEY;
output[0:0]LEDR;
wire [10:0]morse;
wire shift;

counter u2(.ck(CLOCK_50),.enable(shift));
muxM u0(.select(SW),.out(morse));
display u1(.morse_connect(morse),.reset(KEY[0]),.shift(shift),.enable(KEY[1]),.l(LEDR[0]));
endmodule

module counter(ck,enable);
input ck;
output enable;
reg [25:0]count;

always@(posedge ck)
begin
if(enable)
count<=26'd0;
else
count<=count+1'b1;
end
assign enable=(count==26'd25000000)?1'b1:1'b0;
endmodule


module muxM(select,out);
input [2:0]select;
output reg [10:0]out;
always@(*)
begin 
case(select[2:0])
3'b000: out=11'b10111000000; //A
3'b001: out=11'b11101010100; //B
3'b010: out=11'b11101011101; //C
3'b011: out=11'b11101010000; //D
3'b100: out=11'b10000000000; //E
3'b101: out=11'b10101110100; //F
3'b110: out=11'b11101110100; //G
3'b111: out=11'b10101010000; //H
endcase
end
endmodule

module display(morse_connect,reset,shift,enable,l);
input shift;
input reset;
input [10:0]morse_connect;
input enable;
output l;
reg [10:0]morsecode;

always @(posedge shift)
if(!reset)
morsecode<=0;
else if(enable)
morsecode<=morse_connect;
else if(!enable)
morsecode<=morsecode<<1;

assign l=morsecode[10];
endmodule
