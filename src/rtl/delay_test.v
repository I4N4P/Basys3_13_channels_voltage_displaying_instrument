module delay_test (
        input  wire        clk,
        input  wire        rst,

        input  wire [10:0] hcount_in,
        input  wire [10:0] vcount_in,
        input  wire        vsync_in,
        input  wire        hsync_in,

        output wire [10:0] hcount_out,
        output wire [10:0] vcount_out,
        output wire        vsync_out,
        output wire        hsync_out
        );

        delay #(
                .WIDTH (24),
                .CLK_DEL(4)
        ) u_delay (
                .clk (clk),
                .rst (rst),
                .din ( {hcount_in, hsync_in, vcount_in, vsync_in}),
                .dout ({hcount_out, hsync_out, vcount_out, vsync_out})
        );

endmodule
