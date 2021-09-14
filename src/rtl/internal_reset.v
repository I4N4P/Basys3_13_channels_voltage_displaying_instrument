//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         08.05.2021 
// Design Name:         internal_reset
// Module Name:         internal_reset
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         this module provide reset for whole project
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Revision 0.02 - Removes Counter
// Additional Comments:         using Verilog-2001 syntax.
//
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
// 
//              
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module internal_reset (
                input   wire clk,
                input   wire locked,
                
                output  reg  reset_out
        );

        always @(negedge clk or negedge locked) begin
                if(!locked) begin
                        reset_out <= 1'b1;
                end else begin 
                        reset_out <= 1'b0;
                end
        end
endmodule
