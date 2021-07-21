// File: uart_monitor.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module uart_monitor (
                input wire clk,
                input wire reset,

                input wire btn,
                input wire rx, 
                input wire loopback_enable, 
                
                output reg tx, 
                output reg rx_monitor, 
                output reg tx_monitor,

                output wire [3:0] an,
                output wire [7:0] seg
        );

        wire clk_100MHz,clk_50MHz;
        wire rst,locked;

        wire tx_full, rx_empty, btn_tick,tx_w;
        wire [7:0] rec_data;

        reg [15:0] data,data_nxt = 16'b0;
        reg tick,tick_nxt = 1'b0;
        reg flag,flag_nxt;

        gen_clock my_gen_clock 
        (
                .clk (clk),
                .reset (reset),

                .clk_100MHz (clk_100MHz),
                .clk_50MHz (clk_50MHz),            
                .locked (locked)
        );

        internal_reset my_internal_reset 
        (
                .clk   (clk_50MHz),
                .locked (locked),

                .reset_out (rst)
        );

        uart my_uart 
        (
                .clk (clk_50MHz),
                .reset (rst),

                .rd_uart (tick),
                .wr_uart (btn_tick), 
                .rx (rx), 
                .w_data (data[7:0]),

                .tx_full (tx_full), 
                .rx_empty (rx_empty),
                .r_data (rec_data), 
                .tx (tx_w)
        );

        debounce my_btn_sig
        (
                .clk (clk_50MHz), 
                .reset (rst), 
              
                .sw (btn),

                .db_level (), 
                .db_tick (btn_tick)
        );

        disp_hex_mux my_disp_hex_data
        ( 
                .clk (clk_50MHz), 
                .reset (rst),

                .hex3 (data[15:12]), 
                .hex2 (data[11:8]), 
                .hex1 (data[7:4]), 
                .hex0 (data[3:0]),
                .dp_in (4'b1011),

                .an (an), 
                .sseg (seg)
        );

        // display and send ASCII synchronical logic

        always @ (posedge clk_50MHz) begin
                if (rst) begin 
                        data <= 8'b0;
                        tick <= 1'b0;
                        flag <= 1'b0;
                end else begin
                        data <= data_nxt;
                        tick <=tick_nxt;
                        flag <= flag_nxt;
                end      
        end

        // display and send ASCII combinational logic

        always @ * begin
                tick_nxt = 1'b0;
                if (rx_empty == 0) begin
                        if (flag)
                                data_nxt = {data[7:0],rec_data};
                        else
                                data_nxt = data;
                        flag_nxt = 1'b0;
                        tick_nxt = 1'b1;
                end else begin
                        flag_nxt = 1'b1;
                        data_nxt = data;    
                end 
        end

        // monitor synchronical logic

        always @ (posedge clk_100MHz) begin
                if (rst) begin 
                        rx_monitor <= 1'b0;
                        tx_monitor <= 1'b0;
                        tx         <= 1'b0;
                end else begin
                        if (loopback_enable)
                                tx <= rx;
                        else
                                tx <= tx_w;
                        rx_monitor <= rx;
                        tx_monitor <= tx;    
                        
                end      
        end

endmodule
