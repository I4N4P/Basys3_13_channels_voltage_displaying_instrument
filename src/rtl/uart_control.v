// File: uart_control.v
// This is the top level design for Lab #3 that contains
// all modules which are responsible for displaying data on screen  .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module uart_control (
                input wire clk,
                input wire rst,
                input wire [15:0] in,

                output reg [7:0] sign,
                output reg tick
                
        );

localparam IDLE = 4'b0001,
           PREPARE_SIGN = 4'b0010,
           SEND_SIGN = 4'b0100;

           reg [3:0] state,state_nxt;
           reg [31:0] counter,counter_nxt;
           reg [31:0] counter2,counter2_nxt;

           reg [7:0] sign_number,sign_number_nxt;
           reg [7:0] sign_2_send,sign_2_send_nxt;

           reg [7:0] sign_nxt;
           reg [7:0] sign_ascii;
           reg tick_nxt;


           always @(posedge clk) begin
                   if(rst) begin
                           state <= IDLE;
                           counter <= 0;
                           sign_2_send <= 0;
                           tick <= 1'b0;
                           sign <= 0;
                           sign_number <=0;
                   end else begin
                           state <= state_nxt;
                           counter <= counter_nxt;
                           counter2 <= counter2_nxt;
                           sign_2_send <= sign_2_send_nxt;
                           tick <= tick_nxt;
                           sign <= sign_nxt;
                           sign_number <= sign_number_nxt;
                   end
           end

           always @* begin
                   counter_nxt = counter;
                   sign_number_nxt = sign_number;
                   sign_nxt = sign_ascii;
                   tick_nxt = tick;
                   state_nxt = state;
                   counter2_nxt = counter2;
                   case(state)
                   IDLE: begin
                           if(counter >= 100_000_000) begin
                                state_nxt = PREPARE_SIGN;
                                counter_nxt = 0;
                           end else begin
                                state_nxt = IDLE;
                                counter_nxt = counter + 1;   
                           end
                   end
                   PREPARE_SIGN: begin
                           if(sign_number >= 14) begin
                                state_nxt = IDLE;
                                sign_number_nxt = 0;
                           end else begin
                                state_nxt = SEND_SIGN;
                                sign_number_nxt = sign_number + 1;   
                           end
                   end
                   SEND_SIGN: begin
                           if(counter2 < 1) begin
                                state_nxt = SEND_SIGN;
                                sign_nxt = sign_ascii;
                                tick_nxt = 1'b1;
                                counter2_nxt = counter2 + 1;
                           end else begin
                                state_nxt = PREPARE_SIGN;
                                sign_nxt = sign_ascii;
                                tick_nxt = 1'b0;   
                                counter2_nxt = 0;
                           end
                   end
                   default: state_nxt = IDLE;
                   endcase
           end

           always @* begin            
            case (sign_number)
            0:  sign_2_send_nxt = 8'd86; //V
            1:  sign_2_send_nxt = 8'd48; //0
            2:  sign_2_send_nxt = 8'd49; //1
            3:  sign_2_send_nxt = 8'd32; // 
            4:  sign_2_send_nxt = 8'd45; // -
            5:  sign_2_send_nxt = 8'd32; // 
            6:  sign_2_send_nxt = {4'b0,in[15:12]};
            7:  sign_2_send_nxt = {4'b0,in[11:8]};
            8:  sign_2_send_nxt = {4'b0,in[7:4]};
            9:  sign_2_send_nxt = {4'b0,in[3:0]};
            10:  sign_2_send_nxt = 8'd10;
            11:  sign_2_send_nxt = 8'd13;
            12:  sign_2_send_nxt = 8'd32; // 
            13:  sign_2_send_nxt = 8'd86; //V

            default: sign_2_send_nxt = in[3:0]; 
            endcase
            end

        always @* begin            
                case (sign_2_send)
                0:  sign_ascii = 8'b0011_0000;
                1:  sign_ascii = 8'b0011_0001;
                2:  sign_ascii = 8'b0011_0010;
                3:  sign_ascii = 8'b0011_0011;
                4:  sign_ascii = 8'b0011_0100;
                5:  sign_ascii = 8'b0011_0101;
                6:  sign_ascii = 8'b0011_0110; 
                7:  sign_ascii = 8'b0011_0111;
                8:  sign_ascii = 8'b0011_1000;
                9:  sign_ascii = 8'b0011_1001;   
                10: sign_ascii = 8'b0000_1010;   
                13: sign_ascii = 8'b0000_1101;
                32: sign_ascii = 8'b0010_0000;
                45: sign_ascii = 8'b0010_1101;
                48: sign_ascii = 8'b0011_0000;
                49: sign_ascii = 8'b0011_0001;
                86: sign_ascii = 8'b0101_0110;
                default: sign_ascii = 8'b0011_0000; 
                endcase
        end




        

endmodule
