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

        localparam      IDLE = 4'b0001,
                        PREPARE_WORD = 4'b0010,
                        PREPARE_SIGN = 4'b0100,
                        SEND_SIGN = 4'b1000;

        localparam TIME2WAIT = 100_000_000;
        localparam WORD_SIZE = 14;
        localparam SIGN_SIZE = 14;

        reg [3:0] state,state_nxt;
        reg [31:0] counter,counter_nxt;

        reg [3:0] sign_number,sign_number_nxt;
        reg [7:0] sign_2_send,sign_2_send_nxt;

        reg [3:0]  word_number,word_number_nxt;
        reg [15:0] word_2_send,word_2_send_nxt;

        reg [15:0] word_info,word_info_nxt;

        reg [7:0] sign_nxt;
        reg [7:0] sign_ascii;
        reg tick_nxt;


        always @(posedge clk) begin
                if(rst) 
                        state <= IDLE;
                else
                        state <= state_nxt;    
        end

        always @* begin
                state_nxt = state;
                case(state)
                IDLE:           state_nxt = (counter >= TIME2WAIT)      ?   PREPARE_WORD   : IDLE; 
                PREPARE_WORD:   state_nxt = (word_number >= WORD_SIZE)  ?   IDLE           : PREPARE_SIGN;
                PREPARE_SIGN:   state_nxt = (sign_number >= SIGN_SIZE)  ?   PREPARE_WORD   : SEND_SIGN; 
                SEND_SIGN:      state_nxt = (tick == 1'b0)              ?   SEND_SIGN      : PREPARE_SIGN;
                default:        state_nxt = IDLE;
                endcase
        end

        always @(posedge clk) begin
                if(rst) begin
                        counter         <= 32'b0;
                        sign_2_send     <= 8'b0;
                        word_2_send     <= 16'd10;
                        sign_number     <= 4'b0;
                        word_number     <= 4'b0;
                        word_info       <= 16'd0;
                        tick            <= 1'b0;
                        sign            <= 8'b0;
                end else begin
                        counter         <= counter_nxt;
                        sign_2_send     <= sign_2_send_nxt;
                        word_2_send     <= word_2_send_nxt;
                        sign_number     <= sign_number_nxt;
                        word_number     <= word_number_nxt;
                        word_info       <= word_info_nxt;
                        tick            <= tick_nxt;
                        sign            <= sign_nxt;
                end
        end

        always @* begin
                counter_nxt     = counter;
                sign_number_nxt = sign_number;
                sign_nxt        = sign_ascii;
                tick_nxt        = tick;
                word_number_nxt = word_number;
                case(state)
                IDLE:           counter_nxt = (counter >= TIME2WAIT)          ? 32'b0 : counter + 1;
                PREPARE_WORD:   word_number_nxt = (word_number >= WORD_SIZE)  ? 4'b0  : word_number + 1;
                PREPARE_SIGN:   sign_number_nxt = (sign_number >= SIGN_SIZE)  ? 4'b0  : sign_number + 1; 
                SEND_SIGN:      tick_nxt = (tick == 1'b0)                     ? 1'b1  : 1'b0;
                endcase
        end

        always @* begin            
                case (word_number)
                1: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd1; 
                end 
                2: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd2; 
                end 
                3: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd3; 
                end 
                4: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd4; 
                end 
                5: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd5; 
                end 
                6: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd6; 
                end 
                7: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd7; 
                end 
                8: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd8; 
                end 
                9: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd9; 
                end 
                10: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd1; 
                        word_info_nxt[7:0] = 8'd0; 
                end 
                11: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd1; 
                        word_info_nxt[7:0] = 8'd1; 
                end 
                12: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd1; 
                        word_info_nxt[7:0] = 8'd2; 
                end 
                13: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd1; 
                        word_info_nxt[7:0] = 8'd3; 
                end 
                14: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd1; 
                        word_info_nxt[7:0] = 8'd4; 
                end     
                default: begin
                        word_2_send_nxt = in;
                        word_info_nxt[15:8] = 8'd0; 
                        word_info_nxt[7:0] = 8'd0; 
                end  
                endcase
        end

        always @* begin            
                case (sign_number)
                0:   sign_2_send_nxt = 8'd86; //V
                1:   sign_2_send_nxt = word_info[15:8]; //0
                2:   sign_2_send_nxt = word_info[7:0]; //1
                3:   sign_2_send_nxt = 8'd32; // 
                4:   sign_2_send_nxt = 8'd45; // -
                5:   sign_2_send_nxt = 8'd32; // 
                6:   sign_2_send_nxt = {4'b0,word_2_send[15:12]};
                7:   sign_2_send_nxt = {4'b0,word_2_send[11:8]};
                8:   sign_2_send_nxt = {4'b0,word_2_send[7:4]};
                9:   sign_2_send_nxt = {4'b0,word_2_send[3:0]};
                10:  sign_2_send_nxt = 8'd32; // 
                11:  sign_2_send_nxt = 8'd86; //V
                12:  sign_2_send_nxt = 8'd10;
                13:  sign_2_send_nxt = 8'd13;       
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
