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
// Description:         This module generate the backround for vga.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:         using Verilog-2001 syntax.
//
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
// 
// Listing 8.3
//              
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

`include "_vga_macros.vh"

module vga_draw_background (
                input   wire clk,
                input   wire rst,

                input   wire [`VGA_BUS_SIZE-1:0] vga_in,
                output  wire [`VGA_BUS_SIZE-1:0] vga_out
        );

        `VGA_SPLIT_INPUT(vga_in)
        `VGA_OUT_REG
        `VGA_MERGE_OUTPUT(vga_out)

        reg [11:0] rgb_out_nxt;
        reg [11:0] rgb_dummy;

        // Synchronical logic

        always @(posedge clk) begin
        // pass these through if rst not activ then put 0 on the output.
                if (rst) begin
                        vcount_out <= 12'b0;
                        hcount_out <= 12'b0;
                        vs_out     <= 1'b0;
                        vblnk_out  <= 1'b0; 
                        hs_out     <= 1'b0;
                        hblnk_out  <= 1'b0; 
                        rgb_out    <= rgb_in;
                end else begin
                        vcount_out <= vcount_in;
                        hcount_out <= hcount_in;
                        vs_out     <= vs_in;
                        vblnk_out  <= vblnk_in; 
                        hs_out     <= hs_in;
                        hblnk_out  <= hblnk_in; 
                        rgb_out    <= rgb_out_nxt;
                end
        end

        // Combinational logic

        always @* begin
                rgb_dummy = rgb_in;
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
