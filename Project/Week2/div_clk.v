//`define SIM
module div_clk(clk,rst,clk1khz,clk100hz,clk1mhz);
`ifndef SIM  //for FPGA DE2
        localparam count1_num = 24;
        localparam count2_num = 499;
        localparam count3_num = 9;
`else        //just for simulation
		    localparam count1_num = 0;
        localparam count2_num = 0;
        localparam count3_num = 0;
`endif
//**********************************************************/		
//******************input & output**************************/
//**********************************************************/
input clk,rst;
output reg clk100hz;
output reg clk1khz;
output reg clk1mhz;
//**********************************************************/		
//******************difine wire and interface  *************/
//**********************************************************/	
integer count1,count2,count3;

//**********************************************************/		
//******************main  code   **************************/
//**********************************************************/

//50mhz to 1mhz
always @(posedge clk or negedge rst)
begin
  if (!rst)
    begin
    count1 <=0;
    clk1mhz<=0;
    end
  else if (count1 == count1_num)  
    begin
    count1 <= 0;
    clk1mhz<=~clk1mhz;
    end
  else
    count1 <= count1 +1; 
end
//1mhz to 1khz 
always @(posedge clk1mhz or negedge rst)
begin
  if (!rst)
    begin
    count2 <= 0;
    clk1khz <= 0;
    end

    else if (count2 == count2_num)    
    begin
    count2 <= 0;
    clk1khz <= ~clk1khz;
    end
  else
    count2 <= count2 +1; 
end
// 1khz to 1hz
always @(posedge clk1khz or negedge rst)
begin
  if (!rst)
    begin
    count3 <= 0;
    clk100hz <= 0;
    end

    else if (count3 == count3_num)  
    begin
    count3 <= 0;
    clk100hz <= ~clk100hz;
    end
  else
    count3 <= count3 +1; 
end


    
     
endmodule

