// File: top_draw_rect_char.v
// This module draw a char on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module top_MouseDisplay 
        (
        input   wire pclk,

        input   wire[11:0] xpos,
        input   wire[11:0] ypos,

        input   wire [11:0] vcount_in,
        input   wire vsync_in, 
        input   wire vblnk_in, 
        input   wire [11:0] hcount_in,
        input   wire hsync_in, 
        input   wire hblnk_in, 
        input   wire [11:0] rgb_in,

        output  reg hsync_out, 
        output  reg vsync_out, 

        output  wire [3:0] red_out,
        output  wire [3:0] green_out,
        output  wire [3:0] blue_out
        );

        MouseDisplay my_MouseDisplay
        (
                .pixel_clk (pclk),
                
                .xpos (xpos),
                .ypos (ypos),

                .vcount (vcount_in),
                .blank ((vblnk_in || hblnk_in)),
                .hcount (hcount_in),

                .red_in (rgb_in[11:8]),
                .green_in (rgb_in[7:4]),
                .blue_in (rgb_in[3:0]),

                .red_out (red_out),
                .green_out (green_out),
                .blue_out (blue_out),

                .enable_mouse_display_out ()

        ); 

        always @(posedge pclk) begin
                hsync_out <= hsync_in;
                vsync_out <= vsync_in;
        end
endmodule
