// File: draw_rect_char.v
// This module draw a char on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_char 
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
        input   wire [7:0] char_pixel,

        output  reg [11:0] vcount_out,
        output  reg vsync_out, 
        output  reg vblnk_out, 
        output  reg [11:0] hcount_out,
        output  reg hsync_out, 
        output  reg hblnk_out, 
        output  reg [11:0] rgb_out,
        output  reg [7:0] text_xy,
        output  reg [3:0] text_line
        );

        // This are the parameters of the rectangle.

        localparam RECT_HEIGHT = 256;
        localparam RECT_WIDTH  = 128;

        localparam BLACK = 12'h0_0_0;
        localparam WHITE = 12'hf_f_f;
        
        reg [11:0] rgb_nxt = 12'b0;

        reg [7:0] offset,offset_nxt = 0;
        reg [11:0] hcount_pic,vcount_pic_nxt = 0,hcount_pic_nxt = 0;
        reg [3:0] vcount_pic;


        wire vsync_out_d, hsync_out_d;
        wire vblnk_out_d, hblnk_out_d;

        wire [11:0] vcount_out_d, hcount_out_d; 
        wire [11:0] rgb_out_d;

        delay #(
                .WIDTH  (28),
                .CLK_DEL(2)
        ) timing_delay (
                .clk  (pclk),
                .rst  (rst),
                .din  ({hcount_in, hsync_in, hblnk_in, vcount_in, vsync_in, vblnk_in}),
                .dout ({hcount_out_d, hsync_out_d, hblnk_out_d, vcount_out_d, vsync_out_d, vblnk_out_d})
        );

        delay #(
                .WIDTH (12),
                .CLK_DEL(2)
        ) rgb_delay (
                .clk  (pclk),
                .rst  (rst),
                .din  (rgb_in),
                .dout (rgb_out_d)
        );


        // Synchronical logic
        
        always @(posedge pclk) begin
                // pass these through if rst not activ then put 0 on the output.
                if (rst) begin
                        vcount_out <= 12'b0;
                        hcount_out <= 12'b0;
                        vsync_out  <= 1'b0;
                        vblnk_out  <= 1'b0; 
                        hsync_out  <= 1'b0;
                        hblnk_out  <= 1'b0; 
                        rgb_out    <= 12'h0_0_0;
                        text_xy    <= 8'b0;
                        text_line  <= 3'b0;

                end else begin
                        vcount_out <= vcount_out_d;
                        hcount_out <= hcount_out_d;

                        vsync_out  <= vsync_out_d;
                        hsync_out  <= hsync_out_d;
                        
                        vblnk_out  <= vblnk_out_d; 
                        hblnk_out  <= hblnk_out_d;

                        rgb_out    <= rgb_nxt;
                        
                        text_line  <= vcount_pic_nxt[3:0];
                        text_xy    <= (hcount_pic_nxt[9:3] + offset_nxt);
                        
                        offset <= offset_nxt;

                        hcount_pic <= hcount_pic_nxt;
                        vcount_pic <= vcount_pic_nxt[3:0];

                end
        end
        // Combinational logic
        always @* begin

                hcount_pic_nxt = hcount_in - (XPOS - 1);
                vcount_pic_nxt = vcount_in - (YPOS - 1);
                // addr generator
                if ((hcount_in >= XPOS) && (hcount_in < XPOS + RECT_WIDTH) && (vcount_in >= YPOS) && (vcount_in < YPOS + RECT_HEIGHT)
                 && (hcount_pic == 127) && (vcount_pic == 15))
                        offset_nxt = offset + 16;
                else
                        offset_nxt = offset;
                // text generator
                if (hblnk_out_d || vblnk_out_d) begin
                        rgb_nxt = rgb_out_d;
                end else begin
                        if (hcount_out_d >= XPOS && hcount_out_d < XPOS + RECT_WIDTH 
                         && vcount_out_d >= YPOS && vcount_out_d < YPOS + RECT_HEIGHT) begin
                                if (char_pixel[(8 - hcount_out_d[2:0])] == 1)
                                        rgb_nxt = WHITE; 
                                else 
                                        rgb_nxt = BLACK;  
                        end else begin
                                        rgb_nxt = rgb_out_d;
                        end
                end
        end
endmodule
