module lab3p1(LEDR,SW);

 input [9:0] SW;
 output [9:0]LEDR;
 wire [6:0] Input;
 wire [2:0] MuxSelect;
 
 reg Out;
 assign Input = SW[6:0];
 assign MuxSelect = SW[9:7];
 assign LEDR[0] = Out;

always @(*)
begin
  case(MuxSelect[2:0])
    3'b000: Out = Input[0];
  3'b001: Out = Input[1];
  3'b010: Out = Input[2];
  3'b011: Out = Input[3];
  3'b100: Out = Input[4];
  3'b101: Out = Input[5];
  3'b110: Out = Input[6];
  default: Out = 3'b0000;
 endcase
end 

endmodule
