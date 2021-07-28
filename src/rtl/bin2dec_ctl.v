`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Arthur Brown
// 
// Create Date: 03/23/2017
// Module Name: bcd
// Project Name: OLED Demo
// Target Devices: Nexys Video
// Tool Versions: Vivado 2016.4
// Description: converts an input in the range (0x0000-0xFFFF) to a hex string in the range (16'h0000-16'h1000)
//              assert start & din, some amount of time later, done is asserted with valid dout
// Dependencies: none
// 
// 03/23/2017(ArtVVB): Created
//
//////////////////////////////////////////////////////////////////////////////////

module bin2dec_ctl (
    input wire clk,
    input wire b2d_done,
    input wire [15:0] din,
    input wire [15:0] b2d_dout,
    output reg b2d_start,
    output reg [15:0] b2d_din,
    output reg [15:0] dout
);
    localparam S_IDLE = 0;
    localparam S_FRAME_WAIT = 1;
    localparam S_CONVERSION = 2;
    reg [1:0] state = S_IDLE;
    reg [32:0] count;
    
    always @ (posedge clk) begin
        case (state)
        S_IDLE: begin
            state <= S_FRAME_WAIT;
            count <= 'b0;
        end
        S_FRAME_WAIT: begin
            if (count >= 10_000_000) begin
                if (din > 16'hFFD0) begin
                    dout <= 16'h1000;
                    state <= S_IDLE;
                end else begin
                    b2d_start <= 1'b1;
                    b2d_din <= din;
                    state <= S_CONVERSION;
                end
            end else
                count <= count + 1'b1;
        end
        S_CONVERSION: begin
            b2d_start <= 1'b0;
            if (b2d_done == 1'b1) begin
                dout <= b2d_dout;
                state <= S_IDLE;
            end
        end
        endcase
    end
    
endmodule