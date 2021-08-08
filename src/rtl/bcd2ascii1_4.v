// File: bcd2ascii1_4.v
// This module translate bcd number into ascii code .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1ns / 1ps
// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module bcd2ascii1_4
        (
        input  wire        clk,
        input  wire        rst,

        input   wire [3:0] bcd,
        output   reg [7:0] ascii
        );

        // signal declaration
        reg [7:0] ascii_nxt;


        // body
        always @(posedge clk) begin
                if(rst) 
                        ascii   <= 8'b0;
                else 
                        ascii   <= ascii_nxt;             
        end

        always @(*) begin
                case (bcd)
                0: ascii_nxt = 8'b0011_0000;
                1: ascii_nxt = 8'b0011_0001;
                2: ascii_nxt = 8'b0011_0010;
                3: ascii_nxt = 8'b0011_0011;
                4: ascii_nxt = 8'b0011_0100;
                5: ascii_nxt = 8'b0011_0101;
                6: ascii_nxt = 8'b0011_0110; 
                7: ascii_nxt = 8'b0011_0111;
                8: ascii_nxt = 8'b0011_1000;
                9: ascii_nxt = 8'b0011_1001;   
                default:ascii_nxt = 8'b0100_0001;
                endcase
        end
endmodule
