//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         17:00:14 29/08/2021 
// Design Name:         bcd2ascii1_4
// Module Name:         bcd2ascii1_4 
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This module translate bcd number into ascii code.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:         using Verilog-2001 syntax.
//
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
//              
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module bcd2ascii1_4
        (
                input  wire        clk,
                input  wire        rst,

                input   wire [3:0] bcd,
                output   reg [6:0] ascii
        );

        // signal declaration
        reg [6:0] ascii_nxt;
        // body
        always @(posedge clk) begin
                if(rst) 
                        ascii   <= 7'h00;
                else 
                        ascii   <= ascii_nxt;             
        end

        always @(*) begin
                case (bcd)
                0: ascii_nxt = 7'b011_0000;
                1: ascii_nxt = 7'b011_0001;
                2: ascii_nxt = 7'b011_0010;
                3: ascii_nxt = 7'b011_0011;
                4: ascii_nxt = 7'b011_0100;
                5: ascii_nxt = 7'b011_0101;
                6: ascii_nxt = 7'b011_0110; 
                7: ascii_nxt = 7'b011_0111;
                8: ascii_nxt = 7'b011_1000;
                9: ascii_nxt = 7'b011_1001;   
                default:ascii_nxt = 7'b111_1111;
                endcase
        end
endmodule
