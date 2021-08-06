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

        input vauxp6,
    input vauxn6,
    input vauxp7,
    input vauxn7,
    input vauxp15,
    input vauxn15,
    input vauxp14,
    input vauxn14,
    input vp_in,
    input vn_in,
    output [3:0] an,
    output dp,
    output [6:0] seg,
        output reg vs,
        output reg hs,
        output reg [3:0] r,
        output reg [3:0] g,
        output reg [3:0] b
        );


        // wire clk100MHz;
        // wire pclk;
        // wire locked;
        wire reset;

        wire [3:0] red_out,green_out,blue_out;

        wire [11:0] vcount, hcount,vcount_out_b, hcount_out_b,vcount_out_c, hcount_out_c;  // here is the change of the size of variable in order to mould with MouseDisplay
        wire [11:0] rgb_out_b, rgb_out_c; 
        wire vsync, hsync,vsync_out_b, hsync_out_b, vsync_out_c, hsync_out_c;
        wire vblnk, hblnk,vblnk_out_b, hblnk_out_b, vblnk_out_c, hblnk_out_c;
  
   
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

        internal_reset my_internal_reset
        (
                .pclk   (pclk),
                .locked (locked),
                .reset_out (reset)
        );





//  wire enable;  
//     wire ready;
//     wire [15:0] data;   
//     reg [6:0] Address_in;
	
// 	//secen seg1ment controller signals
//     reg [32:0] count;
//     localparam S_IDLE = 0;
//     localparam S_FRAME_WAIT = 1;
//     localparam S_CONVERSION = 2;
//     reg [1:0] state = S_IDLE;
//     reg [15:0] sseg1_data;
	
// 	//binary to decimal converter signals
//     reg b2d_start;
//     reg [15:0] b2d_din;
//     wire [15:0] b2d_dout;
//     wire b2d_done;

//     //xadc instan1tiation connect the eoc_out .den_in to get continuous conversion
//     xadc_wiz_0  XLXI_7 (
//         .daddr_in(8'h16), //addresses can1 be found in the artix 7 XADC user guide DRP register space
//         .dclk_in(dclk), 
//         .den_in(enable), 
//         .di_in(0), 
//         .dwe_in(0), 
//         .busy_out(),                    
//         .vauxp6(in1),
//         .vauxn6(in2),
//         .vauxp7(),
//         .vauxn7(),
//         .vauxp14(),
//         .vauxn14(),
//         .vauxp15(),
//         .vauxn15(),
//         .vn_i(vn_i), 
//         .vp_i(vp_i), 
//         .alarm_out(), 
//         .do_out(data), 
//         //.reset_in(),
//         .eoc_out(enable),
//         .chan1nel_out(),
//         .drdy_out(ready)
//     );
//  xadc_wiz_0  XLXI_7 (
//         .daddr_in(8'h16), //addresses can be found in the artix 7 XADC user guide DRP register space
//         .dclk_in(clk100Mhz), 
//         .den_in(enable), 
//         .di_in(0), 
//         .dwe_in(0), 
//         .busy_out(),                    
//         .vauxp6(vauxp6),
//         .vauxn6(vauxn6),
//         .vauxp7(vauxp7),
//         .vauxn7(vauxn7),
//         .vauxp14(vauxp14),
//         .vauxn14(vauxn14),
//         .vauxp15(vauxp15),
//         .vauxn15(vauxn15),
//         .vn_in(vn_in), 
//         .vp_in(vp_in), 
//         .alarm_out(), 
//         .do_out(data), 
//         //.reset_in(),
//         .eoc_out(enable),
//         .channel_out(),
//         .drdy_out(ready)
//     );
//     //binary to decimal conversion
//     always @ (posedge(clk100Mhz)) begin
//         case (state)
//         S_IDLE: begin
//             state <= S_FRAME_WAIT;
//             count <= 'b0;
//         end
//         S_FRAME_WAIT: begin
//             if (count >= 10000000) begin
//                 if (data > 16'hFFD0) begin
//                     sseg1_data <= 16'h1000;
//                     state <= S_IDLE;
//                 end else begin
//                     b2d_start <= 1'b1;
//                     b2d_din <= data;
//                     state <= S_CONVERSION;
//                 end
//             end else
//                 count <= count + 1'b1;
//         end
//         S_CONVERSION: begin
//             b2d_start <= 1'b0;
//             if (b2d_done == 1'b1) begin
//                 sseg1_data <= b2d_dout;
//                 state <= S_IDLE;
//             end
//         end
//         endcase
//     end
    
//     bin2dec m_b2d (
//         .clk(clk100Mhz),
//         .start(b2d_start),
//         .din(b2d_din),
//         .done(b2d_done),
//         .dout(b2d_dout)
//     );
      
     
//     DigitToSeg seg1ment1(
//         .in1(sseg1_data[3:0]),
//         .in2(sseg1_data[7:4]),
//         .in3(sseg1_data[11:8]),
//         .in4(sseg1_data[15:12]),
//         .in5(4'b0),
//         .in6(4'b0),
//         .in7(4'b0),
//         .in8(4'b0),
//         .mclk(clk100Mhz),
//         .an(an),
//         .dp(dp),
//         .seg(seg)
//     );

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
                .XPOS (125),
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
