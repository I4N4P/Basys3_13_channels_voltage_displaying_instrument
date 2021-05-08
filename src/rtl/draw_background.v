// File: draw_background.v
// This module generate the backround for vga

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_background (
        input   wire pclk,
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

        always @(posedge pclk) begin
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
                        // Active display, top edge, make a yellow line.
                        if (vcount_in == 0) rgb_out_nxt = 12'hf_f_0;
                        // Active display, bottom edge, make a red line.
                        else if (vcount_in == 599) rgb_out_nxt = 12'hf_0_0;
                        // Active display, left edge, make a green line.
                        else if (hcount_in == 0) rgb_out_nxt = 12'h0_f_0;
                        // Active display, right edge, make a blue line.
                        else if (hcount_in == 799) rgb_out_nxt = 12'h0_0_f;
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
