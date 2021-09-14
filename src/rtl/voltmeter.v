//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         08.08.2021 
// Design Name:         voltmeter
// Module Name:         voltmeter
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This is the top level module for whole project.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Revision 0.02 - vga  Added
// Revision 0.03 - adc  Added
// Additional Comments:         using Verilog-2001 syntax.
//
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
// 
//              
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

`include "_vga_macros.vh"
`include "_adc_macros.vh"

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

        wire [`ADC_BUS_SIZE-1:0] adc_bus;

        `ADC_OUT_WIRE
        `ADC_MERGE_OUTPUT(adc_bus)

        internal_adc my_internal_adc 
        (
                .clk (clk_65MHz),
                .rst (reset),

                .iadcp (iadcp),
                .iadcn (iadcn),
                .vp_in (vp_in),
                .vn_in (vn_in),

                .dout (dout)
        );

/*******************EXTERNAL_ADC*********************************/
        
        wire AD2_SCL_JX [0:2];
        wire AD2_SDA_JX [0:2];
        
        genvar    i;
        generate
                for (i = 0; i < 3 ; i = i + 1 ) begin
                        external_adc external_adc_JX(
                                .clk (clk_65MHz),
                                .rst (reset),

                                .AD2_SCL (AD2_SCL_JX[i]), 
                                .AD2_SDA (AD2_SDA_JX[i]),
                                
                                .adc_out (adc_out[i])    
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

                .adc_in (adc_bus),

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
                .rst (reset),

                .wr_uart (tick), 
                .w_data (uart_data),
                .tx_full (), 
                .tx (tx_w)
        );

        always @(posedge clk_65MHz) begin
                if(uart_enable)
                        tx <= tx_w;
                else    
                        tx <= 8'h0;
        end

/*******************VGA_CONTROL*********************************/


        wire [`VGA_BUS_SIZE-1:0] vga_bus [0:3];

        vga_timing my_timing 
        (
                .clk (clk_65MHz),
                .rst (reset),

                .vga_out (vga_bus[0])
        );

        vga_draw_background my_vga_draw_background 
        (
                .clk(clk_65MHz),
                .rst (reset),

                .vga_in (vga_bus[0]),

                .vga_out (vga_bus[1])
        );
       
        vga_top_draw_char 
        #(
                .XPOS (125),
                .YPOS (99)
        ) 
        my_top_draw_char 
        (
                .clk (clk_65MHz),
                .rst  (reset),

                .adc_in (adc_bus),

                .vga_in (vga_bus[1]),

                .vsync_out (vga_bus[2][37]),
                .hsync_out (vga_bus[2][36]),
                .rgb_out   (vga_bus[2][35:24])
        );

        // Synchronical logic
        always @(posedge clk_65MHz) begin
                // Just pass these through.
                hs <= vga_bus[2][36];
                vs <= vga_bus[2][37];

                r  <= vga_bus[2][35:32];
                g  <= vga_bus[2][31:28];
                b  <= vga_bus[2][27:24];
        end
endmodule
