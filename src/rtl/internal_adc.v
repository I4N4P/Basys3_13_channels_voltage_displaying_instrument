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

module internal_adc (
        input wire clk,
        input wire rst,

        input wire iadcp,
        input wire iadcn,
        input wire vp_in,
        input wire vn_in,

        output wire [15:0] dout
        );

        wire enable;

        wire [15:0] data;

        wire [11:0] value;

        //xadc is the main module provided by xillinx

        xadc my_xadc (
                .daddr_in(8'h16),
                .dclk_in(clk), 
                .den_in(enable), 
                .di_in(0), 
                .dwe_in(0), 
                .busy_out(),                    
                .vauxp6(iadcp),
                .vauxn6(iadcn),
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
                 
        //scale aquired data    
        
        voltage_scaler #(
                .MUL(7_629)
        ) m_voltage_scaler (
                .clk(clk),
                .rst(rst),

                .in(data[15:4]),

                .out(value)
        );

        //binary to decimal conversion    

        bin2bcd my_bin2bcd (
                .bin(value),

                .bcd0(dout[3:0]), 
                .bcd1(dout[7:4]),
                .bcd2(dout[11:8]), 
                .bcd3(dout[15:12])
        );
endmodule