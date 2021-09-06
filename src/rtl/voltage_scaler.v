// File: voltage_scaler.v
// This is the FSM for pmodAD2 that reads data from all channels

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module voltage_scaler (
                input wire clk,
                input wire rst,
                input wire [11:0] in,

                output reg [11:0] out
                
        );
        reg [11:0] out_nxt,out_pipe_nxt;
        reg [26:0] out_pipe_2,out_pipe_2_nxt;
        reg [21:0] out_pipe_22,out_pipe_22_nxt;
        reg [31:0] out_pipe_21,out_pipe_21_nxt;

        always @(posedge clk) begin
                if(rst) begin
                        out_pipe_2 <= 32'b0;
                        out <= 12'b0;
                end else begin
                        out_pipe_2 <= out_pipe_2_nxt;
                        out_pipe_21 <= out_pipe_21_nxt;
                        out_pipe_22 <= out_pipe_22_nxt;
                        out <= out_nxt;
                end
        end

        always @* begin
            out_pipe_nxt = in;
            out_pipe_2_nxt = out_pipe_nxt * 25_177;
            out_pipe_21_nxt = out_pipe_2 * 32;
            out_pipe_22_nxt = out_pipe_21 / 1_000;
            out_nxt = out_pipe_22 / 1_000;
            
        end


endmodule