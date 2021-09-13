//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         17:20:14 29/08/2021 
// Design Name:         bcdword2ascii1_4
// Module Name:         bcdword2ascii1_4 
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This module translate bcd word into ascii code.
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

module bcdword2ascii1_16
        (
                input  wire        clk,
                input  wire        rst,

                input   wire [15:0] bcd_word,
                output  wire [27:0] ascii_word
        );

        wire [3:0] bcd_word_arr [0:3];
        wire [6:0] ascii_word_arr [0:3];

        assign {bcd_word_arr[3],bcd_word_arr[2],bcd_word_arr[1],bcd_word_arr[0]} = bcd_word;
        assign ascii_word = {ascii_word_arr[3],ascii_word_arr[2],ascii_word_arr[1],ascii_word_arr[0]};

        genvar    i;
        generate
                for (i = 0; i < 4 ; i = i + 1 ) begin
                        bcd2ascii1_4 my_bcd2ascii1_4
                        (
                                .clk(clk),
                                .rst(rst),

                                .bcd(bcd_word_arr[i]),
                                .ascii(ascii_word_arr[i])
                        );
                end
        endgenerate

endmodule
