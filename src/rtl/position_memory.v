// File: internal_reset.v
// This is the top level design for lab #3
// this module changes frequency of signals
// that belongs to Mousectl from 100MHz to 40Mhz .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module position_memory (
        input wire pclk,
        input wire rst,
        
        input wire [11:0] xpos_in,
        input wire [11:0] ypos_in,
        input wire  mouse_left_in,
        output reg [11:0] xpos_out,
        output reg [11:0] ypos_out,
        output reg  mouse_left_out
        );


        always @(posedge pclk) begin
                if(rst) begin
                        xpos_out <= 12'b0;
                        ypos_out <= 12'b0;
                        mouse_left_out <= 1'b0;
                end else begin
                        xpos_out <= xpos_in;
                        ypos_out <= ypos_in;
                        mouse_left_out <= mouse_left_in;
                end
        end
endmodule
