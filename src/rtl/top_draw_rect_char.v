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

        input   wire [11:0] vcount_in,
        input   wire vsync_in, 
        input   wire vblnk_in, 
        input   wire [11:0] hcount_in,
        input   wire hsync_in, 
        input   wire hblnk_in, 
        input   wire [11:0] rgb_in,


        output  wire vsync_out, 
        output  wire hsync_out, 
        output  wire [11:0] rgb_out
        );

        reg  [3:0]  text_line_r;
        wire [3:0]  text_line;
        wire [7:0]  text_xy;
        wire [6:0]  char_code;
        wire [7:0]  char_pixel;
        wire [27:0] ascii0,ascii1,ascii2,ascii3,
                    ascii4,ascii5,ascii6,ascii7,
                    ascii8,ascii9,ascii10,ascii11,ascii12;


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
                
                .vsync_out(vsync_out),
                .hsync_out(hsync_out),
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


        bcdword2ascii1_16 bcdword2ascii1_16_0
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in0),
            .ascii_word(ascii0)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_1
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in1),
            .ascii_word(ascii1)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_2
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in2),
            .ascii_word(ascii2)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_3
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in3),
            .ascii_word(ascii3)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_4
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in4),
            .ascii_word(ascii4)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_5
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in5),
            .ascii_word(ascii5)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_6
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in6),
            .ascii_word(ascii6)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_7
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in7),
            .ascii_word(ascii7)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_8
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in8),
            .ascii_word(ascii8)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_9
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in9),
            .ascii_word(ascii9)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_10
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in10),
            .ascii_word(ascii10)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_11
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in11),
            .ascii_word(ascii11)
            );
        bcdword2ascii1_16 bcdword2ascii1_16_12
            (
            .clk(pclk),
            .rst(rst),

            .bcd_word(in12),
            .ascii_word(ascii12)
            );


        text_rom_16x16 my_text_rom_16x16
        (
                .clk(pclk),

                .in0(ascii0),
                .in1(ascii1),
                .in2(ascii2),
                .in3(ascii3),
                .in4(ascii4),
                .in5(ascii5),
                .in6(ascii6),
                .in7(ascii7),
                .in8(ascii8),
                .in9(ascii9),
                .in10(ascii10),
                .in11(ascii11),
                .in12(ascii12),
                .text_xy(text_xy),
                .char_code(char_code)
        );

        always @(posedge pclk)
                text_line_r <= text_line;

endmodule
