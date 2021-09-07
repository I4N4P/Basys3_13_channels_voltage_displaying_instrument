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

        wire [3:0] adress;
        wire flag;
        wire [11:0] raw_data;
        wire [11:0] value [0:3];
        wire [11:0] value_out [0:3];
        wire [15:0] channel [0:3];
        
        pmodAD2_ctrl my_pmodAD2_ctrl (
                .mainClk(clk),
                .SDA_mst(AD2_SDA),
                .SCL_mst(AD2_SCL),
                .wData0(raw_data),
                .writeCfg({adress,4'b0}),
                .rst(flag)
        );

        pmod_control my_pmod_contol (
                .clk (clk),
                .rst (rst),
                .in (raw_data),
                .adress (adress),
                .tick (flag),
                .channel0 (value[0]),
                .channel1 (value[1]),
                .channel2 (value[2]),
                .channel3 (value[3])
        );
        genvar    i;
        generate
                for (i = 0; i < 4 ; i = i + 1 ) begin
                        voltage_scaler my_voltage_scaler (
                                .clk(clk),
                                .rst(rst),
                                .in(value[i]),

                                .out(value_out[i])
                        );
                        bin2bcd my_bin2bcd_0 (
                                .bin(value_out[i]),  
                                .bcd0(channel[i][3:0]), 
                                .bcd1(channel[i][7:4]),
                                .bcd2(channel[i][11:8]), 
                                .bcd3(channel[i][15:12])
                        );
                end
        endgenerate
        
        assign channel0 = channel[0];
        assign channel1 = channel[1];
        assign channel2 = channel[2];
        assign channel3 = channel[3];

endmodule