// File: bcd2ascii1_4.v
// This module translate bcd word into ascii code .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1ns / 1ps
// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module bcdword2ascii1_16
        (
        input  wire        clk,
        input  wire        rst,

        input   wire [15:0] bcd_word,
        output  wire [31:0] ascii_word
        );

        bcd2ascii1_4 bcd2ascii1_4_1
            (
            .clk(clk),
            .rst(rst),

            .bcd(bcd_word[3:0]),
            .ascii(ascii_word[7:0])
            );

        bcd2ascii1_4 bcd2ascii1_4_2
            (
            .clk(clk),
            .rst(rst),

            .bcd(bcd_word[7:4]),
            .ascii(ascii_word[15:8])
            );
            
        bcd2ascii1_4 bcd2ascii1_4_3
            (
            .clk(clk),
            .rst(rst),

            .bcd(bcd_word[11:8]),
            .ascii(ascii_word[23:16])
            );
        bcd2ascii1_4 bcd2ascii1_4_4
            (
            .clk(clk),
            .rst(rst),

            .bcd(bcd_word[15:12]),
            .ascii(ascii_word[31:24])
            );
    
        
endmodule
