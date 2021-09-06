`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Arthur Brown
// 
// Create Date: 03/23/2017
// Module Name: bcd
// Project Name: OLED Demo
// Target Devices: Nexys Video
// Tool Versions: Vivado 2016.4
// Description: converts an input in the range (0x0000-0xFFFF) to a hex string in the range (16'h0000-16'h1000)
//              assert start & din, some amount of time later, done is asserted with valid dout
// Dependencies: none
// 
// 03/23/2017(ArtVVB): Created
//
//////////////////////////////////////////////////////////////////////////////////

module integrated_adc (
    input wire clk,
    input wire iadcp1,
    input wire iadcn1,
    input wire vp_in,
    input wire vn_in,
    output wire [15:0] dout
);
    wire enable;
    wire b2d_start;
    wire b2d_done;
    wire [15:0] data;
    wire [15:0] b2d_din;
    wire [15:0] b2d_dout;
    wire [11:0] value;


        //xadc instantiation connect the eoc_out .den_in to get continuous conversion
    xadc_wiz_0  XLXI_7 (
        .daddr_in(8'h16), //addresses can be found in the artix 7 XADC user guide DRP register space
        .dclk_in(clk), 
        .den_in(enable), 
        .di_in(0), 
        .dwe_in(0), 
        .busy_out(),                    
        .vauxp6(iadcp1),
        .vauxn6(iadcn1),
        .vauxp7(1'b0),
        .vauxn7(1'b0),
        .vauxp14(1'b0),
        .vauxn14(1'b0),
        .vauxp15(1'b0),
        .vauxn15(1'b0),
        .vn_in(vn_in), 
        .vp_in(vp_in), 
        .alarm_out(), 
        .do_out(data), 
        .eoc_out(enable),
        .eos_out(),
        .channel_out(),
        .drdy_out()
    );
                 
        voltage_scaler #(
                .MUL(7_629)
        ) m_voltage_scaler (
                .clk(clk),
                .rst(rst),
                .in(data[15:4]),

                .out(value)
        );


        bin2bcd my_bin2bcd (
                .bin(value),  
                .bcd0(dout[3:0]), 
                .bcd1(dout[7:4]),
                .bcd2(dout[11:8]), 
                .bcd3(dout[15:12])
        );
    //binary to decimal conversion

    // bin2dec_ctl mbin2dec_ctl(
    //     .clk(clk),
    //     .din(data),
    //     .b2d_start(b2d_start),
    //     .b2d_din(b2d_din),
    //     .dout(dout),
    //     .b2d_dout(b2d_dout),
    //     .b2d_done(b2d_done)
    // );

    // bin2dec m_b2d (
    //     .clk(clk),
    //     .start(b2d_start),
    //     .din(b2d_din),
    //     .done(b2d_done),
    //     .dout(b2d_dout)
    // );
    
endmodule