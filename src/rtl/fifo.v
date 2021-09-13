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
// Design Name:         fifo
// Module Name:         fifo
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This odule is a storeage of word that will be send by uart.
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
// Listing 4.20
//              
//////////////////////////////////////////////////////////////////////////////////

module fifo
        #(
                parameter B = 8,
                          W = 4 
        )
        (
                input wire clk, reset,
                input wire rd, wr,
                input wire [B-1:0] w_data,
                output wire empty, full,
                output wire [B-1:0] r_data
        );

        //signal declaration
        reg [B-1:0] array_reg [2**W-1:0];  // register array
        reg [W-1:0] w_ptr_reg, w_ptr_next, w_ptr_succ;
        reg [W-1:0] r_ptr_reg, r_ptr_next, r_ptr_succ;
        reg full_reg, empty_reg, full_next, empty_next;
        wire wr_en;

        // body
        // register file write operation
        always @(posedge clk)
        if (wr_en)
                array_reg[w_ptr_reg] <= w_data;
        // register file read operation
        assign r_data = array_reg[r_ptr_reg];
        // write enabled only when FIFO is not full
        assign wr_en = wr & ~full_reg;

        // fifo control logic
        // register for read and write pointers
        always @(posedge clk)
                if (reset) begin
                        w_ptr_reg <= 0;
                        r_ptr_reg <= 0;
                        full_reg <= 1'b0;
                        empty_reg <= 1'b1;
                end else begin
                        w_ptr_reg <= w_ptr_next;
                        r_ptr_reg <= r_ptr_next;
                        full_reg <= full_next;
                        empty_reg <= empty_next;
                end

        // next-state logic for read and write pointers
        always @* begin
                // successive pointer values
                w_ptr_succ = w_ptr_reg + 1;
                r_ptr_succ = r_ptr_reg + 1;
                // default: keep old values
                w_ptr_next = w_ptr_reg;
                r_ptr_next = r_ptr_reg;
                full_next = full_reg;
                empty_next = empty_reg;
                case ({wr, rd})
                        // 2'b00:  no op
                2'b01: // read
                        if (~empty_reg) begin // not empty
                                r_ptr_next = r_ptr_succ;
                                full_next = 1'b0;
                                if (r_ptr_succ==w_ptr_reg)
                                        empty_next = 1'b1;
                        end
                2'b10: // write
                        if (~full_reg) begin // not full
                                w_ptr_next = w_ptr_succ;
                                empty_next = 1'b0;
                                if (w_ptr_succ==r_ptr_reg)
                                        full_next = 1'b1;
                        end
                2'b11: begin // write and read
                                w_ptr_next = w_ptr_succ;
                                r_ptr_next = r_ptr_succ;
                        end
                endcase
        end

        // output
        assign full = full_reg;
        assign empty = empty_reg;

endmodule

