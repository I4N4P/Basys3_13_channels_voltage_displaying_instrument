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
// Design Name:         bin2bcd
// Module Name:         bin2bcd
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This is the module that translate U2 to bcd code.
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
// ABSTRACT:  binary to BCD converter, three 8421 BCD digits
//     Algorithm description:
//     http://www.eng.utah.edu/~nmcdonal/Tutorials/BCDTutorial/BCDConversion.html
//              
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module bin2bcd (
                input  wire [11:0] bin,     // input binary number
                output reg  [3:0]  bcd0,    // LSB
                output reg  [3:0]  bcd1,
                output reg  [3:0]  bcd2, 
                output reg  [3:0]  bcd3     // MSB in order to obtain an extra display There was a need to add output 
        );

        integer i;

        always @(bin) begin
                bcd0 = 0;
                bcd1 = 0;
                bcd2 = 0;
                bcd3 = 0;
                for ( i = 11; i >= 0; i = i - 1 ) begin
                        if( bcd0 > 4 ) bcd0 = bcd0 + 3;
                        if( bcd1 > 4 ) bcd1 = bcd1 + 3;
                        if( bcd2 > 4 ) bcd2 = bcd2 + 3;
                        if( bcd3 > 4 ) bcd3 = bcd3 + 3;
                        { bcd3[3:0],bcd2[3:0], bcd1[3:0], bcd0[3:0] } =
                        { bcd3[2:0],bcd2[3:0], bcd1[3:0], bcd0[3:0],bin[i] };
                end
        end
endmodule
