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

        // inout wire ps2_clk, 
        // inout wire ps2_data,
         inout wire AD2_SCL, 
         inout wire AD2_SDA,

        // output reg vs,
        // output reg hs,
        // output reg [3:0] r,
        // output reg [3:0] g,
        // output reg [3:0] b,
        // output wire pclk_mirror,
        input wire btn,
        //         input wire rx, 
        //         input wire loopback_enable, 
                
        //         output reg tx, 


        // input iadcp1,
//     input iadcn1,
//     input vp_in,
//     input vn_in,
    output [3:0] an,
    output dp,
    output [6:0] seg

        );


        wire clk100Mhz;
        wire pclk;
        wire locked;
        wire reset;

        wire [11:0]xpos,ypos,xpos_mem,ypos_mem,xpos_ctl,ypos_ctl;
        wire mouse_left,mouse_left_mem;

        wire [3:0] red_out,green_out,blue_out;

        wire [11:0] vcount, hcount,vcount_out_b, hcount_out_b,vcount_out, hcount_out,vcount_out_d, hcount_out_d;  // here is the change of the size of variable in order to mould with MouseDisplay
        wire vsync, hsync,vsync_out_b, hsync_out_b, vsync_out, hsync_out, vsync_out_d, hsync_out_d;
        wire vblnk, hblnk,vblnk_out_b, hblnk_out_b,vblnk_out, hblnk_out,vblnk_out_d, hblnk_out_d;
        wire [11:0] rgb_out_b,rgb_out,rgb_out_d; 
  
        wire vsync_out_M, hsync_out_M;

	
	//secen segment controller signals
    reg [11:0] sseg_data;
	
	//binary to decimal converter signals
//  integrated_adc my_integrated_adc (
//     .clk(clk100Mhz),
//     .iadcp1(iadcp1),
//     .iadcn1(iadcn1),
//     .vp_in(vp_in),
//     .vn_in(vn_in),
//     .dout(sseg_data)
// );

wire btn_tick;

    wire enable;
    wire b2d_start;
    wire b2d_done;
    wire [15:0] data;
    wire [15:0] b2d_din;
    wire [15:0] b2d_dout;
    wire [15:0] dout;
    wire [11:0] raw_data;

 debounce my_btn_sig
        (
                .clk (clk100Mhz), 
                .reset (rst), 
              
                .sw (btn),

                .db_level (), 
                .db_tick (btn_tick)
        );
reg [7:0] adress,adress_nxt;
pmodAD2_ctrl my_pmodAD2_ctrl (

			.mainClk(clk100Mhz),
			.SDA_mst(AD2_SDA),
			.SCL_mst(AD2_SCL),
			.wData0(raw_data),
                        .writeCfg(adress),
			.rst(btn_tick)
                        
                        );

bin2bcd my (
        .bin(sseg_data),  // input binary number
        .bcd0(dout[3:0]), // LSB
        .bcd1(dout[7:4]),
        .bcd2(dout[11:8]), 
        .bcd3(dout[15:12])// MSB in order to obtain an extra display There was a need to add output 
    );
always @(posedge clk100Mhz) begin
        sseg_data <= (raw_data*805664)/1_000_000;
end
reg [3:0] counter,counter_nxt;

always @(negedge btn_tick) begin
        counter <= counter_nxt;
        adress  <= adress_nxt;
end

always @* begin
        if(counter == 3)
                counter_nxt = 0;
        else 
                counter_nxt = counter + 1;
        case (counter)
        0: adress_nxt = 8'b00010000;
        1: adress_nxt = 8'b00100000;
        2: adress_nxt = 8'b01000000;
        3: adress_nxt = 8'b10000000;
        default: adress_nxt = 8'b00100000;
        endcase

        
end
// bin2dec_ctl m2bin2dec_ctl(
//         .clk(clk100Mhz),
//         .din(sseg_data),
//         .b2d_start(b2d_start),
//         .b2d_din(b2d_din),
//         .dout(dout),
//         .b2d_dout(b2d_dout),
//         .b2d_done(b2d_done)
//     );

