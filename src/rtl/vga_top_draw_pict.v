//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Damian Herduś
// 
// Create Date:         08.09.2021 
// Design Name:         vga_top_draw_pict
// Module Name:         vga_top_draw_pict
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         this module is top level module for vga_draw_pict.
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

module vga_top_draw_pict 
        (
                input   wire clk,
                input   wire rst,

                input   wire [`VGA_BUS_SIZE-1:0] vga_in,
                output  wire [`VGA_BUS_SIZE-1:0] vga_out

        );
        
        wire [11:0] rgb_pixel;
        wire [15:0] pixel_addr;

        vga_draw_pict my_vga_draw_pic 
        (
                .clk(clk),
                .rst(rst),

                .vga_in (vga_in),
                .rgb_pixel(rgb_pixel),

                .vga_out (vga_out),
                .pixel_addr(pixel_addr)
        );

        vga_image_rom my_vga_image_rom
        (
                .clk(clk),
                .rst(rst),
        
                .address(pixel_addr),
                .rgb(rgb_pixel)
        );
endmodule
