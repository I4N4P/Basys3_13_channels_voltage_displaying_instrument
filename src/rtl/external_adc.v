// File: external_adc.v
// This is the top level module for pmodAD2 that reads 
// and translate measurments from U2 to bcd.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module external_adc (
                input wire clk,
                input wire rst,

                inout wire AD2_SCL, 
                inout wire AD2_SDA,
                
                output wire [15:0] channel0,
                output wire [15:0] channel1,
                output wire [15:0] channel2,
                output wire [15:0] channel3
                
        );

        wire [7:0] adress;
        wire flag;
        wire [15:0] raw_data;
        wire [11:0] value0,value1,value2,value3;
        
        pmodAD2_ctrl my_pmodAD2_ctrl (
                .mainClk(clk),
                .SDA_mst(AD2_SDA),
                .SCL_mst(AD2_SCL),
                .wData0(raw_data),
                .writeCfg(adress),
                .rst(flag)
        );

        pmod_control my_pmod_contol (
                .clk (clk),
                .rst (rst),
                .in (raw_data[11:0]),
                .adress (adress),
                .tick (flag),
                .channel0 (value0),
                .channel1 (value1),
                .channel2 (value2),
                .channel3 (value3)
        );

        bin2bcd my_bin2bcd_0 (
                .bin(value0),  
                .bcd0(channel0[3:0]), 
                .bcd1(channel0[7:4]),
                .bcd2(channel0[11:8]), 
                .bcd3(channel0[15:12])
        );
        bin2bcd my_bin2bcd_1 (
                .bin(value1),  
                .bcd0(channel1[3:0]), 
                .bcd1(channel1[7:4]),
                .bcd2(channel1[11:8]), 
                .bcd3(channel1[15:12])
        );
        bin2bcd my_bin2bcd_2 (
                .bin(value2),  
                .bcd0(channel2[3:0]), 
                .bcd1(channel2[7:4]),
                .bcd2(channel2[11:8]), 
                .bcd3(channel2[15:12])
        );
        bin2bcd my_bin2bcd_3 (
                .bin(value3),  
                .bcd0(channel3[3:0]), 
                .bcd1(channel3[7:4]),
                .bcd2(channel3[11:8]), 
                .bcd3(channel3[15:12])
        );
endmodule