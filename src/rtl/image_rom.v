// This is the ROM for the 'eaiib.jpg' image.
// The image size is 200 x 100 pixels.
// The input 'address' is a 12-bit number, composed of the concatenated
// 6-bit y and 6-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)

//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: not known
// 
// Create Date:         2016
// Design Name:         image_rom
// Module Name:         image_rom
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         this module provide prject with adc_macros.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:         using Verilog-2001 syntax.
//              
//////////////////////////////////////////////////////////////////////////////////
module image_rom (
        input wire clk ,
        input wire [15:0] address,  // address = {addry[9:0], addrx[9:0]}
        output reg [11:0] rgb
        );


        reg [15:0] rom [0:65535];

        initial $readmemh("eaiib_logo.data", rom); 
        

        always @(posedge clk)

                rgb <= rom[address];

endmodule
