
//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         10.05.2021 
// Design Name:         vga_top_draw_char
// Module Name:         vga_top_draw_char
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         this module is top level for vga_draw_char.
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

`timescale 1 ns / 1 ps

`include "_vga_macros.vh"

module vga_top_draw_char 
        #( 
                parameter XPOS = 64,
                          YPOS = 40
        )
        (
                input   wire clk,
                input   wire rst,

                input wire [15:0] in0,
                input wire [15:0] in1,
                input wire [15:0] in2,
                input wire [15:0] in3,
                input wire [15:0] in4,
                input wire [15:0] in5,
                input wire [15:0] in6,
                input wire [15:0] in7,
                input wire [15:0] in8,
                input wire [15:0] in9,
                input wire [15:0] in10,
                input wire [15:0] in11,
                input wire [15:0] in12,
 
                input   wire [`VGA_BUS_SIZE-1:0] vga_in,


                output  wire vsync_out, 
                output  wire hsync_out, 
                output  wire [11:0] rgb_out
        );

        `VGA_SPLIT_INPUT(vga_in)

        wire [3:0]  text_line;
        wire [7:0]  text_xy;
        wire [6:0]  char_code;
        wire [7:0]  char_pixel;
        wire [27:0] ascii [0:12];
        reg  [15:0] in [0:12];


        vga_draw_char #(
                .XPOS (XPOS),
                .YPOS (YPOS)
        ) my_vga_draw_char 
        (
                .clk (clk),
                .rst  (rst),

                .vga_in (vga_in),

                .char_pixel(char_pixel),
                
                .vsync_out(vsync_out),
                .hsync_out(hsync_out),
                .rgb_out(rgb_out),
                .text_xy(text_xy),
                .text_line(text_line)
        );

        vga_font_rom my_vga_font_rom
        (
                //.clk(clk),
        
                .addr({char_code,text_line}),
                .data(char_pixel)
        );

        genvar    i;
        generate
                for (i = 0; i < 13 ; i = i + 1 ) begin
                        bcdword2ascii1_16 my_bcdword2ascii1_16
                        (
                                .clk(clk),
                                .rst(rst),

                                .bcd_word(in[i]),
                                .ascii_word(ascii[i])
                        );
                end
        endgenerate
        
        vga_measurements_rom my_vga_measurements_rom
        (
                .clk(clk),

                .in0(ascii[0]),
                .in1(ascii[1]),
                .in2(ascii[2]),
                .in3(ascii[3]),
                .in4(ascii[4]),
                .in5(ascii[5]),
                .in6(ascii[6]),
                .in7(ascii[7]),
                .in8(ascii[8]),
                .in9(ascii[9]),
                .in10(ascii[10]),
                .in11(ascii[11]),
                .in12(ascii[12]),
                .text_xy(text_xy),
                .char_code(char_code)
        );
        
        always @* begin
                in[0] = in0;
                in[1] = in1;
                in[2] = in2;
                in[3] = in3;
                in[4] = in4;
                in[5] = in5;
                in[6] = in6;
                in[7] = in7;
                in[8] = in8;
                in[9] = in9;
                in[10] = in10;
                in[11] = in11;
                in[12] = in12; 
        end

endmodule
