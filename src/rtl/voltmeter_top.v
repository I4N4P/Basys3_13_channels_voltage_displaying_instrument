// File: vga_example.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module voltmeter_top (
        input wire clk,
        input wire rst,

        output reg vs,
        output reg hs,
        output reg [3:0] r,
        output reg [3:0] g,
        output reg [3:0] b
        );


        wire clk100MHz;
        wire pclk;
        wire locked;
        wire reset;

        wire [3:0] red_out,green_out,blue_out;

        wire [11:0] vcount, hcount,vcount_out_b, hcount_out_b,vcount_out_c, hcount_out_c;  // here is the change of the size of variable in order to mould with MouseDisplay
        wire [11:0] rgb_out_b, rgb_out_c; 
        wire vsync, hsync,vsync_out_b, hsync_out_b, vsync_out_c, hsync_out_c;
        wire vblnk, hblnk,vblnk_out_b, hblnk_out_b, vblnk_out_c, hblnk_out_c;
  
   
        clk_generator my_clk_generator
        (
                .clk (clk),
                // .clk100MHz (clk100MHz),
                .clk_65MHz (pclk),
                .reset (rst),
                .locked (locked)
        );

        internal_reset my_internal_reset
        (
                .pclk   (pclk),
                .locked (locked),
                .reset_out (reset)
        );

        vga_timing my_timing 
        (
                .pclk (pclk),
                .rst (reset),
                
                .vcount (vcount),
                .vsync  (vsync),
                .vblnk  (vblnk),
                .hcount (hcount),
                .hsync  (hsync),
                .hblnk  (hblnk)
        );

        draw_background my_draw_background 
        (
                .pclk(pclk),
                .rst (reset),

                .vcount_in (vcount),
                .vsync_in  (vsync),
                .vblnk_in  (vblnk),
                .hcount_in (hcount),
                .hsync_in  (hsync),
                .hblnk_in  (hblnk),

                .vcount_out (vcount_out_b),
                .vsync_out  (vsync_out_b),
                .vblnk_out  (vblnk_out_b),
                .hcount_out (hcount_out_b),
                .hsync_out  (hsync_out_b),
                .hblnk_out  (hblnk_out_b),
                .rgb_out    (rgb_out_b)
        );
       
        top_draw_rect_char 
        #(
                .XPOS (128),
                .YPOS (99)
        ) 
        my_top_draw_rect_char 
        (
                .pclk (pclk),
                .rst  (reset),

                .vcount_in (vcount_out_b),
                .vsync_in  (vsync_out_b),
                .vblnk_in  (vblnk_out_b),
                .hcount_in (hcount_out_b),
                .hsync_in  (hsync_out_b),
                .hblnk_in  (hblnk_out_b),
                .rgb_in    (rgb_out_b),

                .vsync_out  (vsync_out_c),
                .hsync_out  (hsync_out_c),
                .rgb_out    (rgb_out_c)
        );

        // Synchronical logic
        always @(posedge pclk) begin
                // Just pass these through.
                hs <= hsync_out_c;
                vs <= vsync_out_c;

                r  <= rgb_out_c[11:8];
                g  <= rgb_out_c[7:4];
                b  <= rgb_out_c[3:0];
        end
endmodule
