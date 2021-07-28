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
        input iadcp1,
        input iadcn1,
        input vp_in,
        input vn_in,
        output reg vs,
        output reg hs,
        output reg [3:0] r,
        output reg [3:0] g,
        output reg [3:0] b,
        output reg tx, 
        output [3:0] an,
        output dp,
        output [6:0] seg
        );


/*******************CLOCK_GENERATION*********************************/


        wire clk100Mhz;
        wire pclk;
        wire locked;

        clk_generator my_clk_generator
        (
                .clk (clk),
                .clk_100Mhz (clk100Mhz),
                .clk_65Mhz (pclk),
                .reset (rst),
                .locked (locked)
        );


/*******************RESET_GENERATION*********************************/


        wire reset;

        internal_reset my_internal_reset
        (
                .pclk   (pclk),
                .locked (locked),
                .reset_out (reset)
        );


/*******************INTERNAL_ADC*********************************/	
	

        wire [15:0] sseg_data;

        integrated_adc my_integrated_adc 
        (
                .clk (clk100Mhz),
                .iadcp1 (iadcp1),
                .iadcn1 (iadcn1),
                .vp_in (vp_in),
                .vn_in (vn_in),
                .dout (sseg_data)
        );

        DigitToSeg segment1
        (
                .mclk (clk100Mhz),
                .rst (reset),
                .in1 (sseg_data[3:0]),
                .in2 (sseg_data[7:4]),
                .in3 (sseg_data[11:8]),
                .in4 (sseg_data[15:12]),
                .in5 (4'b0),
                .in6 (4'b0),
                .in7 (4'b0),
                .in8 (4'b0),
                .an (an),
                .dp (dp),
                .seg (seg)
        );


/*******************UART_MODULE*********************************/
        
        
        wire tx_w;
        wire  tick;
        wire [7:0] uart_data;

        uart_control my_uart_control
        (
                .clk (clk100Mhz),
                .rst (rst),
                .in (sseg_data),
                .sign (uart_data),
                .tick (tick)        
        );

        uart 
        #(
                .DBIT (8),     
                .SB_TICK (16),                   
                .DVSR (326),   
                .DVSR_BIT (9), 
                .FIFO_W (8)    
        )
        my_uart 
        (
                .clk (clk100Mhz),
                .reset (rst),
                .wr_uart (tick), 
                .w_data (uart_data),
                .tx_full (), 
                .tx (tx_w)
        );

        always @(posedge clk100Mhz) begin
                tx <= tx_w;
        end

/*******************VGA_CONTROL*********************************/
        
        
        //wire [3:0] red_out,green_out,blue_out;
        //wire vsync_out_M, hsync_out_M;

        wire vsync, hsync,vsync_out_b, hsync_out_b, vsync_out_c, hsync_out_c;
        wire vblnk, hblnk,vblnk_out_b, hblnk_out_b, vblnk_out_c, hblnk_out_c;
        wire [11:0] vcount, hcount,vcount_out_b, hcount_out_b,vcount_out_c, hcount_out_c;
        wire [11:0] rgb_out_b, rgb_out_c; 
  

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

        top_draw_rect_char #(
                .XPOS (128),
                .YPOS (99)
        ) my_top_draw_rect_char 
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

                .vcount_out (vcount_out_c),
                .vsync_out  (vsync_out_c),
                .vblnk_out  (vblnk_out_c),
                .hcount_out (hcount_out_c),
                .hsync_out  (hsync_out_c),
                .hblnk_out  (hblnk_out_c),
                .rgb_out    (rgb_out_c)
        );


        //Synchronical logic
        always @(posedge pclk) begin
                // Just pass these through.
                hs <= hsync_out_c;
                vs <= vsync_out_c;

                r  <= rgb_out_c[11:8];
                g  <= rgb_out_c[7:4];
                b  <= rgb_out_c[3:0];
        end
endmodule
