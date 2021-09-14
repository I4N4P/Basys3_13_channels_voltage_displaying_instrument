//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         15.04.2021 
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
                        // Active display, top edge, make a yellow line.
                        if (vcount_in == 0) rgb_out_nxt = 12'hf_f_0;
                        // Active display, bottom edge, make a red line.
                        else if (vcount_in == 767) rgb_out_nxt = 12'hf_0_0;
                        // Active display, left edge, make a green line.
                        else if (hcount_in == 0) rgb_out_nxt = 12'h0_f_0;
                        // Active display, right edge, make a blue line.
                        else if (hcount_in == 1023) rgb_out_nxt = 12'h0_0_f;
                        // Active display, interior, fill with gray.
                        else if (hcount_in >= 100 && vcount_in >= 50 && hcount_in <= 150 && vcount_in <= 550 
                        || hcount_in >= 100+ vcount_in -50 && vcount_in >= 50&& vcount_in <= 200&& hcount_in  <= (100+ vcount_in)
                        || hcount_in >= 250 && vcount_in > 200&& vcount_in <= 400&& hcount_in  <= 300|| hcount_in >= 250- vcount_in +400 && vcount_in > 400&& vcount_in <= 550&& hcount_in  <= (300- vcount_in+400)
                        || hcount_in >= 400 && vcount_in >= 50 && hcount_in <= 600 && vcount_in <= 100|| hcount_in >= 400 && vcount_in >= 100 && hcount_in <= 450 && vcount_in <= 275 
                        || hcount_in >= 400 && vcount_in >=275 && hcount_in <= 600 && vcount_in <= 325 || hcount_in >= 550 && vcount_in >= 325 && hcount_in <= 600 && vcount_in <= 500
                        || hcount_in >= 400 && vcount_in >= 500 && hcount_in <= 600 && vcount_in <= 550) rgb_out_nxt = 12'h4_4_f;
                        else rgb_out_nxt = 12'h8_8_8;    
                end
        end

endmodule
