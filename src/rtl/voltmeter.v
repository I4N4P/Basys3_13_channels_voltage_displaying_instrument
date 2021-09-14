// File: vga_example.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module voltmeter (
                input wire clk,
                input wire rst,

                input uart_enable,
                
                input iadcp,
                input iadcn,
                input vp_in,
                input vn_in,

                inout wire AD2_SCL_JA, 
                inout wire AD2_SDA_JA,
                inout wire AD2_SCL_JB, 
                inout wire AD2_SDA_JB,
                inout wire AD2_SCL_JC, 
                inout wire AD2_SDA_JC,

                output reg vs,
                output reg hs,
                output reg [3:0] r,
                output reg [3:0] g,
                output reg [3:0] b,
                output reg tx
        );

/*******************CLOCK_GENERATION*********************************/

        wire clk100Mhz;
        wire clk_65MHz;
        wire locked;


        clk_generator my_clk_generator
        (
                .clk (clk),
                .reset (rst),
                
                .clk_65MHz (clk_65MHz),
                .locked (locked)
        );

/*******************RESET_GENERATION*********************************/

        wire reset;

        internal_reset my_internal_reset
        (
                .clk    (clk_65MHz),
                .locked (locked),

                .reset_out (reset)
        );

/*******************INTERNAL_ADC*********************************/		

        wire [15:0] bcd [0:12];

        internal_adc my_internal_adc 
        (
                .clk (clk_65MHz),
                .rst (reset),

                .iadcp (iadcp),
                .iadcn (iadcn),
                .vp_in (vp_in),
                .vn_in (vn_in),

                .dout (bcd[0])
        );

/*******************EXTERNAL_ADC*********************************/
        
        wire AD2_SCL_JX [0:2];
        wire AD2_SDA_JX [0:2];
        
        genvar    i;
        generate
                for (i = 0; i < 3 ; i = i + 1 ) begin
                        external_adc external_adc_JX(
                                .clk(clk_65MHz),
                                .rst(reset),

                                .AD2_SCL (AD2_SCL_JX[i]), 
                                .AD2_SDA (AD2_SDA_JX[i]),
                                
                                .channel0(bcd[(4 * i) + 1]),
                                .channel1(bcd[(4 * i) + 2]),
                                .channel2(bcd[(4 * i) + 3]),
                                .channel3(bcd[(4 * i) + 4])     
                        );
                end
        endgenerate

        assign {AD2_SCL_JA,AD2_SDA_JA} = {AD2_SCL_JX[0],AD2_SDA_JX[0]};
        assign {AD2_SCL_JB,AD2_SDA_JB} = {AD2_SCL_JX[1],AD2_SDA_JX[1]};
        assign {AD2_SCL_JC,AD2_SDA_JC} = {AD2_SCL_JX[2],AD2_SDA_JX[2]};

/*******************UART_MODULE*********************************/
        
        wire tx_w;
        wire tick;
        wire [7:0] uart_data;

        uart_control my_uart_control
        (
                .clk (clk_65MHz),
                .rst (reset),

                .in0 (bcd[0]),
                .in1 (bcd[1]),
                .in2 (bcd[2]),
                .in3 (bcd[3]),
                .in4 (bcd[4]),
                .in5 (bcd[5]),
                .in6 (bcd[6]),
                .in7 (bcd[7]),
                .in8 (bcd[8]),
                .in9 (bcd[9]),
                .in10 (bcd[10]),
                .in11 (bcd[11]),
                .in12 (bcd[12]),
                .sign (uart_data),
                .tick (tick)        
        );

        uart 
        #(
                .DBIT (8),     
                .SB_TICK (16),                   
                .DVSR (212),   
                .DVSR_BIT (9), 
                .FIFO_W (8)    
        )
        my_uart 
        (
                .clk (clk_65MHz),
                .reset (reset),
                .wr_uart (tick), 
                .w_data (uart_data),
                .tx_full (), 
                .tx (tx_w)
        );

        always @(posedge clk_65MHz) begin
                if(uart_enable)
                        tx <= tx_w;
        end

/*******************VGA_CONTROL*********************************/

        wire vsync, hsync,vsync_out_b, hsync_out_b, vsync_out_c, hsync_out_c;
        wire vblnk, hblnk,vblnk_out_b, hblnk_out_b, vblnk_out_c, hblnk_out_c;
        wire hblnk_out_d, vblnk_out_d, hsync_out_d, vsync_out_d;
        wire [11:0] vcount, hcount,vcount_out_b, hcount_out_b,vcount_out_c, hcount_out_c, vcount_out_d, hcount_out_d;
        wire [11:0] rgb_out_b, rgb_out_c, rgb_out_d; 

        vga_timing my_timing 
        (
                .clk (clk_65MHz),
                .rst (reset),
                
                .vcount (vcount),
                .vsync  (vsync),
                .vblnk  (vblnk),
                .hcount (hcount),
                .hsync  (hsync),
                .hblnk  (hblnk)
        );

   
        vga_draw_background my_vga_draw_background 
        (
                .clk(clk_65MHz),
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
        
        top_draw_rect my_top_draw_rect
                (
                .pclk(clk_65MHz),
                .rst (reset),
                .xpos (12'b0),
                .ypos (12'b0),

                .vcount_in (vcount_out_b),
                .vsync_in  (vsync_out_b),
                .vblnk_in  (vblnk_out_b),
                .hcount_in (hcount_out_b),
                .hsync_in  (hsync_out_b),
                .hblnk_in  (hblnk_out_b),

                .vcount_out (vcount_out_d),
                .vsync_out  (vsync_out_d),
                .vblnk_out  (vblnk_out_d),
                .hcount_out (hcount_out_d),
                .hsync_out  (hsync_out_d),
                .hblnk_out  (hblnk_out_d),
                .rgb_in (rgb_out_b),
                .rgb_out    (rgb_out_d)
        );
       
        vga_top_draw_char 
        #(
                .XPOS (464),
                .YPOS (99)
        ) 
        my_top_draw_char 
        (
                .clk (clk_65MHz),
                .rst  (reset),

                .in0 (bcd[0]),
                .in1 (bcd[1]),
                .in2 (bcd[2]),
                .in3 (bcd[3]),
                .in4 (bcd[4]),
                .in5 (bcd[5]),
                .in6 (bcd[6]),
                .in7 (bcd[7]),
                .in8 (bcd[8]),
                .in9 (bcd[9]),
                .in10 (bcd[10]),
                .in11 (bcd[11]),
                .in12 (bcd[12]),

                .vcount_in (vcount_out_d),
                .vsync_in  (vsync_out_d),
                .vblnk_in  (vblnk_out_d),
                .hcount_in (hcount_out_d),
                .hsync_in  (hsync_out_d),
                .hblnk_in  (hblnk_out_d),
                .rgb_in    (rgb_out_d),

                .vsync_out  (vsync_out_c),
                .hsync_out  (hsync_out_c),
                .rgb_out    (rgb_out_c)
        );

        // Synchronical logic
        always @(posedge clk_65MHz) begin
                // Just pass these through.
                hs <= hsync_out_c;
                vs <= vsync_out_c;

                r  <= rgb_out_c[11:8];
                g  <= rgb_out_c[7:4];
                b  <= rgb_out_c[3:0];
        end
endmodule
