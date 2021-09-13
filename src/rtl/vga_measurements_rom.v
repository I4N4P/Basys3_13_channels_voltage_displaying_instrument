//////////////////////////////////////////////////////////////////////////////////
//
// Company: AGH_University
// Engineer: Dawid Scechura
// 
// Create Date:         2016 
// Design Name:         vga_measurements_rom
// Module Name:         vga_measurements_rom
// Project Name:        voltmeter
// Target Devices: 
// Tool versions:       2018.2
// Description:         This module write text on the backround.
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
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module vga_measurements_rom
        (
                input  wire        clk,

                input wire [27:0] in0,
                input wire [27:0] in1,
                input wire [27:0] in2,
                input wire [27:0] in3,
                input wire [27:0] in4,
                input wire [27:0] in5,
                input wire [27:0] in6,
                input wire [27:0] in7,
                input wire [27:0] in8,
                input wire [27:0] in9,
                input wire [27:0] in10,
                input wire [27:0] in11,
                input wire [27:0] in12,

                input  wire [7:0]  text_xy,            
                output reg  [6:0]  char_code 
        );

        // signal declaration
        reg [6:0] char_code1;
        reg [31:0] counter,counter_nxt= 32'b0;
        reg [27:0] out [0:12];
        reg [27:0] nxt [0:12];

        integer i;


        // body
        always @(posedge clk) begin
                char_code <= char_code1;
                if(counter == 65_000_000) begin
                        for(i = 0;i < 13;i = i + 1)
                                out[i] <= nxt[i];
                                counter <= 32'b0;
                end else begin
                        counter <= counter_nxt;
                        for(i = 0;i < 13;i = i + 1)
                                out[i] <= out[i];
                        
                end
        end

        always @* begin 
                counter_nxt = counter + 1;
                
                        nxt[0] = in0 ;
                        nxt[1] = in1 ;
                        nxt[2] = in2 ;
                        nxt[3] = in3 ;
                        nxt[4] = in4 ;
                        nxt[5] = in5 ;
                        nxt[6] = in6 ;
                        nxt[7] = in7 ;
                        nxt[8] = in8 ;
                        nxt[9] = in9 ;
                        nxt[10] = in10 ;
                        nxt[11] = in11 ;
                        nxt[12] = in12 ;
                case (text_xy)

                8'h00: char_code1 = 7'h56; //V
                8'h01: char_code1 = 7'h30; //0
                8'h02: char_code1 = 7'h31; //1
                8'h03: char_code1 = 7'h20; // 
                8'h04: char_code1 = 7'h2D; //-
                8'h05: char_code1 = 7'h20; //
                8'h06: char_code1 = out[0][27:21]; //0
                8'h07: char_code1 = out[0][20:14]; //0
                8'h08: char_code1 = out[0][13:7]; //8
                8'h09: char_code1 = out[0][6:0]; //9
                8'h0a: char_code1 = 7'h20; // 
                8'h0b: char_code1 = 7'h56; //V
                8'h0c: char_code1 = 7'h56; //V
                8'h0d: char_code1 = 7'h30; //0
                8'h0e: char_code1 = 7'h32; //2
                8'h0f: char_code1 = 7'h20; // 
                8'h10: char_code1 = 7'h2D; //-
                8'h11: char_code1 = 7'h20; //
                8'h12: char_code1 = out[1][27:21];
                8'h13: char_code1 = out[1][20:14];
                8'h14: char_code1 = out[1][13:7]; 
                8'h15: char_code1 = out[1][6:0]; 
                8'h16: char_code1 = 7'h20; // 
                8'h17: char_code1 = 7'h56; //V
                8'h18: char_code1 = 7'h56; //V
                8'h19: char_code1 = 7'h30; //0
                8'h1a: char_code1 = 7'h33; //3
                8'h1b: char_code1 = 7'h20; //
                8'h1c: char_code1 = 7'h2D; //-
                8'h1d: char_code1 = 7'h20; //
                8'h1e: char_code1 = out[2][27:21];
                8'h1f: char_code1 = out[2][20:14];
                8'h20: char_code1 = out[2][13:7]; 
                8'h21: char_code1 = out[2][6:0]; 
                8'h22: char_code1 = 7'h20; // 
                8'h23: char_code1 = 7'h56; //V
                8'h24: char_code1 = 7'h56; //V
                8'h25: char_code1 = 7'h30; //0
                8'h26: char_code1 = 7'h34; //4
                8'h27: char_code1 = 7'h20; //
                8'h28: char_code1 = 7'h2D; //-
                8'h29: char_code1 = 7'h20; //
                8'h2a: char_code1 = out[3][27:21];
                8'h2b: char_code1 = out[3][20:14];
                8'h2c: char_code1 = out[3][13:7]; 
                8'h2d: char_code1 = out[3][6:0]; 
                8'h2e: char_code1 = 7'h20; // 
                8'h2f: char_code1 = 7'h56; //V
                8'h30: char_code1 = 7'h56; //V
                8'h31: char_code1 = 7'h30; //0
                8'h32: char_code1 = 7'h35; //5
                8'h33: char_code1 = 7'h20; // 
                8'h34: char_code1 = 7'h2D; //-
                8'h35: char_code1 = 7'h20; //
                8'h36: char_code1 = out[4][27:21];
                8'h37: char_code1 = out[4][20:14];
                8'h38: char_code1 = out[4][13:7]; 
                8'h39: char_code1 = out[4][6:0]; 
                8'h3a: char_code1 = 7'h20; // 
                8'h3b: char_code1 = 7'h56; //V
                8'h3c: char_code1 = 7'h56; //V
                8'h3d: char_code1 = 7'h30; //0
                8'h3e: char_code1 = 7'h36; //6
                8'h3f: char_code1 = 7'h20; // 
                8'h40: char_code1 = 7'h2D; //-
                8'h41: char_code1 = 7'h20; //
                8'h42: char_code1 = out[5][27:21];
                8'h43: char_code1 = out[5][20:14];
                8'h44: char_code1 = out[5][13:7]; 
                8'h45: char_code1 = out[5][6:0]; 
                8'h46: char_code1 = 7'h20; // 
                8'h47: char_code1 = 7'h56; //V
                8'h48: char_code1 = 7'h56; //V
                8'h49: char_code1 = 7'h30; //0
                8'h4a: char_code1 = 7'h37; //7
                8'h4b: char_code1 = 7'h20; //
                8'h4c: char_code1 = 7'h2D; //-
                8'h4d: char_code1 = 7'h20; //
                8'h4e: char_code1 = out[6][27:21];
                8'h4f: char_code1 = out[6][20:14];
                8'h50: char_code1 = out[6][13:7]; 
                8'h51: char_code1 = out[6][6:0]; 
                8'h52: char_code1 = 7'h20; // 
                8'h53: char_code1 = 7'h56; //V
                8'h54: char_code1 = 7'h56; //V
                8'h55: char_code1 = 7'h30; //0
                8'h56: char_code1 = 7'h38; //8
                8'h57: char_code1 = 7'h20; // 
                8'h58: char_code1 = 7'h2D; //-
                8'h59: char_code1 = 7'h20; //
                8'h5a: char_code1 = out[7][27:21];
                8'h5b: char_code1 = out[7][20:14];
                8'h5c: char_code1 = out[7][13:7]; 
                8'h5d: char_code1 = out[7][6:0]; 
                8'h5e: char_code1 = 7'h20; // 
                8'h5f: char_code1 = 7'h56; //V
                8'h60: char_code1 = 7'h56; //V
                8'h61: char_code1 = 7'h30; //0
                8'h62: char_code1 = 7'h39; //9
                8'h63: char_code1 = 7'h20; // 
                8'h64: char_code1 = 7'h2D; //-
                8'h65: char_code1 = 7'h20; //
                8'h66: char_code1 = out[8][27:21];
                8'h67: char_code1 = out[8][20:14];
                8'h68: char_code1 = out[8][13:7]; 
                8'h69: char_code1 = out[8][6:0]; 
                8'h6a: char_code1 = 7'h20; // 
                8'h6b: char_code1 = 7'h56; //V
                8'h6c: char_code1 = 7'h56; //V
                8'h6d: char_code1 = 7'h31; //1
                8'h6e: char_code1 = 7'h30; //0
                8'h6f: char_code1 = 7'h20; // 
                8'h70: char_code1 = 7'h2D; //-
                8'h71: char_code1 = 7'h20; //
                8'h72: char_code1 = out[9][27:21];
                8'h73: char_code1 = out[9][20:14];
                8'h74: char_code1 = out[9][13:7]; 
                8'h75: char_code1 = out[9][6:0]; 
                8'h76: char_code1 = 7'h20; // 
                8'h77: char_code1 = 7'h56; //V
                8'h78: char_code1 = 7'h56; //V
                8'h79: char_code1 = 7'h31; //1
                8'h7a: char_code1 = 7'h31; //1
                8'h7b: char_code1 = 7'h20; //
                8'h7c: char_code1 = 7'h2D; //-
                8'h7d: char_code1 = 7'h20; //
                8'h7e: char_code1 = out[10][27:21];
                8'h7f: char_code1 = out[10][20:14];
                8'h80: char_code1 = out[10][13:7]; 
                8'h81: char_code1 = out[10][6:0]; 
                8'h82: char_code1 = 7'h20; // 
                8'h83: char_code1 = 7'h56; //V
                8'h84: char_code1 = 7'h56; //V
                8'h85: char_code1 = 7'h31; //1
                8'h86: char_code1 = 7'h32; //2
                8'h87: char_code1 = 7'h20; //
                8'h88: char_code1 = 7'h2D; //-
                8'h89: char_code1 = 7'h20; //
                8'h8a: char_code1 = out[11][27:21];
                8'h8b: char_code1 = out[11][20:14];
                8'h8c: char_code1 = out[11][13:7]; 
                8'h8d: char_code1 = out[11][6:0]; 
                8'h8e: char_code1 = 7'h20; // 
                8'h8f: char_code1 = 7'h56; //V
                8'h90: char_code1 = 7'h56; //V
                8'h91: char_code1 = 7'h31; //1
                8'h92: char_code1 = 7'h33; //3
                8'h93: char_code1 = 7'h20; //
                8'h94: char_code1 = 7'h2D; //-
                8'h95: char_code1 = 7'h20; //
                8'h96: char_code1 = out[12][27:21];
                8'h97: char_code1 = out[12][20:14];
                8'h98: char_code1 = out[12][13:7]; 
                8'h99: char_code1 = out[12][6:0]; 
                8'h9a: char_code1 = 7'h20; // 
                8'h9b: char_code1 = 7'h56; //V
                8'h9c: char_code1 = 7'h56; //V
                8'h9d: char_code1 = 7'h31; //1
                8'h9e: char_code1 = 7'h34; //4
                8'h9f: char_code1 = 7'h20; //
                8'ha0: char_code1 = 7'h2D; //-
                8'ha1: char_code1 = 7'h20; //
                8'ha2: char_code1 = 7'h30; //0
                8'ha3: char_code1 = 7'h30; //0
                8'ha4: char_code1 = 7'h38; //8
                8'ha5: char_code1 = 7'h39; //9
                8'ha6: char_code1 = 7'h20; // 
                8'ha7: char_code1 = 7'h56; //V
                default : char_code1 = 7'h20; //
        endcase
        end
endmodule
