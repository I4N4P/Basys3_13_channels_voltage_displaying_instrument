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

        output reg vs,
        output reg hs,
        output reg [3:0] r,
        output reg [3:0] g,
        output reg [3:0] b,
        output wire pclk_mirror,


        input iadcp1,
    input iadcn1,
    input vp_in,
    input vn_in,
    output reg [15:0] led,
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





         wire enable;  
    wire ready;
    wire [15:0] data;   
    reg [6:0] Address_in;
	
	//secen segment controller signals
    reg [32:0] count;
    localparam S_IDLE = 0;
    localparam S_FRAME_WAIT = 1;
    localparam S_CONVERSION = 2;
    reg [1:0] state = S_IDLE;
    reg [15:0] sseg_data;
	
	//binary to decimal converter signals
    reg b2d_start;
    reg [15:0] b2d_din;
    wire [15:0] b2d_dout;
    wire b2d_done;

    //xadc instantiation connect the eoc_out .den_in to get continuous conversion
    xadc_wiz_0  XLXI_7 (
        .daddr_in(8'h16), //addresses can be found in the artix 7 XADC user guide DRP register space
        .dclk_in(clk100Mhz), 
        .den_in(enable), 
        .di_in(0), 
        .dwe_in(0), 
        .busy_out(),                    
        .vauxp6(iadcp1),
        .vauxn6(iadcn1),
        .vauxp7(),
        .vauxn7(),
        .vauxp14(),
        .vauxn14(),
        .vauxp15(),
        .vauxn15(),
        .vn_in(vn_in), 
        .vp_in(vp_in), 
        .alarm_out(), 
        .do_out(data), 
        //.reset_in(),
        .eoc_out(enable),
        .channel_out(),
        .drdy_out(ready)
    );
    
    //led visual dmm              
    always @(posedge(clk100Mhz)) begin            
        if(ready == 1'b1) begin
            case (data[15:12])
            1:  led <= 16'b11;
            2:  led <= 16'b111;
            3:  led <= 16'b1111;
            4:  led <= 16'b11111;
            5:  led <= 16'b111111;
            6:  led <= 16'b1111111; 
            7:  led <= 16'b11111111;
            8:  led <= 16'b111111111;
            9:  led <= 16'b1111111111;
            10: led <= 16'b11111111111;
            11: led <= 16'b111111111111;
            12: led <= 16'b1111111111111;
            13: led <= 16'b11111111111111;
            14: led <= 16'b111111111111111;
            15: led <= 16'b1111111111111111;                        
            default: led <= 16'b1; 
            endcase
        end
    end
    
    //binary to decimal conversion
    always @ (posedge(clk100Mhz)) begin
        case (state)
        S_IDLE: begin
            state <= S_FRAME_WAIT;
            count <= 'b0;
        end
        S_FRAME_WAIT: begin
            if (count >= 10000000) begin
                if (data > 16'hFFD0) begin
                    sseg_data <= 16'h1000;
                    state <= S_IDLE;
                end else begin
                    b2d_start <= 1'b1;
                    b2d_din <= data;
                    state <= S_CONVERSION;
                end
            end else
                count <= count + 1'b1;
        end
        S_CONVERSION: begin
            b2d_start <= 1'b0;
            if (b2d_done == 1'b1) begin
                sseg_data <= b2d_dout;
                state <= S_IDLE;
            end
        end
        endcase
    end
    
    bin2dec m_b2d (
        .clk(clk100Mhz),
        .start(b2d_start),
        .din(b2d_din),
        .done(b2d_done),
        .dout(b2d_dout)
    );
      
    //always @(posedge(clk)) begin
    //    case(sw)
    //    0: Address_in <= 8'h16;
    //    1: Address_in <= 8'h17;
    //    2: Address_in <= 8'h1e;
    //    3: Address_in <= 8'h1f;
    //    endcase
    //end
    
    DigitToSeg segment1(
        .in1(sseg_data[3:0]),
        .in2(sseg_data[7:4]),
        .in3(sseg_data[11:8]),
        .in4(sseg_data[15:12]),
        .in5(),
        .in6(),
        .in7(),
        .in8(),
        .mclk(clk100Mhz),
        .an(an),
        .dp(dp),
        .seg(seg)
    );

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

        ODDR pclk_oddr 
        (
                .Q  (pclk_mirror),
                .C  (pclk),
                .CE (1'b1),
                .D1 (1'b1),
                .D2 (1'b0),
                .R  (1'b0),
                .S  (1'b0)
        );

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

        vga_timing my_timing (
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
        always @(posedge pclk) begin
                // Just pass these through.
                hs <= hsync_out_b;
                vs <= vsync_out_b;

                r  <= rgb_out_b[11:8];
                g  <= rgb_out_b[7:4];
                b  <= rgb_out_b[3:0];
        end
endmodule
