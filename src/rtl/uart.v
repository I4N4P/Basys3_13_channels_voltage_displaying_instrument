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
// Design Name:         uart
// Module Name:         uart
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This top module for uart modules.
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
// Listing 8.4
//              
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module uart #( // Default setting:
        // 19,200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
        parameter 
                DBIT = 8,     // # data bits
                SB_TICK = 16, // # ticks for stop bits, 16/24/32
                        // for 1/1.5/2 stop bits
                DVSR = 163,   // baud rate divisor
                        // DVSR = 50M/(16*baud rate)
                DVSR_BIT = 8, // # bits of DVSR
                FIFO_W = 4    // # addr bits of FIFO
                        // # words in FIFO=2^FIFO_W
        )(
                input wire clk, rst,
                input wire wr_uart,
                input wire [7:0] w_data,
                output wire tx_full, tx
        );

        // signal declaration
        wire tick, rx_done_tick, tx_done_tick;
        wire tx_empty, tx_fifo_not_empty;
        wire [7:0] tx_fifo_out, rx_data_out;

        //body
        mod_m_counter #(
                .M (DVSR), 
                .N (DVSR_BIT)
        ) baud_gen_unit (
                .clk (clk), 
                .reset (rst), 
                .q (), 
                .max_tick (tick)
        );

        fifo #(
                .B (DBIT), 
                .W (FIFO_W)
        ) fifo_tx_unit (
                .clk (clk), 
                .reset (rst), 
                .rd (tx_done_tick),
                .wr (wr_uart), 
                .w_data (w_data), 
                .empty (tx_empty),
                .full (tx_full), 
                .r_data (tx_fifo_out)
        );

        uart_tx #(
                .DBIT (DBIT), 
                .SB_TICK (SB_TICK)
        ) uart_tx_unit (
                .clk (clk), 
                .reset (rst), 
                .tx_start (tx_fifo_not_empty),
                .s_tick (tick), 
                .din (tx_fifo_out),
                .tx_done_tick (tx_done_tick), 
                .tx (tx)
        );

        assign tx_fifo_not_empty = ~tx_empty;
endmodule
