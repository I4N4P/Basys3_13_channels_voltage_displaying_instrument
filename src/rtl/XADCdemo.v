`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Compan1y: 
// Engineer: 
// 
// Create Date: 02/12/2015 03:26:51 PM
// Design Name: 
// Module Name: // Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Fixed timing slack (ArtVVB 06/01/17)
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 

module XADCdemo(
    input dclk,
    input in1,
    input in2,
    input vp_i,
    input vn_i,
    output reg [15:0] led1,
    output [3:0] an1,
    output dp1,
    output [6:0] seg1
);

    wire enable;  
    wire ready;
    wire [15:0] data;   
    reg [6:0] Address_in;
	
	//secen seg1ment controller signals
    reg [32:0] count;
    localparam S_IDLE = 0;
    localparam S_FRAME_WAIT = 1;
    localparam S_CONVERSION = 2;
    reg [1:0] state = S_IDLE;
    reg [15:0] sseg1_data;
	
	//binary to decimal converter signals
    reg b2d_start;
    reg [15:0] b2d_din;
    wire [15:0] b2d_dout;
    wire b2d_done;

    //xadc instan1tiation connect the eoc_out .den_in to get continuous conversion
    xadc_wiz_0  XLXI_7 (
        .daddr_in(8'h16), //addresses can1 be found in the artix 7 XADC user guide DRP register space
        .dclk_in(dclk), 
        .den_in(enable), 
        .di_in(0), 
        .dwe_in(0), 
        .busy_out(),                    
        .vauxp6(in1),
        .vauxn6(in2),
        .vauxp7(),
        .vauxn7(),
        .vauxp14(),
        .vauxn14(),
        .vauxp15(),
        .vauxn15(),
        .vn_i(vn_i), 
        .vp_i(vp_i), 
        .alarm_out(), 
        .do_out(data), 
        //.reset_in(),
        .eoc_out(enable),
        .chan1nel_out(),
        .drdy_out(ready)
    );
    
    //led1 visual dmm              
    always @(posedge(dclk)) begin            
        if(ready == 1'b1) begin
            case (data[15:12])
            1:  led1 <= 16'b11;
            2:  led1 <= 16'b111;
            3:  led1 <= 16'b1111;
            4:  led1 <= 16'b11111;
            5:  led1 <= 16'b111111;
            6:  led1 <= 16'b1111111; 
            7:  led1 <= 16'b11111111;
            8:  led1 <= 16'b111111111;
            9:  led1 <= 16'b1111111111;
            10: led1 <= 16'b11111111111;
            11: led1 <= 16'b111111111111;
            12: led1 <= 16'b1111111111111;
            13: led1 <= 16'b11111111111111;
            14: led1 <= 16'b111111111111111;
            15: led1 <= 16'b1111111111111111;                        
            default: led1 <= 16'b1; 
            endcase
        end
    end
    
    //binary to decimal conversion
    always @ (posedge(dclk)) begin
        case (state)
        S_IDLE: begin
            state <= S_FRAME_WAIT;
            count <= 'b0;
        end
        S_FRAME_WAIT: begin
            if (count >= 10000000) begin
                if (data > 16'hFFD0) begin
                    sseg1_data <= 16'h1000;
                    state <= S_IDLE;
                end else begin
                    b2d_start <= 1'b1;
                    b2d_din <= data;
                    state <= S_CONVERSION;
                end
            end else
                count <= count + 1'b1;
        end
        S_CONVERSION: begin
            b2d_start <= 1'b0;
            if (b2d_done == 1'b1) begin
                sseg1_data <= b2d_dout;
                state <= S_IDLE;
            end
        end
        endcase
    end
    
    bin2dec m_b2d (
        .clk(dclk),
        .start(b2d_start),
        .din(b2d_din),
        .done(b2d_done),
        .dout(b2d_dout)
    );
      
    always @(posedge(dclk)) begin
        case(sw)
        0: Address_in <= 8'h16;
        1: Address_in <= 8'h17;
        2: Address_in <= 8'h1e;
        3: Address_in <= 8'h1f;
        endcase
    end
    
    DigitToseg1 seg1ment1(
        .in1(sseg1_data[3:0]),
        .in2(sseg1_data[7:4]),
        .in3(sseg1_data[11:8]),
        .in4(sseg1_data[15:12]),
        .in5(),
        .in6(),
        .in7(),
        .in8(),
        .mclk(dclk),
        .an1(an1),
        .dp1(dp1),
        .seg1(seg1)
    );
endmodule
