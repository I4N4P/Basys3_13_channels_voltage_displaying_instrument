// File: internal_reset.v
// This is the module design for Lab #3.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module internal_reset (
        input   wire clk,
        input   wire locked,
        output  reg  reset_out
        );

        reg [6:0] counter,counter_nxt;
        reg reset_nxt = 1'b0;

        always @(negedge clk or negedge locked) begin
                if(!locked) begin
                        counter <= 7'b0;
                end else begin 
                        counter <= counter_nxt;
                end
                reset_out <= reset_nxt;
        end

        always @* begin
                if (counter < 10) begin
                        counter_nxt = counter + 1;
                        reset_nxt = 1'b1;
                end else begin
                        counter_nxt = counter;
                        reset_nxt = 1'b0;
                end
        end
        
endmodule
