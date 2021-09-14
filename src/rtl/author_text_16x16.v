`timescale 1ns / 1ps


module author_text_16x16(
    input wire clk,
    input wire rst,
    input wire TBA
    output reg TBA
    output reg TBA
    output reg TBA
);

  always @* begin
    case(char_xy)
	8'h00: char_code = 7'h42; //B
	8'h01: char_code = 7'h79; //y
	8'h02: char_code = 7'h20; // 
	8'h03: char_code = 7'h20; // 
	8'h04: char_code = 7'h20; // 
	8'h05: char_code = 7'h20; // 
	8'h06: char_code = 7'h20; // 
	8'h07: char_code = 7'h20; // 
	8'h08: char_code = 7'h20; // 
	8'h09: char_code = 7'h20; // 
	8'h0a: char_code = 7'h20; // 
	8'h0b: char_code = 7'h20; // 
	8'h0c: char_code = 7'h20; // 
	8'h0d: char_code = 7'h20; // 
	8'h0e: char_code = 7'h20; // 
	8'h0f: char_code = 7'h20; // 
	8'h10: char_code = 7'h44; //D
	8'h11: char_code = 7'h61; //a
	8'h12: char_code = 7'h77; //w
	8'h13: char_code = 7'h69; //i
	8'h14: char_code = 7'h64; //d
	8'h15: char_code = 7'h20; // 
	8'h16: char_code = 7'h20; // 
	8'h17: char_code = 7'h20; // 
	8'h18: char_code = 7'h20; // 
	8'h19: char_code = 7'h20; // 
	8'h1a: char_code = 7'h20; // 
	8'h1b: char_code = 7'h20; // 
	8'h1c: char_code = 7'h20; // 
	8'h1d: char_code = 7'h20; // 
	8'h1e: char_code = 7'h20; // 
	8'h1f: char_code = 7'h20; // 
	8'h20: char_code = 7'h53; //S
	8'h21: char_code = 7'h63; //c
	8'h22: char_code = 7'h65; //e
	8'h23: char_code = 7'h63; //c
	8'h24: char_code = 7'h68; //h
	8'h25: char_code = 7'h75; //u
	8'h26: char_code = 7'h72; //r
	8'h27: char_code = 7'h61; //a
	8'h28: char_code = 7'h20; // 
	8'h29: char_code = 7'h20; // 
	8'h2a: char_code = 7'h20; // 
	8'h2b: char_code = 7'h20; // 
	8'h2c: char_code = 7'h20; // 
	8'h2d: char_code = 7'h20; // 
	8'h2e: char_code = 7'h20; // 
	8'h2f: char_code = 7'h20; // 
	8'h30: char_code = 7'h44; //D
	8'h31: char_code = 7'h61; //a
	8'h32: char_code = 7'h6d; //m
	8'h33: char_code = 7'h69; //i
	8'h34: char_code = 7'h61; //a
	8'h35: char_code = 7'h6e; //n
	8'h36: char_code = 7'h20; // 
	8'h37: char_code = 7'h20; // 
	8'h38: char_code = 7'h20; // 
	8'h39: char_code = 7'h20; // 
	8'h3a: char_code = 7'h20; // 
	8'h3b: char_code = 7'h20; // 
	8'h3c: char_code = 7'h20; // 
	8'h3d: char_code = 7'h20; // 
	8'h3e: char_code = 7'h20; // 
	8'h3f: char_code = 7'h20; // 
	8'h40: char_code = 7'h48; //H
	8'h41: char_code = 7'h65; //e
	8'h42: char_code = 7'h72; //r
	8'h43: char_code = 7'h64; //d
	8'h44: char_code = 7'h75; //u
	8'h45: char_code = 7'h73; //s
	8'h46: char_code = 7'h20; // 
	8'h47: char_code = 7'h20; // 
	8'h48: char_code = 7'h20; // 
    endcase
  end
endmodule
