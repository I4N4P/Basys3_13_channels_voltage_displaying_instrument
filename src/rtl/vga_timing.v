//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         15.04.2021 
// Design Name:         vga_timing
// Module Name:         vga_timing
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This is the vga timing design for Lab #3 generats
// signals that control the screen .
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
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

`include "_vga_macros.vh"

module vga_timing (
                input  wire clk,
                input  wire rst,

                output  wire [`VGA_BUS_SIZE-1:0] vga_out
        );

        `VGA_OUT_WIRE
        `VGA_MERGE_OUTPUT(vga_out)

        localparam HOR_TOTAL_TIME = 1343;
        localparam VER_TOTAL_TIME = 805;
        localparam HOR_BLANK_START = 1023;
        localparam VER_BLANK_START = 767;
        localparam HOR_SYNC_START = 1047;
        localparam VER_SYNC_START = 770;
        localparam HOR_SYNC_TIME = 136;
        localparam VER_SYNC_TIME = 3;

        reg [11:0] horizontal_counter;
        reg [11:0] vertical_counter;
        reg horizontal_sync;
        reg horizontal_blank;
        reg vertical_sync;
        reg vertical_blank;

        reg [11:0] horizontal_counter_nxt;
        reg [11:0] vertical_counter_nxt;
        reg horizontal_sync_nxt ; 
        reg horizontal_blank_nxt ;
        reg vertical_sync_nxt ;
        reg vertical_blank_nxt ;
        
        // Synchronical logic
        always @(posedge clk) begin
                if(rst) begin
                        horizontal_blank   <=  1'b0;
                        vertical_blank     <=  1'b0;
                        horizontal_sync    <=  1'b0;
                        vertical_sync      <=  1'b0;
                        vertical_counter   <=  12'b0;
                        horizontal_counter <= 12'b0;
                end else begin
                        horizontal_blank   <= horizontal_blank_nxt;
                        vertical_blank     <= vertical_blank_nxt;
                        horizontal_sync    <= horizontal_sync_nxt;
                        vertical_sync      <= vertical_sync_nxt;
                        horizontal_counter <= horizontal_counter_nxt;
                        vertical_counter   <= vertical_counter_nxt;
                        
                end
        end


        // Combinational logic
        always @* begin 
        if (horizontal_counter == HOR_TOTAL_TIME) begin
                horizontal_counter_nxt = 0;
                if (vertical_counter == VER_TOTAL_TIME)
                        vertical_counter_nxt = 0;
                else
                        vertical_counter_nxt = vertical_counter + 1;
                if (vertical_counter >= VER_BLANK_START && vertical_counter < VER_TOTAL_TIME)
                        vertical_blank_nxt = 1'b1; 
                else
                        vertical_blank_nxt = 1'b0; 
                if (vertical_counter >= VER_SYNC_START && vertical_counter < (VER_SYNC_START + VER_SYNC_TIME))
                        vertical_sync_nxt  = 1'b1;
                else
                        vertical_sync_nxt  = 1'b0;
        end else begin
                horizontal_counter_nxt = horizontal_counter + 1;
                vertical_counter_nxt   = vertical_counter;
                vertical_blank_nxt     = vertical_blank;
                vertical_sync_nxt      = vertical_sync;
        end
        if (horizontal_counter >= HOR_BLANK_START && horizontal_counter < HOR_TOTAL_TIME)
                horizontal_blank_nxt = 1'b1; 
        else
                horizontal_blank_nxt = 1'b0;   
        if (horizontal_counter >= HOR_SYNC_START && horizontal_counter < (HOR_SYNC_START + HOR_SYNC_TIME ))
                horizontal_sync_nxt  = 1'b1;
        else
                horizontal_sync_nxt  = 1'b0;
        end

        assign   hcount_out = horizontal_counter;
        assign   vcount_out = vertical_counter;
        assign   hblnk_out  = horizontal_blank;
        assign   vblnk_out  = vertical_blank;
        assign   hs_out     = horizontal_sync;
        assign   vs_out     = vertical_sync;
        assign   rgb_out    = 12'hf_f_f;

endmodule
