//////////////////////////////////////////////////////////////////////////////////
//
// https://upel2.cel.agh.edu.pl/weaiib/course/view.php?id=1121
// 
// (C) Copyright 2016 AGH UST All Rights Reserved
//
// Company: AGH_University
// Engineer: not known
// 
// Create Date:         2016 
// Design Name:         mod_m_counter
// Module Name:         mod_m_counter
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This module is used by uart.
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
// Listing 4.11
//              
//////////////////////////////////////////////////////////////////////////////////

module mod_m_counter #(
                parameter N = 4, // number of bits in counter
                          M = 10 // mod-M
        )
        (
                input wire clk, reset,
                output wire max_tick,
                output wire [N-1:0] q
        );

        //signal declaration
        reg [N-1:0] r_reg;
        wire [N-1:0] r_next;

        // body
        // register
        always @(posedge clk) begin
                if (reset)
                        r_reg <= 0;
                else
                        r_reg <= r_next;
        end
        
        // next-state logic
        assign r_next = (r_reg==(M-1)) ? 0 : r_reg + 1;
        // output logic
        assign q = r_reg;
        assign max_tick = (r_reg==(M-1)) ? 1'b1 : 1'b0;

endmodule
