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
        output   reg [6:0] ascii
        );

        // signal declaration
        reg [7:0] ascii_nxt;


        // body
        always @(posedge clk) begin
                if(rst) 
                        ascii   <= 7'h00;
                else 
                        ascii   <= ascii_nxt;             
        end

        always @(*) begin
                case (bcd)
                0: ascii_nxt = 7'h30;
                1: ascii_nxt = 7'h31;
                2: ascii_nxt = 7'h32;
                3: ascii_nxt = 7'h33;
                4: ascii_nxt = 7'h34;
                5: ascii_nxt = 7'h35;
                6: ascii_nxt = 7'h36; 
                7: ascii_nxt = 7'h37;
                8: ascii_nxt = 7'h38;
                9: ascii_nxt = 7'h39;   
                default:ascii_nxt = 7'h41;
                endcase
        end
endmodule
