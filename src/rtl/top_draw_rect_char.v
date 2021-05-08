// File: top_draw_rect_char.v
// This module draw a char on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module top_draw_rect_char 
        #( parameter
                XPOS = 64,
                YPOS = 40
        )
        (
        input   wire pclk,
        input   wire rst,

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

        reg  [3:0]  text_line_r;
        wire [3:0]  text_line;
        wire [7:0]  text_xy;
        wire [6:0]  char_code;
        wire [7:0]  char_pixel;


        draw_rect_char #(
                .XPOS (XPOS),
                .YPOS (YPOS)
        ) my_draw_rect_char 
        (
                .pclk (pclk),
                .rst  (rst),

                .vcount_in(vcount_in),
                .vsync_in(vsync_in),
                .vblnk_in(vblnk_in),
                .hcount_in(hcount_in),
                .hsync_in(hsync_in),
                .hblnk_in(hblnk_in),
                .rgb_in(rgb_in),
                .char_pixel(char_pixel),

                .vcount_out(vcount_out),
                .vsync_out(vsync_out),
                .vblnk_out(vblnk_out),
                .hcount_out(hcount_out),
                .hsync_out(hsync_out),
                .hblnk_out(hblnk_out),
                .rgb_out(rgb_out),
                .text_xy(text_xy),
                .text_line(text_line)
        );

        font_rom my_font_rom
        (
                .clk(pclk),
        
                .addr({char_code,text_line_r}),
                .char_line_pixels(char_pixel)
        );
        text_rom_16x16 my_text_rom_16x16
        (
                .clk(pclk),
        
                .text_xy(text_xy),
                .char_code(char_code)
        );

        always @(posedge pclk)
                text_line_r <= text_line;

endmodule
