`ifndef _vga_macros
`define _vga_macros

// bus sizes
`define VGA_BUS_SIZE 40
`define VGA_RGB_SIZE 12
`define VGA_VCOUNT_SIZE 12
`define VGA_HCOUNT_SIZE 12

// VGA bus components
`define VGA_VB_BITS 39
`define VGA_HB_BITS 38
`define VGA_VS_BITS 37
`define VGA_HS_BITS 36
`define VGA_RGB_BITS 35:24
`define VGA_VCOUNT_BITS 23:12
`define VGA_HCOUNT_BITS 11:0

// vga bus split at input port
`define VGA_SPLIT_INPUT(BUS_NAME) \
    wire vblnk_in = BUS_NAME[`VGA_VB_BITS]; \
    wire hblnk_in = BUS_NAME[`VGA_HB_BITS]; \
    wire vs_in = BUS_NAME[`VGA_VS_BITS]; \
    wire hs_in = BUS_NAME[`VGA_HS_BITS]; \
    wire [`VGA_RGB_SIZE-1:0] rgb_in = BUS_NAME[`VGA_RGB_BITS]; \
    wire [`VGA_VCOUNT_SIZE-1:0] vcount_in = BUS_NAME[`VGA_VCOUNT_BITS]; \
    wire [`VGA_HCOUNT_SIZE-1:0] hcount_in = BUS_NAME[`VGA_HCOUNT_BITS]; 

// vga bus output variables
`define VGA_OUT_WIRE \
    wire vblnk_out; \
    wire hblnk_out; \
    wire vs_out; \
    wire hs_out; \
    wire [`VGA_RGB_SIZE-1:0] rgb_out; \
    wire [`VGA_VCOUNT_SIZE-1:0] vcount_out; \
    wire [`VGA_HCOUNT_SIZE-1:0] hcount_out; 

`define VGA_OUT_REG \
    reg vblnk_out; \
    reg hblnk_out; \
    reg vs_out; \
    reg hs_out; \
    reg [`VGA_RGB_SIZE-1:0] rgb_out; \
    reg [`VGA_VCOUNT_SIZE-1:0] vcount_out; \
    reg [`VGA_HCOUNT_SIZE-1:0] hcount_out; 

// vga bus merge at the output
`define VGA_MERGE_OUTPUT(BUS_NAME) \
    assign BUS_NAME[`VGA_VB_BITS] = vblnk_out; \
    assign BUS_NAME[`VGA_HB_BITS] = hblnk_out; \
    assign BUS_NAME[`VGA_VS_BITS] = vs_out; \
    assign BUS_NAME[`VGA_HS_BITS] = hs_out; \
    assign BUS_NAME[`VGA_RGB_BITS] = rgb_out; \
    assign BUS_NAME[`VGA_VCOUNT_BITS] = vcount_out; \
    assign BUS_NAME[`VGA_HCOUNT_BITS] = hcount_out; 

`endif
