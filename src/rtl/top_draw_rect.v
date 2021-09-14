//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Damian Herduś
// 
// Create Date:         08.09.2021 
// Design Name:         top_draw_rect
// Module Name:         top_draw_rect
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         this module provide prject with adc_macros.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:         using Verilog-2001 syntax.
//              
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module top_draw_rect 
        (
        input   wire pclk,
        input   wire rst,

        input   wire[11:0] xpos,
        input   wire[11:0] ypos,

        input   wire [11:0] vcount_in,
        input   wire vsync_in, 
        input   wire vblnk_in, 
        input   wire [11:0] hcount_in,
        input   wire hsync_in, 
        input   wire hblnk_in, 
        input   wire [11:0] rgb_in,

        output  wire [11:0] vcount_out,
        output  wire vsync_out, 
        output  wire vblnk_out, 
        output  wire [11:0] hcount_out,
        output  wire hsync_out, 
        output  wire hblnk_out, 
        output  wire [11:0] rgb_out
        );
        
        wire [11:0] rgb_pixel;
        wire [15:0] pixel_addr;

        draw_rect my_draw_rect 
        (
                .pclk(pclk),
                .rst(rst),

                .xpos(xpos),
                .ypos(ypos),

                .vcount_in(vcount_in),
                .vsync_in(vsync_in),
                .vblnk_in(vblnk_in),
                .hcount_in(hcount_in),
                .hsync_in(hsync_in),
                .hblnk_in(hblnk_in),
                .rgb_in(rgb_in),
                .rgb_pixel(rgb_pixel),

                .vcount_out(vcount_out),
                .vsync_out(vsync_out),
                .vblnk_out(vblnk_out),
                .hcount_out(hcount_out),
                .hsync_out(hsync_out),
                .hblnk_out(hblnk_out),
                .rgb_out(rgb_out),
                .pixel_addr(pixel_addr)
        );

        image_rom my_image_rom
        (
                .clk(pclk),
        
                .address(pixel_addr),
                .rgb(rgb_pixel)
        );
endmodule
