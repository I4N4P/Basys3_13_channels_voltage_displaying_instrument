`ifndef _adc_macros
`define _adc_macros

// bus sizes
`define ADC_BUS_SIZE 208
`define ADC_SMALL_BUS_SIZE 64
`define ADC_CHANNEL_SIZE 16

// ADC bus components

`define ADC_CHANNEL_12_BITS 207:192
`define ADC_CHANNEL_11_BITS 191:176
`define ADC_CHANNEL_10_BITS 175:160
`define ADC_CHANNEL_9_BITS 159:144
`define ADC_CHANNEL_8_BITS 143:128
`define ADC_CHANNEL_7_BITS 127:112
`define ADC_CHANNEL_6_BITS 111:96
`define ADC_CHANNEL_5_BITS 95:80
`define ADC_CHANNEL_4_BITS 79:64
`define ADC_CHANNEL_3_BITS 63:48
`define ADC_CHANNEL_2_BITS 47:32
`define ADC_CHANNEL_1_BITS 31:16
`define ADC_CHANNEL_0_BITS 15:0

`define ADC_SMALL_BUS_3_BITS 207:144
`define ADC_SMALL_BUS_2_BITS 143:80
`define ADC_SMALL_BUS_1_BITS 79:16
`define ADC_SMALL_BUS_0_BITS 15:0

`define ADC_INPUT_WIRE \
    wire [`ADC_CHANNEL_SIZE-1:0] in[0:12];

// vga bus split at input port
`define ADC_SPLIT_INPUT(BUS_NAME) \
    assign in[12] = BUS_NAME[`ADC_CHANNEL_12_BITS]; \
    assign in[11] = BUS_NAME[`ADC_CHANNEL_11_BITS]; \
    assign in[10] = BUS_NAME[`ADC_CHANNEL_10_BITS]; \
    assign in[9] = BUS_NAME[`ADC_CHANNEL_9_BITS]; \
    assign in[8] = BUS_NAME[`ADC_CHANNEL_8_BITS]; \
    assign in[7] = BUS_NAME[`ADC_CHANNEL_7_BITS]; \
    assign in[6] = BUS_NAME[`ADC_CHANNEL_6_BITS]; \
    assign in[5] = BUS_NAME[`ADC_CHANNEL_5_BITS]; \
    assign in[4] = BUS_NAME[`ADC_CHANNEL_4_BITS]; \
    assign in[3] = BUS_NAME[`ADC_CHANNEL_3_BITS]; \
    assign in[2] = BUS_NAME[`ADC_CHANNEL_2_BITS]; \
    assign in[1] = BUS_NAME[`ADC_CHANNEL_1_BITS]; \
    assign in[0] = BUS_NAME[`ADC_CHANNEL_0_BITS];

// vga bus output variables
`define ADC_OUT_SMALL_WIRE \
    wire [`ADC_CHANNEL_SIZE-1:0] channel[0:3]; 

`define ADC_OUT_SMALL_REG \
    reg [`ADC_CHANNEL_SIZE-1:0] channel[0:3];

`define ADC_OUT_WIRE \
    wire [`ADC_SMALL_BUS_SIZE-1:0] adc_out[0:3]; \
    wire [`ADC_CHANNEL_SIZE-1:0] dout; 

`define ADC_OUT_REG \
    reg [`ADC_SMALL_BUS_SIZE-1:0] adc_out[0:3]; \
    reg [`ADC_CHANNEL_SIZE-1:0] dout; 


// vga bus merge at the output
`define ADC_SMALL_MERGE_OUTPUT(BUS_NAME) \
    assign BUS_NAME[`ADC_CHANNEL_3_BITS] = channel[3]; \
    assign BUS_NAME[`ADC_CHANNEL_2_BITS] = channel[2]; \
    assign BUS_NAME[`ADC_CHANNEL_1_BITS] = channel[1]; \
    assign BUS_NAME[`ADC_CHANNEL_0_BITS] = channel[0];

`define ADC_MERGE_OUTPUT(BUS_NAME) \
    assign BUS_NAME[`ADC_SMALL_BUS_3_BITS] = adc_out[2]; \
    assign BUS_NAME[`ADC_SMALL_BUS_2_BITS] = adc_out[1]; \
    assign BUS_NAME[`ADC_SMALL_BUS_1_BITS] = adc_out[0]; \
    assign BUS_NAME[`ADC_SMALL_BUS_0_BITS] = dout;

`endif
