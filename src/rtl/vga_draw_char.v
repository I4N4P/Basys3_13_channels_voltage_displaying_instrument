
//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         15.04.2021 
// Design Name:         vga_draw_rect_char
// Module Name:         vga_draw_rect_char
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This module draw a table of chars on the backround.
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

module vga_draw_char 
        #( 
                parameter XPOS = 64,
                          YPOS = 40
        )
        (
                input   wire clk,
                input   wire rst,

                input   wire [`VGA_BUS_SIZE-1:0] vga_in,

                input   wire [7:0] char_pixel,

                output  reg vsync_out,  
                output  reg hsync_out,  
                output  reg [11:0] rgb_out,
                output  reg [7:0] text_xy,
                output  reg [3:0] text_line
        );

        `VGA_SPLIT_INPUT(vga_in)
        // This are the parameters of the rectangle.

        localparam RECT_HEIGHT = 208;
        localparam RECT_WIDTH  = 96;

        localparam BLUE = 12'h1_4_7;
        localparam WHITE = 12'hf_f_f;
        
        reg [11:0] rgb_nxt = 12'b0;
        reg [7:0] offset,offset_nxt;
        reg [11:0] hcount_pic,vcount_pic_nxt,hcount_pic_nxt;
        reg [3:0] vcount_pic2;

        reg [7:0] pixels_nxt,pixels;


        wire vsync_out_d, hsync_out_d;
        wire vblnk_out_d, hblnk_out_d;

        wire [11:0] vcount_out_d, hcount_out_d; 
        wire [11:0] rgb_out_d;
        wire [2:0] hcount_out_d2;

        delay #(
                .WIDTH  (28),
                .CLK_DEL(2)
        ) timing_delay (
                .clk  (clk),
                .rst  (rst),
                .din  ({hcount_in, hs_in, hblnk_in, vcount_in, vs_in, vblnk_in}),
                .dout ({hcount_out_d, hsync_out_d, hblnk_out_d, vcount_out_d, vsync_out_d, vblnk_out_d})
        );

        delay #(
                .WIDTH (15),
                .CLK_DEL(2)
        ) rgb_delay (
                .clk  (clk),
                .rst  (rst),
                .din  ({hcount_pic_nxt[2:0],rgb_in}),
                .dout ({hcount_out_d2,rgb_out_d})
        );

        // Synchronical logic
        
        always @(posedge clk) begin
                // pass these through if rst not activ then put 0 on the output.
                if (rst) begin
                        vsync_out  <= 1'b0; 
                        hsync_out  <= 1'b0;
                        text_line  <= 4'b0;
                        text_xy    <= 8'b0;
                        offset     <= 8'b0; 
                        hcount_pic <= 12'b0;
                        rgb_out    <= 12'h0;

                end else begin

                        vsync_out  <= vsync_out_d;
                        hsync_out  <= hsync_out_d;
                                  
                        text_line  <= vcount_pic2;

                        pixels <= pixels_nxt;

                        text_xy    <= (hcount_pic_nxt[9:3] + offset_nxt);

                        offset     <= offset_nxt;
                        hcount_pic <= hcount_pic_nxt;
                        rgb_out    <= rgb_nxt;
                end
        end
        // Combinational logic
        always @* begin
                pixels_nxt = char_pixel;
                hcount_pic_nxt = hcount_in - XPOS;
                vcount_pic_nxt = vcount_in - YPOS;
                vcount_pic2    = vcount_pic_nxt[3:0] / 1;
                // addr generator
                if ((hcount_in >= XPOS) && (hcount_in <= XPOS + RECT_WIDTH) && (vcount_in >= YPOS) && (vcount_in <= YPOS + RECT_HEIGHT)
                 && (hcount_pic == (RECT_WIDTH - 1)) && (text_line == 15))
                        if((hcount_pic == (RECT_WIDTH - 1)) && (vcount_in == ((RECT_HEIGHT - 1) + YPOS)))
                                offset_nxt = 0;
                        else 
                                offset_nxt = offset + (RECT_WIDTH / 8);
                else
                        offset_nxt = offset;

                // text generator
                if (hblnk_out_d || vblnk_out_d) begin
                        rgb_nxt = rgb_out_d;
                end else begin
                        if (hcount_out_d >= XPOS && hcount_out_d <= XPOS + RECT_WIDTH 
                         && vcount_out_d >= YPOS && vcount_out_d <= YPOS + RECT_HEIGHT) begin
                                if (pixels[(8 - hcount_out_d2)] == 1)
                                        rgb_nxt = WHITE; 
                                else 
                                        rgb_nxt = BLUE;  
                        end else begin
                                        rgb_nxt = rgb_out_d;
                        end
                end
        end
endmodule
