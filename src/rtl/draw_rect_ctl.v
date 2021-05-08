// File: draw_rect_ctl.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_ctl (
        input   wire pclk,
        input   wire rst,
        
        input   wire mouse_left,
        input   wire[11:0] mouse_xpos,
        input   wire[11:0] mouse_ypos,

        output  reg [11:0] xpos,
        output  reg [11:0] ypos

        );

        localparam PASS_THROUGH         = 3'b000;
        localparam RESET                = 3'b001;
        localparam DRAW_RECT_LEFT_UP    = 3'b010;
        localparam DRAW_RECT_LEFT_DOWN  = 3'b011;
        localparam DRAW_RECT_RIGHT_UP   = 3'b100;
        localparam DRAW_RECT_RIGHT_DOWN = 3'b101;

        localparam MIDDLE = 376;

        reg forward,forward_nxt = 1'b1;
        reg up,up_nxt = 1'b0; 

        reg [2:0] state,state_nxt; 

        reg [9:0] right_cor,right_cor_nxt = 750;
        reg [9:0] left_cor,left_cor_nxt = 0;
        reg [9:0] multi,multi_nxt = 750;

        reg [11:0] ypos_tmp,xpos_tmp = 0;
        reg [11:0] xpos_mach,ypos_mach,xpos_mach_nxt = 0,ypos_mach_nxt = 0;
        reg [11:0] ypos_mach1,ypos_mach2,ypos_mach1_nxt = 0,ypos_mach2_nxt = 0;
        
        reg [18:0] wait_time,wait_time_nxt = 400_000;

        reg [29:0] freq_div,freq_div_nxt = 0;

        // state register
        
        always @(posedge pclk) begin
                if(rst)
                        state <= RESET;
                else
                        state <= state_nxt;        
        end

        // next state logic

        always @(state or rst or mouse_left or forward or up) begin
                case(state)
                RESET :         
                        if(rst)
                                state_nxt = RESET;
                        else if(mouse_left)
                                if(up)
                                        state_nxt = forward ? DRAW_RECT_RIGHT_UP : DRAW_RECT_LEFT_UP;
                                else 
                                        state_nxt = forward ? DRAW_RECT_RIGHT_DOWN : DRAW_RECT_LEFT_DOWN;  
                        else
                                state_nxt = PASS_THROUGH;
                DRAW_RECT_LEFT_UP :    
                        if(mouse_left)
                                if(up)
                                        state_nxt = forward ? DRAW_RECT_RIGHT_UP : DRAW_RECT_LEFT_UP;
                                else 
                                        state_nxt = forward ? DRAW_RECT_RIGHT_DOWN : DRAW_RECT_LEFT_DOWN;  
                        else
                                state_nxt = PASS_THROUGH;
                DRAW_RECT_LEFT_DOWN :    
                        if(mouse_left)
                                if(up)
                                        state_nxt = forward ? DRAW_RECT_RIGHT_UP : DRAW_RECT_LEFT_UP;
                                else 
                                        state_nxt = forward ? DRAW_RECT_RIGHT_DOWN : DRAW_RECT_LEFT_DOWN;  
                        else
                                state_nxt = PASS_THROUGH;
                DRAW_RECT_RIGHT_UP :    
                        if(mouse_left)
                                if(up)
                                        state_nxt = forward ? DRAW_RECT_RIGHT_UP : DRAW_RECT_LEFT_UP;
                                else 
                                        state_nxt = forward ? DRAW_RECT_RIGHT_DOWN : DRAW_RECT_LEFT_DOWN;  
                        else
                                state_nxt = PASS_THROUGH;
                DRAW_RECT_RIGHT_DOWN :    
                        if(mouse_left)
                                if(up)
                                        state_nxt = forward ? DRAW_RECT_RIGHT_UP : DRAW_RECT_LEFT_UP;
                                else 
                                        state_nxt = forward ? DRAW_RECT_RIGHT_DOWN : DRAW_RECT_LEFT_DOWN;  
                        else
                                state_nxt = PASS_THROUGH;
                PASS_THROUGH :  
                        if(mouse_left)
                                if(up)
                                        state_nxt = forward ? DRAW_RECT_RIGHT_UP : DRAW_RECT_LEFT_UP;
                                else 
                                        state_nxt = forward ? DRAW_RECT_RIGHT_DOWN : DRAW_RECT_LEFT_DOWN;  
                        else
                                state_nxt = PASS_THROUGH;
                default :       state_nxt = PASS_THROUGH;
                endcase

        end  

        // output sequential logic 
  
        always @(posedge pclk) begin
                ypos       <= ypos_tmp;
                xpos       <= xpos_tmp;
                xpos_mach  <= xpos_mach_nxt;
                ypos_mach  <= ypos_mach_nxt;
                ypos_mach1 <= ypos_mach1_nxt;
                ypos_mach2 <= ypos_mach2_nxt;
                freq_div   <= freq_div_nxt;
                forward    <= forward_nxt;
                multi      <= multi_nxt;
                wait_time  <= wait_time_nxt;  
                up         <= up_nxt;  
                right_cor  <= right_cor_nxt;
                left_cor   <= left_cor_nxt;
        end

        // output combinational logic

        always @* begin

                xpos_mach_nxt   = xpos_mach;
                ypos_mach_nxt   = ypos_mach;
                ypos_mach1_nxt  = ypos_mach1;
                ypos_mach2_nxt  = ypos_mach2;
                forward_nxt     = forward;
                ypos_tmp        = ypos_mach;
                xpos_tmp        = xpos_mach;
                freq_div_nxt    = freq_div;
                multi_nxt       = multi; 
                wait_time_nxt   = wait_time;
                up_nxt          = up;
                right_cor_nxt   = right_cor;
                left_cor_nxt    = left_cor;

                case (state) 
                RESET : begin         
                        forward_nxt    = 1'b1;
                        up_nxt         = 1'b0;
                        right_cor_nxt  = 750;
                        left_cor_nxt   = 0; 
                        multi_nxt      = 750;
                        xpos_tmp       = 12'b0;
                        ypos_tmp       = 12'b0;
                        xpos_mach_nxt  = 12'b0;
                        ypos_mach_nxt  = 12'b0;
                        ypos_mach1_nxt = 12'b0;
                        ypos_mach2_nxt = 12'b0;
                        freq_div_nxt   = 30'b0;
                        wait_time_nxt  = 400_000; 
                end
                DRAW_RECT_RIGHT_DOWN : begin
                        if (xpos_tmp >= MIDDLE)
                                up_nxt = 1'b1;
                        else  
                                up_nxt = up;          
                        if(freq_div == wait_time) begin
                                wait_time_nxt  = wait_time - multi;
                                xpos_mach_nxt  = xpos_mach + 1;
                                ypos_mach1_nxt = ((284 * xpos_mach) / 100); 
                                ypos_mach2_nxt = ((378*(xpos_mach * xpos_mach)) / 100_000);
                                ypos_mach_nxt  = ypos_mach1 - ypos_mach2;
                                freq_div_nxt   = 0;
                        end else begin
                                xpos_tmp      = xpos_mach;
                                ypos_tmp      = ypos_mach;
                                freq_div_nxt  = freq_div + 1;
                        end        
                end
                DRAW_RECT_RIGHT_UP : begin
                        if (xpos_tmp >= right_cor) begin
                                forward_nxt   = 1'b0;
                                up_nxt        = 1'b0;
                                right_cor_nxt = ((right_cor * 95) / 100);
                        end else begin 
                                forward_nxt    = forward;
                                up_nxt         = up;    
                                right_cor_nxt  = right_cor; 
                        end
                        if(freq_div == wait_time) begin
                                wait_time_nxt  = wait_time + multi;
                                xpos_mach_nxt  = xpos_mach + 1;
                                ypos_mach1_nxt = ((284 * xpos_mach) / 100); 
                                ypos_mach2_nxt = ((378*(xpos_mach * xpos_mach)) / 100_000);
                                ypos_mach_nxt  = ypos_mach1 - ypos_mach2;
                                freq_div_nxt   = 0;
                        end else begin
                                xpos_tmp      = xpos_mach;
                                ypos_tmp      = ypos_mach;
                                freq_div_nxt  = freq_div + 1;
                        end        
                end
                DRAW_RECT_LEFT_DOWN : begin
                        if (xpos_tmp <= MIDDLE) 
                                up_nxt = 1'b1;
                        else 
                                up_nxt = up;  
                        if(freq_div == wait_time) begin 
                                wait_time_nxt  = wait_time - multi;
                                xpos_mach_nxt  = xpos_mach - 1;
                                ypos_mach1_nxt = ((284 * xpos_mach) / 100); 
                                ypos_mach2_nxt = ((378*(xpos_mach * xpos_mach)) / 100_000);
                                ypos_mach_nxt  = ypos_mach1 - ypos_mach2;
                                freq_div_nxt   = 0;
                        end else begin
                                xpos_tmp      = xpos_mach;
                                ypos_tmp      = ypos_mach;
                                freq_div_nxt  = freq_div + 1;
                        end        
                end
                DRAW_RECT_LEFT_UP : begin
                        if (xpos_tmp <= left_cor) begin
                                forward_nxt = 1'b1;
                                up_nxt = 1'b0;
                                left_cor_nxt = 770 - right_cor;
                        end else begin 
                                forward_nxt  = forward;
                                up_nxt       = up; 
                                left_cor_nxt = left_cor;    
                        end
                        if(freq_div == wait_time) begin
                                wait_time_nxt  = wait_time + multi;
                                xpos_mach_nxt  = xpos_mach - 1;
                                ypos_mach1_nxt = ((284 * xpos_mach) / 100); 
                                ypos_mach2_nxt = ((378*(xpos_mach * xpos_mach)) / 100_000);
                                ypos_mach_nxt  = ypos_mach1 - ypos_mach2;
                                freq_div_nxt   = 0;
                        end else begin
                                xpos_tmp      = xpos_mach;
                                ypos_tmp      = ypos_mach;
                                freq_div_nxt  = freq_div + 1;
                        end        
                end
                PASS_THROUGH : begin     
                        xpos_tmp  = mouse_xpos;
                        ypos_tmp  = mouse_ypos;
                end  
                default : begin
                        xpos_tmp  = mouse_xpos;
                        ypos_tmp  = mouse_ypos;
                end
                endcase    
        end
endmodule
