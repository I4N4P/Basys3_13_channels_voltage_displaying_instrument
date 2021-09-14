//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Damian Herduś
// 
// Create Date:         08.09.2021 
// Design Name:         draw_rect
// Module Name:         draw_rect
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

`include "_vga_macros.vh"

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect (
        input   wire pclk,
        input   wire rst,

        // input   wire[11:0] xpos,
        // input   wire[11:0] ypos,

        // input   wire [11:0] vcount_in,
        // input   wire vsync_in, 
        // input   wire vblnk_in, 
        // input   wire [11:0] hcount_in,
        // input   wire hsync_in, 
        // input   wire hblnk_in, 
        // input   wire [11:0] rgb_in,
        input   wire [11:0] rgb_pixel,

                        input   wire [`VGA_BUS_SIZE-1:0] vga_in,
                output  wire [`VGA_BUS_SIZE-1:0] vga_out,

        // output  reg [11:0] vcount_out,
        // output  reg vsync_out, 
        // output  reg vblnk_out, 
        // output  reg [11:0] hcount_out,
        // output  reg hsync_out, 
        // output  reg hblnk_out, 
        // output  reg [11:0] rgb_out,
        output  reg [15:0] pixel_addr
        );


        `VGA_SPLIT_INPUT(vga_in)
        `VGA_OUT_REG
        `VGA_MERGE_OUTPUT(vga_out)
        // This are the parameters of the rectangle.

        localparam RECT_HEIGHT = 260;
        localparam RECT_WIDTH = 240;

        localparam XPOS = 0;
        localparam YPOS = 500;
        
        reg [11:0] rgb_nxt;
        reg [15:0] pixel_addr_nxt;
        

        wire [11:0] vcount_out_s,hcount_out_s,vcount_out_s2,hcount_out_s2; 
        wire vsync_out_s, hsync_out_s,vsync_out_s2, hsync_out_s2;
        wire vblnk_out_s, hblnk_out_s,vblnk_out_s2, hblnk_out_s2;
        wire [11:0] rgb_out_s,rgb_out_s2;


        delay #(
                .WIDTH (28),
                .CLK_DEL(2)
        ) timing_delay (
                .clk (pclk),
                .rst (rst),
                .din ( {hcount_in, hsync_in, hblnk_in, vcount_in, vsync_in, vblnk_in}),
                .dout ({hcount_out_s2, hsync_out_s2, hblnk_out_s2, vcount_out_s2, vsync_out_s2, vblnk_out_s2})
        );

        delay #(
                .WIDTH (12),
                .CLK_DEL(2)
        ) rgb_delay (
                .clk (pclk),
                .rst (rst),
                .din (rgb_in),
                .dout (rgb_out_s2)
        );




        // Synchronical logic
        
        always @(posedge pclk) 
        begin
        // pass these through if rst not activ then put 0 on the output.
        if (rst) 
        begin
                vcount_out <= 12'b0;
                hcount_out <= 12'b0;
                vs_out  <= 1'b0;
                vblnk_out  <= 1'b0; 
                hs_out  <= 1'b0;
                hblnk_out  <= 1'b0; 
                rgb_out    <= 12'h0_0_0;
                pixel_addr <= 12'h0_0_0;

        end
        else 
        begin
                vcount_out <= vcount_out_s2;
                hcount_out <= hcount_out_s2;

                vs_out  <= vsync_out_s2;
                hs_out  <= hsync_out_s2;
                
                vblnk_out  <= vblnk_out_s2; 
                hblnk_out  <= hblnk_out_s2;
                rgb_out    <= rgb_nxt;
                
                pixel_addr <= pixel_addr_nxt;

        end
        end
        // Combinational logic
        always @* begin
                // rectangle generator
                if (hblnk_out_s2 || vblnk_out_s2) begin
                        rgb_nxt = rgb_out_s2;
                end else begin
                        if (hcount_out_s2 >= XPOS && hcount_out_s2 <= XPOS + RECT_WIDTH && vcount_out_s2 >= YPOS && vcount_out_s2 <= YPOS + RECT_HEIGHT)
                                rgb_nxt = rgb_pixel; 
                        else 
                                rgb_nxt = rgb_out_s2;  
                end
                pixel_addr_nxt = {vcount_in[7:0], hcount_in[7:0]};
        end
endmodule
