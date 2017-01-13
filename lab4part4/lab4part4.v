module lab4part4(SW,KEY,LEDR);
input [9:0]SW;
input [3:0]KEY;
output [7:0] LEDR;
rotating_register u0(KEY[0],SW[9],KEY[1],KEY[2],KEY[3],SW[7:0],LEDR[7:0]);

endmodule

module rotating_register(clock,reset,Loadn,Roright,ASright,DATA_IN,Q);
input clock,reset,Loadn,Roright,ASright;
input [7:0]DATA_IN;
output [7:0] Q;
wire [7:0]D;
wire [7:0]outRorL;
wire wforASright;
wire intoShift7;
assign wforASright=Q[7];
	mux asrightmux(wforASright,Q[0],ASright,intoShift7);
	mux shift7(intoShift7,Q[6],Roright,outRorL[7]);
	mux load7(outRorL[7],DATA_IN[7],Loadn,D[7]);
	filp_flop FF7(D[7],Q[7],clock,reset);//No7 subcircuit d
	
	mux shift6(Q[7],Q[5],Roright,outRorL[6]);
	mux load6(outRorL[6],DATA_IN[6],Loadn,D[6]);
	filp_flop FF6(D[6],Q[6],clock,reset);//No6 subcircuit d
	
	mux shift5(Q[6],Q[4],Roright,outRorL[5]);
	mux load5(outRorL[5],DATA_IN[5],Loadn,D[5]);
	filp_flop FF5(D[5],Q[5],clock,reset);//No5 subcircuit
	
	mux shift4(Q[5],Q[3],Roright,outRorL[4]);
	mux load4(outRorL[4],DATA_IN[4],Loadn,D[4]);
	filp_flop FF4(D[4],Q[4],clock,reset);//No4 subcircuit
	
	mux shift3(Q[4],Q[2],Roright,outRorL[3]);
	mux load3(outRorL[3],DATA_IN[3],Loadn,D[3]);
	filp_flop FF3(D[3],Q[3],clock,reset);//No3 subcircuit
	
	mux shift2(Q[3],Q[1],Roright,outRorL[2]);
	mux load2(outRorL[2],DATA_IN[2],Loadn,D[2]);
	filp_flop FF2(D[2],Q[2],clock,reset);//No2 subcircuit
	
	mux shift1(Q[2],Q[0],Roright,outRorL[1]);
	mux load1(outRorL[1],DATA_IN[1],Loadn,D[1]);
	filp_flop FF1(D[1],Q[1],clock,reset);//No1 subcircuit
	
	mux shift0(Q[1],Q[7],Roright,outRorL[0]);
	mux load0(outRorL[0],DATA_IN[0],Loadn,D[0]);
	filp_flop FF0(D[0],Q[0],clock,reset);//No0 subcircuit
	
	
endmodule

module mux(x,y,s,m);
input x,y,s;
output m;
assign m=x&s|~s&y;
endmodule

module filp_flop(d,q,clock,reset);
input d,clock,reset;
output reg q;
always@(posedge clock)
	begin
	if(reset)
		q<=0;
	else
		q<=d;
	end
endmodule
