// File: signal_synchronizer.v
// This module dealys signals per one clk tic.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module signal_synchronizer (
        input   wire pclk,
        input   wire rst,
        

        input   wire [11:0] vcount_in,
        input   wire vsync_in, 
        input   wire vblnk_in, 
        input   wire [11:0] hcount_in,
        input   wire hsync_in, 
        input   wire hblnk_in, 
        input   wire [11:0] rgb_in,

        output  reg [11:0] vcount_out,
        output  reg vsync_out, 
        output  reg vblnk_out, 
        output  reg [11:0] hcount_out,
        output  reg hsync_out, 
        output  reg hblnk_out, 
        output  reg [11:0] rgb_out
        );

        always @(posedge pclk) begin
                // pass these through if rst not activ then put 0 on the output.
                if (rst) begin
                        vcount_out <= 12'b0;
                        hcount_out <= 12'b0;
                        vsync_out  <= 1'b0;
                        vblnk_out  <= 1'b0; 
                        hsync_out  <= 1'b0;
                        hblnk_out  <= 1'b0; 
                        rgb_out    <= 12'h0_0_0;
                end else begin
                        vcount_out <= vcount_in;
                        hcount_out <= hcount_in;

                        vsync_out  <= vsync_in;
                        hsync_out  <= hsync_in;
                        
                        vblnk_out  <= vblnk_in; 
                        hblnk_out  <= hblnk_in;
                        rgb_out    <= rgb_in;
                        

                end
        end


endmodule
