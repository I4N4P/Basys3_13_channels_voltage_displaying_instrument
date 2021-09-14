//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         15:20:14 03/09/2021
// Design Name:         voltage_scaler
// Module Name:         voltage_scaler
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         module that scales data from pmods.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Revision 0.02 - Add Prameter
// Additional Comments:         using Verilog-2001 syntax.
//
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
// 
//              
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module voltage_scaler #(
                parameter MUL = 812
        )(
                input wire clk,
                input wire rst,
                input wire [11:0] in,

                output reg [11:0] out
                
        );
        //(* keep = 1 *) reg [21:0] out_pipe_2;  // attemp to solve problem with pipelining 
        reg [11:0] out_nxt,out_pipe_nxt;
        reg [21:0] out_pipe_2,out_pipe_2_nxt;
        //reg [21:0] out_pipe_20,out_pipe_20_nxt;

        always @(posedge clk) begin
                if(rst) begin
                        out_pipe_2      <= 22'b0;
                        out             <= 12'b0;
                end else begin
                        out_pipe_2      <= out_pipe_2_nxt;
                        //out_pipe_20      <= out_pipe_20_nxt;
                        out             <= out_nxt;
                end
        end

        always @* begin
                out_pipe_nxt = in;
                out_pipe_2_nxt = out_pipe_nxt * MUL;
                //out_pipe_20_nxt = $signed(out_pipe_2);
                out_nxt = out_pipe_2 / 1_000;
            
        end

endmodule