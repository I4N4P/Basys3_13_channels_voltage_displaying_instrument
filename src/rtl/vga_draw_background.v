//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Damian Herduś
// 
// Create Date:         14.09.2021 
// Design Name:         vga_draw_background
// Module Name:         vga_draw_background
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

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_draw_background (
                input   wire clk,
                input   wire rst,

                input   wire [11:0] vcount_in,
                input   wire vsync_in, 
                input   wire vblnk_in, 
                input   wire [11:0] hcount_in,
                input   wire hsync_in, 
                input   wire hblnk_in, 

                output  reg [11:0] vcount_out,
                output  reg vsync_out, 
                output  reg vblnk_out, 
                output  reg [11:0] hcount_out,
                output  reg hsync_out, 
                output  reg hblnk_out, 
                output  reg [11:0] rgb_out
        );
  
        reg [11:0] rgb_out_nxt;

        // Synchronical logic

        always @(posedge clk) begin
        // pass these through if rst not activ then put 0 on the output.
                if (rst) begin
                        vcount_out <= 12'b0;
                        hcount_out <= 12'b0;
                        vsync_out  <= 1'b0;
                        vblnk_out  <= 1'b0; 
                        hsync_out  <= 1'b0;
                        hblnk_out  <= 1'b0; 
                end else begin
                        vcount_out <= vcount_in;
                        hcount_out <= hcount_in;
                        vsync_out  <= vsync_in;
                        vblnk_out  <= vblnk_in; 
                        hsync_out  <= hsync_in;
                        hblnk_out  <= hblnk_in; 
                        rgb_out    <= rgb_out_nxt;
                end
        end

        // Combinational logic

        always @* begin
                // During blanking, make it it black.
                if (vblnk_in || hblnk_in) begin  
                        rgb_out_nxt = 12'h0_0_0; 
                end else begin

                        // M - left
                        if ((hcount_in>=300)&&(hcount_in<=320)&&(vcount_in>=635)&&(vcount_in<=720)) rgb_out_nxt <= 12'hf_b_0;
                        else if ((hcount_in>=350)&&(hcount_in<=370)&&(vcount_in>=635)&&(vcount_in<=720)) rgb_out_nxt <= 12'hf_b_0;
                        else if ((hcount_in>=320)&&(hcount_in<=335)&&(vcount_in>= hcount_in + 315)&&(vcount_in<= hcount_in + 335)) rgb_out_nxt <= 12'hf_b_0;
                        else if ((hcount_in>=335)&&(hcount_in<=350)&&(vcount_in>= -hcount_in + 985)&&(vcount_in<= -hcount_in + 1005)) rgb_out_nxt <= 12'hf_b_0;

                        // T 
                        else if ((hcount_in>=375)&&(hcount_in<=425)&&(vcount_in>=655)&&(vcount_in<=670)) rgb_out_nxt <= 12'hf_b_0;
                        else if ((hcount_in>=395)&&(hcount_in<=405)&&(vcount_in>=670)&&(vcount_in<=720)) rgb_out_nxt <= 12'hf_b_0;

                        // M - right
                        else if ((hcount_in>=430)&&(hcount_in<=450)&&(vcount_in>=635)&&(vcount_in<=720)) rgb_out_nxt <= 12'hf_b_0;
                        else if ((hcount_in>=480)&&(hcount_in<=500)&&(vcount_in>=635)&&(vcount_in<=720)) rgb_out_nxt <= 12'hf_b_0;
                        else if ((hcount_in>=450)&&(hcount_in<=465)&&(vcount_in>= hcount_in + 185)&&(vcount_in<= hcount_in + 205)) rgb_out_nxt <= 12'hf_b_0;
                        else if ((hcount_in>=465)&&(hcount_in<=480)&&(vcount_in>= -hcount_in + 1115)&&(vcount_in<= -hcount_in + 1135)) rgb_out_nxt <= 12'hf_b_0;

                        else rgb_out_nxt = 12'h1_8_9; 

                end
        end

endmodule
