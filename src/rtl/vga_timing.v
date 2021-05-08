// File: vga_timing.v
// This is the vga timing design for Lab #3 generats
// signals that control the screen .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps
// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
        input  wire pclk,
        input  wire rst,

        output wire [11:0] vcount,
        output wire vsync, 
        output wire vblnk, 
        output wire [11:0] hcount,
        output wire hsync,  
        output wire hblnk  
        );

        localparam HOR_TOTAL_TIME = 1055;
        localparam VER_TOTAL_TIME = 627;
        localparam HOR_BLANK_START = 799;
        localparam VER_BLANK_START = 599;
        localparam HOR_SYNC_START = 839;
        localparam VER_SYNC_START = 600;
        localparam HOR_SYNC_TIME = 128;
        localparam VER_SYNC_TIME = 4;

        reg [11:0] horizontal_counter = 12'b0;
        reg [11:0] vertical_counter= 12'b0;
        reg horizontal_sync = 1'b0;
        reg horizontal_blank = 1'b0;
        reg vertical_sync = 1'b0;
        reg vertical_blank = 1'b0;

        reg [11:0] horizontal_counter_nxt;
        reg [11:0] vertical_counter_nxt;
        reg horizontal_sync_nxt ; 
        reg horizontal_blank_nxt ;
        reg vertical_sync_nxt ;
        reg vertical_blank_nxt ;

        // Describe the actual circuit for the assignment.
        // Video timing controller set for 800x600@60fps
        // using a 40 MHz pixel clock per VESA spec.
        
        // Synchronical logic
        always @(posedge pclk) begin
                if(rst) begin
                        horizontal_blank <=  1'b0;
                        vertical_blank   <=  1'b0;
                        horizontal_sync  <=  1'b0;
                        vertical_sync    <=  1'b0;
                        vertical_counter <=  12'b0;
                        horizontal_counter<= 12'b0;
                end else begin
                        horizontal_blank <=horizontal_blank_nxt;
                        vertical_blank <=vertical_blank_nxt;
                        horizontal_sync <= horizontal_sync_nxt;
                        vertical_sync <= vertical_sync_nxt;
                        horizontal_counter <= horizontal_counter_nxt;
                        vertical_counter <= vertical_counter_nxt;
                        
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
                if(vertical_counter >= VER_BLANK_START && vertical_counter < VER_TOTAL_TIME)
                        vertical_blank_nxt = 1'b1; 
                else
                        vertical_blank_nxt = 1'b0; 
                if(vertical_counter >= VER_SYNC_START && vertical_counter < (VER_SYNC_START + VER_SYNC_TIME))
                        vertical_sync_nxt = 1'b1;
                else
                        vertical_sync_nxt = 1'b0;
        end else begin
                horizontal_counter_nxt = horizontal_counter + 1;
                vertical_counter_nxt = vertical_counter;
                vertical_blank_nxt =vertical_blank;
                vertical_sync_nxt =vertical_sync;
        end
        if(horizontal_counter >= HOR_BLANK_START && horizontal_counter < HOR_TOTAL_TIME)
                horizontal_blank_nxt = 1'b1; 
        else
                horizontal_blank_nxt = 1'b0;   
        if(horizontal_counter >= HOR_SYNC_START && horizontal_counter < (HOR_SYNC_START + HOR_SYNC_TIME ))
                horizontal_sync_nxt = 1'b1;
        else
                horizontal_sync_nxt = 1'b0;
        end

        assign   hcount = horizontal_counter;
        assign   vcount = vertical_counter;
        assign   hblnk  = horizontal_blank;
        assign   vblnk  = vertical_blank;
        assign   hsync  = horizontal_sync;
        assign   vsync  = vertical_sync;

endmodule
