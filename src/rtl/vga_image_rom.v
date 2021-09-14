//////////////////////////////////////////////////////////////////////////////////
//
// // https://upel2.cel.agh.edu.pl/weaiib/course/view.php?id=1121
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
// Description:         This is the ROM for the 'eaiib.jpg' image.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:         using Verilog-2001 syntax.
// 
// The image size is 200 x 100 pixels.
// The input 'address' is a 12-bit number, composed of the concatenated
// 6-bit y and 6-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)
//              
// 
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module vga_image_rom (
                input wire clk,
                input wire rst,
                input wire [15:0] address,  // address = {addry[9:0], addrx[9:0]}
                output reg [11:0] rgb
        );

        reg [15:0] rom [0:65535];

        initial $readmemh("eaiib_logo.data", rom); 
        

        always @(posedge clk)
                if (rst)
                        rgb <= 12'b0;
                else 
                        rgb <= rom[address];

endmodule
