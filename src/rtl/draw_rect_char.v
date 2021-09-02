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

        output  reg vsync_out,  
        output  reg hsync_out,  
        output  reg [11:0] rgb_out,
        output  reg [7:0] text_xy,
        output  reg [3:0] text_line
        );

        // This are the parameters of the rectangle.

        localparam RECT_HEIGHT = 208;
        localparam RECT_WIDTH  = 96;

        localparam BLACK = 12'h0_0_0;
        localparam WHITE = 12'hf_f_f;
        
        reg [11:0] rgb_nxt = 12'b0;
        reg [7:0] offset,offset_nxt;
        reg [11:0] hcount_pic,vcount_pic_nxt,hcount_pic_nxt;
        reg [3:0] vcount_pic;


        wire vsync_out_d, hsync_out_d;
        wire vblnk_out_d, hblnk_out_d;

        wire [11:0] vcount_out_d, hcount_out_d,hcount_out_d2; 
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
                .WIDTH (24),
                .CLK_DEL(2)
        ) rgb_delay (
                .clk  (pclk),
                .rst  (rst),
                .din  ({hcount_pic_nxt,rgb_in}),
                .dout ({hcount_out_d2,rgb_out_d})
        );

        // Synchronical logic
        
        always @(posedge pclk) begin
                // pass these through if rst not activ then put 0 on the output.
                if (rst) begin
                        vsync_out  <= 1'b0; 
                        hsync_out  <= 1'b0;
                        text_line  <= 4'b0;
                        vcount_pic <= 4'b0;
                        text_xy    <= 8'b0;
                        offset     <= 8'b0; 
                        hcount_pic <= 12'b0;
                        rgb_out    <= 12'h0;

                end else begin

                        vsync_out  <= vsync_out_d;
                        hsync_out  <= hsync_out_d;
                                  
                        text_line  <= vcount_pic_nxt[3:0];
                        
                        vcount_pic <= vcount_pic_nxt[3:0];

                        text_xy    <= (hcount_pic_nxt[9:3] + offset_nxt);

                        offset     <= offset_nxt;
                        hcount_pic <= hcount_pic_nxt;
                        rgb_out    <= rgb_nxt;
                end
        end
        // Combinational logic
        always @* begin
                hcount_pic_nxt = hcount_in - XPOS;
                vcount_pic_nxt = vcount_in - YPOS;
                // addr generator
                if ((hcount_in >= XPOS) && (hcount_in <=XPOS + RECT_WIDTH) && (vcount_in >= YPOS) && (vcount_in <= YPOS + RECT_HEIGHT)
                 && (hcount_pic == (RECT_WIDTH - 1)) && (vcount_pic == 15))
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
                                if (char_pixel[(8 - (hcount_out_d2[2:0]))] == 1)
                                        rgb_nxt = WHITE; 
                                else 
                                        rgb_nxt = BLACK;  
                        end else begin
                                        rgb_nxt = rgb_out_d;
                        end
                end
        end
endmodule