//     bin2dec m2_b2d (
//         .clk(clk100Mhz),
//         .start(b2d_start),
//         .din(b2d_din),
//         .done(b2d_done),
//         .dout(b2d_dout)
//     );



    DigitToSeg segment1(
        .rst(rst),
        .in1(dout[3:0]),
        .in2(dout[7:4]),
        .in3(dout[11:8]),
        .in4(dout[15:12]),
        .in5(4'b0),
        .in6(4'b0),
        .in7(4'b0),
        .in8(4'b0),
        .mclk(clk100Mhz),
        .an(an),
        .dp(dp),
        .seg(seg)
    );
//################################################################################
        // wire clk_100MHz,clk_50MHz;

        // wire tx_full, rx_empty, btn_tick,tx_w;
        // wire [7:0] rec_data;

        // reg [15:0] data1,data1_nxt = 16'b0;
        // reg [7:0] data2;
        // reg tick,tick_nxt = 1'b0;
        // reg flag,flag_nxt;


// gen_clock my_gen_clock 
//         (
//                 .clk (clk),
//                 .reset (rst),

//                 .clk_100MHz (),
//                 .clk_50MHz (clk_50MHz),            
//                 .locked ()
//         );

//         always @(posedge(clk100Mhz)) begin            
//             case (sseg_data[7:4])
//             0:  data2 <= 8'b0011_0000;
//             1:  data2 <= 8'b0011_0001;
//             2:  data2 <= 8'b0011_0010;
//             3:  data2 <= 8'b0011_0011;
//             4:  data2 <= 8'b0011_0100;
//             5:  data2 <= 8'b0011_0101;
//             6:  data2 <= 8'b0011_0110; 
//             7:  data2 <= 8'b0011_0111;
//             8:  data2 <= 8'b0011_1000;
//             9:  data2 <= 8'b0011_1001;   
//             default: data2 <= 8'b0011_0000; 
//             endcase
//     end

        // uart my_uart 
        // (
        //         .clk (clk_50MHz),
        //         .reset (rst),

        //         .rd_uart (tick),
        //         .wr_uart (btn_tick), 
        //         .rx (rx), 
        //         .w_data (data2),

        //         .tx_full (tx_full), 
        //         .rx_empty (rx_empty),
        //         .r_data (rec_data), 
        //         .tx (tx_w)
        // );

        // debounce my_btn_sig
        // (
        //         .clk (clk_50MHz), 
        //         .reset (rst), 
              
        //         .sw (btn),

        //         .db_level (), 
        //         .db_tick (btn_tick)
        // );

    
        // display and send ASCII synchronical logic

        // always @ (posedge clk_50MHz) begin
        //         if (rst) begin 
        //                 data1 <= 8'b0;
        //                 tick <= 1'b0;
        //                 flag <= 1'b0;
        //         end else begin
        //                 data1 <= data1_nxt;
        //                 tick <=tick_nxt;
        //                 flag <= flag_nxt;
        //         end      
        // end

        // display and send ASCII combinational logic


 /*Converts 100 MHz clk into 40 MHz pclk.
  *his uses a vendor specific primitive
  *called MMCME2, for frequency synthesis.
  *wire clk_in;
  *wire locked;
  *wire clk_fb;
  *wire clk_ss;
  *wire clk_out;
  *
  *(* KEEP = "TRUE" *) 
  *(* ASYNC_REG = "TRUE" *)
  *reg [7:0] safe_start = 0;
  *
  *IBUF clk_ibuf (.I(clk),.O(clk_in));
  *
  *MMCME2_BASE #(
  *  .CLKIN1_PERIOD(10.000),
  *  .CLKFBOUT_MULT_F(10.000),
  *  .CLKOUT0_DIVIDE_F(25.000))
  *clk_in_mmcme2 (
  *  .CLKIN1(clk_in),
  *  .CLKOUT0(clk_out),
  *  .CLKOUT0B(),
  *  .CLKOUT1(),
  *  .CLKOUT1B(),
  *  .CLKOUT2(),
  *  .CLKOUT2B(),
  *  .CLKOUT3(),
  *  .CLKOUT3B(),
  *  .CLKOUT4(),
  *  .CLKOUT5(),
  *  .CLKOUT6(),
  *  .CLKFBOUT(clkfb),
  *  .CLKFBOUTB(),
  *  .CLKFBIN(clkfb),
  *  .LOCKED(locked),
  *  .PWRDWN(1'b0),
  *  .RST(1'b0)
  *);
  *
  *BUFH clk_out_bufh (.I(clk_out),.O(clk_ss));
  *always @(posedge clk_ss) safe_start<= {safe_start[6:0],locked}; 
  *
  *BUFGCE clk_out_bufgce (.I(clk_out),.CE(safe_start[7]),.O(pclk));
  */ 
    
        clk_generator my_clk_generator
        (
                .clk (clk),
                .clk_100Mhz (clk100Mhz),
                .clk_65Mhz (pclk),
                .reset (rst),
                .locked (locked)
        );
  // Mirrors pclk on a pin for use by the testbench;
  // not functionally required for this design to work.

        // ODDR pclk_oddr 
        // (
        //         .Q  (pclk_mirror),
        //         .C  (pclk),
        //         .CE (1'b1),
        //         .D1 (1'b1),
        //         .D2 (1'b0),
        //         .R  (1'b0),
        //         .S  (1'b0)
        // );

        internal_reset my_internal_reset
        (
                .pclk   (pclk),
                .locked (locked),
                .reset_out (reset)
        );
        // MouseCtl my_MouseCtl
        // (
        //         .clk (clk100MHz),
        //         .rst (reset),
                
        //         .value (12'b0),
        //         .setx  (1'b0),
        //         .sety  (1'b0),
        //         .setmax_x (1'b0),
        //         .setmax_y (1'b0),
        //         .ps2_clk (ps2_clk), 
        //         .ps2_data (ps2_data),
        //         .xpos (xpos),
        //         .ypos (ypos),
        //         .left (mouse_left),
        //         .zpos (),
	//         .middle (),
	//         .right (),
	//         .new_event ()
        // );

        // position_memory my_position_memory
        // (
        //         .pclk (pclk),
        //         .rst (reset),

        //         .xpos_in (xpos),
        //         .ypos_in (ypos),
        //         .mouse_left_in (mouse_left),
        //         .xpos_out (xpos_mem),
        //         .ypos_out (ypos_mem),
        //         .mouse_left_out (mouse_left_mem)
        
        // );
        // draw_rect_ctl my_draw_rect_ctl
        // (
        //         .pclk (pclk),
        //         .rst (reset),

        //         .mouse_xpos (xpos_mem),
        //         .mouse_ypos (ypos_mem),
        //         .mouse_left (mouse_left_mem),

        //         .xpos (xpos_ctl),
        //         .ypos (ypos_ctl)
        // );
        // Instantiate the vga_timing module

        // vga_timing my_timing (
        //         .pclk (pclk),
        //         .rst (reset),
                
        //         .vcount (vcount),
        //         .vsync  (vsync),
        //         .vblnk  (vblnk),
        //         .hcount (hcount),
        //         .hsync  (hsync),
        //         .hblnk  (hblnk)
        // );

        // draw_background my_draw_background 
        // (
        //         .pclk(pclk),
        //         .rst (reset),

        //         .vcount_in (vcount),
        //         .vsync_in  (vsync),
        //         .vblnk_in  (vblnk),
        //         .hcount_in (hcount),
        //         .hsync_in  (hsync),
        //         .hblnk_in  (hblnk),

        //         .vcount_out (vcount_out_b),
        //         .vsync_out  (vsync_out_b),
        //         .vblnk_out  (vblnk_out_b),
        //         .hcount_out (hcount_out_b),
        //         .hsync_out  (hsync_out_b),
        //         .hblnk_out  (hblnk_out_b),
        //         .rgb_out    (rgb_out_b)
        // );
        // top_draw_rect my_top_draw_rect 
        // (
        //         .pclk (pclk),
        //         .rst  (reset),

        //         .xpos (xpos_ctl),
        //         .ypos (ypos_ctl),

        //         .vcount_in (vcount_out_b),
        //         .vsync_in  (vsync_out_b),
        //         .vblnk_in  (vblnk_out_b),
        //         .hcount_in (hcount_out_b),
        //         .hsync_in  (hsync_out_b),
        //         .hblnk_in  (hblnk_out_b),
        //         .rgb_in    (rgb_out_b),

        //         .vcount_out (vcount_out),
        //         .vsync_out  (vsync_out),
        //         .vblnk_out  (vblnk_out),
        //         .hcount_out (hcount_out),
        //         .hsync_out  (hsync_out),
        //         .hblnk_out  (hblnk_out),
        //         .rgb_out    (rgb_out)
        // );

        // top_draw_rect_char #(
        //         .XPOS (128),
        //         .YPOS (99)
        // ) my_top_draw_rect_char 
        // (
        //         .pclk (pclk),
        //         .rst  (reset),

        //         .vcount_in (vcount_out),
        //         .vsync_in  (vsync_out),
        //         .vblnk_in  (vblnk_out),
        //         .hcount_in (hcount_out),
        //         .hsync_in  (hsync_out),
        //         .hblnk_in  (hblnk_out),
        //         .rgb_in    (rgb_out),

        //         .vcount_out (vcount_out_d),
        //         .vsync_out  (vsync_out_d),
        //         .vblnk_out  (vblnk_out_d),
        //         .hcount_out (hcount_out_d),
        //         .hsync_out  (hsync_out_d),
        //         .hblnk_out  (hblnk_out_d),
        //         .rgb_out    (rgb_out_d)
        // );

        // top_MouseDisplay my_top_MouseDisplay
        // (
        //         .pclk (pclk),
                
        //         .xpos (xpos_mem),
        //         .ypos (ypos_mem),

        //         .vcount_in (vcount_out_d),
        //         .vsync_in  (vsync_out_d),
        //         .vblnk_in  (vblnk_out_d),
        //         .hcount_in (hcount_out_d),
        //         .hsync_in  (hsync_out_d),
        //         .hblnk_in  (hblnk_out_d),
        //         .rgb_in    (rgb_out_d),

        //         .hsync_out (hsync_out_M),
        //         .vsync_out (vsync_out_M),

        //         .red_out   (red_out),
        //         .green_out (green_out),
        //         .blue_out  (blue_out)
        // ); 

        // Synchronical logic
        // always @(posedge pclk) begin
        //         // Just pass these through.
        //         hs <= hsync_out_b;
        //         vs <= vsync_out_b;

        //         r  <= rgb_out_b[11:8];
        //         g  <= rgb_out_b[7:4];
        //         b  <= rgb_out_b[3:0];
        // end
endmodule
