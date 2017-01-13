module lab5p2(SW,CLOCK_50,HEX0);
input [1:0]SW;
input CLOCK_50;
output [6:0]HEX0;
wire enable;
wire [3:0]h;
reg [27:0]count1;
reg [3:0]count2;                                                                      
wire [1:0]speed;
reg enable1;

assign speed={SW[1],SW[0]};
//count1
always@(posedge CLOCK_50)
begin 
if(enable)
count1<=28'd0;
else 
count1<=count1+1'b1;
end
 


always@(speed)
begin
case(speed[1:0])
2'b00:enable1=1'b1;
2'b01:enable1=(count1==28'd50000000)?1'b1:1'b0;
2'b10:enable1=(count1==28'd100000000)?1'b1:1'b0;
2'b11:enable1=(count1==28'd200000000)?1'b1:1'b0;
endcase
end

assign enable=enable1;


//count2
always@(posedge CLOCK_50)
begin
if(enable)
count2<=count2+1'b1;
end

assign h=count2;
HEX h0(
.c3(h[3]),
.c2(h[2]),
.c1(h[1]),
.c0(h[0]),
.out(HEX0)
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
