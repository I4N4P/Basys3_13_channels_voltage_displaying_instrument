// File: pmod_control.v
// This is the FSM for pmodAD2 that reads data from all channels

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module pmod_control (
                input wire clk,
                input wire rst,
                input wire [11:0] in,

                output reg [7:0] adress,
                output reg tick,
                
                output reg [11:0] channel0,
                output reg [11:0] channel1,
                output reg [11:0] channel2,
                output reg [11:0] channel3
                
        );

        localparam      IDLE = 4'b0001,
                        SAVE_DATA = 4'b0010,
                        CHANGE_CHANNEL = 4'b0100,
                        GENERATE_TICK = 4'b1000;

        localparam TIME2WAIT = 10_000_000;

        integer i;
        reg [3:0] state,state_nxt;
        reg [31:0] counter,counter_nxt;

        reg tick_nxt;
        reg [11:0] channel [0:3],channel_nxt [0:3];
        reg [1:0]  channel_number,channel_number_nxt;
        reg [7:0]  adress_nxt;

        reg [11:0] channel0_nxt;
        reg [11:0] channel1_nxt;
        reg [11:0] channel2_nxt;
        reg [11:0] channel3_nxt;

        always @(posedge clk) begin
                if(rst) 
                        state <= IDLE;
                else
                        state <= state_nxt;    
        end

        always @* begin
                state_nxt = state;
                case(state)
                IDLE:           state_nxt = (counter > TIME2WAIT)       ?   SAVE_DATA   : IDLE;
                SAVE_DATA:      state_nxt = CHANGE_CHANNEL; 
                CHANGE_CHANNEL: state_nxt = GENERATE_TICK;
                GENERATE_TICK:  state_nxt = (tick == 1'b1)              ?   IDLE        : GENERATE_TICK;
                default:        state_nxt = IDLE;
                endcase
        end

        always @(posedge clk) begin
                if(rst) begin
                        counter         <= 32'b0;
                        tick            <= 1'b0;
                        channel_number  <= 2'b0;
                        for(i = 0;i < 4;i = i + 1)
                                channel[i]  <= 16'b0;
                        adress          <= 8'b0;
                        channel0        <= 12'b0;
                        channel1        <= 12'b0;
                        channel2        <= 12'b0;
                        channel3        <= 12'b0;
                end else begin
                        counter         <= counter_nxt;
                        tick            <= tick_nxt;
                        channel_number  <= channel_number_nxt;
                        for(i = 0;i < 4;i = i + 1)
                                channel[i]  <= channel_nxt[i];
                        adress          <= adress_nxt;
                        channel0        <= channel0_nxt;
                        channel1        <= channel1_nxt;
                        channel2        <= channel2_nxt;
                        channel3        <= channel3_nxt;
                end
        end

        always @* begin
                counter_nxt     = counter;
                for(i = 0;i < 4;i = i + 1)
                            channel_nxt[i] = channel[i];
                tick_nxt        = tick;
                channel_number_nxt = channel_number;
                case(state)
                IDLE:           counter_nxt = (counter > TIME2WAIT)           ? 32'b0 : counter + 1;
                SAVE_DATA:      channel_nxt[channel_number] = in;
                CHANGE_CHANNEL: channel_number_nxt = channel_number + 1; 
                GENERATE_TICK:  tick_nxt = (tick == 1'b0)                     ? 1'b1  : 1'b0;
                endcase
        end

        always @* begin
                case (channel_number)
                0: adress_nxt = 8'b00010000;
                1: adress_nxt = 8'b00100000;
                2: adress_nxt = 8'b01000000;
                3: adress_nxt = 8'b10000000;
                default: adress_nxt = 8'b00100000;
                endcase  
        end

        always @* begin
                channel0_nxt = (channel[0]*805664)/1_000_000;
                channel1_nxt = (channel[1]*805664)/1_000_000;
                channel2_nxt = (channel[2]*805664)/1_000_000;
                channel3_nxt = (channel[3]*805664)/1_000_000;
        end
        
endmodule
