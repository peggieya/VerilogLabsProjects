module lab6p3(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1,HEX2,HEX3,HEX4,HEX5);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1,HEX2,HEX3,HEX4,HEX5;

    wire resetn;
    wire go;

    wire [7:0] data_result;
    assign go = ~KEY[1];
    assign resetn = KEY[0];
     wire [3:0] dividend, divisor;

    part3 u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[7:0]),
        .data_result(data_result),
          .dividend(dividend), 
          .divisor(divisor)
    );
      
    assign LEDR[3:0] = data_result[3:0];

    hex_decoder H0(
        .hex_digit(data_result[3:0]), 
        .segments(HEX4)
        );
        
    hex_decoder H1(
        .hex_digit(data_result[7:4]), 
        .segments(HEX5)
        );
     hex_decoder H2(
        .hex_digit(4'b0000), 
        .segments(HEX1)
        );
     hex_decoder H3(
        .hex_digit(4'b0000), 
        .segments(HEX3)
        );
    hex_decoder H4(
        .hex_digit(dividend), 
        .segments(HEX2)
        );
        hex_decoder H5(
        .hex_digit(divisor), 
        .segments(HEX0)
        );  
endmodule

module part3(
    input clk,
    input resetn,
    input go,
    input [7:0] data_in,
    output [7:0] data_result,
     output [3:0] dividend, divisor
    );
    
     wire do,load,ld_r;
    control C0(
        .clk(clk),
        .resetn(resetn),
        .go(go),
          .do(do),
          .load(load),
          .ld_r(ld_r)
    );

    datapath D0(
        .clk(clk),
        .resetn(resetn),
        .data_in(data_in),
        .do(do),
          .load(load),
          .ld_r(ld_r),
        .data_result(data_result),
          .dividend(dividend), 
          .divisor(divisor)
    );
                
 endmodule        
                

module control(
    input clk,
    input resetn,
    input go,
     output reg do, load, ld_r
    );

    reg [4:0] current_state, next_state; 
    
    localparam  hold_state      = 4'd0,
                 load_state      = 4'd1,
                S_CYCLE_0       = 4'd2,
                S_CYCLE_1       = 4'd3,
                S_CYCLE_2       = 4'd4,
                     S_CYCLE_3       = 4'd5,
                     end_state       = 4'd6;
    
    always@(*)
    begin: state_table 
            case (current_state)
                hold_state: next_state = go ? load_state : hold_state;
                     load_state: next_state = go ? load_state : S_CYCLE_0; 
                S_CYCLE_0: next_state = S_CYCLE_1;
                S_CYCLE_1: next_state = S_CYCLE_2;
                     S_CYCLE_2: next_state = S_CYCLE_3;
                     S_CYCLE_3: next_state = end_state;
                     end_state: next_state = hold_state;
            default:     next_state = hold_state;
        endcase
    end 
   
    always @(*)
    begin: enable_signals
        do = 1'b0;
          load = 1'b0;
          ld_r=1'b0;
        case (current_state)
            hold_state:begin
                 do=1'b0;
                    load = 1'b0;
                end
                load_state:begin
                   do =1'b0;
                    load =1'b1;
                end
            S_CYCLE_0: begin 
               do=1'b1;
            end
             S_CYCLE_1: begin  
                do=1'b1;
            end
                 S_CYCLE_2: begin 
                do=1'b1;
            end
                 S_CYCLE_3: begin 
                do=1'b1;
               end
                end_state: begin
                    ld_r=1'b1;
                end
        endcase
    end
   
    
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= hold_state;
        else
            current_state <= next_state;
    end 
endmodule

module datapath(
    input clk,
    input resetn,
    input [7:0] data_in,
    input do, load, ld_r,
    output reg [7:0] data_result,
     output reg [3:0] dividend, divisor
    );
    

    reg [8:0] operation;
     wire [8:0]shiftedoperation;
     wire [4:0]subtraction;
     
     shift s1(operation,shiftedoperation);
    assign subtraction=shiftedoperation[8:4] - divisor;
     
    always@(posedge clk) begin
        if(!resetn) begin
            operation <= 9'b0; 
                dividend=4'b0000;
                divisor=4'b0000;
        end
        else 
            begin
            if (load)
                  begin
                    dividend = data_in[7:4];
                     divisor = data_in[3:0];
                operation = 9'b0 + data_in[7:4];                 
                  end
                if (do)
                  begin
                     if(subtraction[4])
                          operation<=shiftedoperation;
                    else
                          operation={subtraction,shiftedoperation[3:0]+1'b1};
                  end 
        end
    end
    
     wire [7:0]result_out;
     assign result_out=operation[7:0];
     
    always@(posedge clk) begin
        if(!resetn) begin
            data_result <= 8'b0; 
        end
        else 
            if(ld_r)
                data_result <= result_out;
    end
endmodule

module shift(input [8:0]recent, output [8:0]shiftRight);
       assign shiftRight[0]=1'b0;
        assign shiftRight[8:1]=recent[7:0];
endmodule


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule