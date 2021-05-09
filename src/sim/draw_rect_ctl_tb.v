// File: draw_rect_ctl_tb.v
// This module generate the backround for vga

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_ctl_tb (
  input   wire pclk,
  input   wire rst, 

  output  reg [11:0] mouse_xpos,
  output  reg [11:0] mouse_ypos,
  output  reg mouse_left 
  
  
  );
  
  reg [11:0] xpos_nxt = 0,ypos_nxt = 0;
  reg [20:0] counter,counter_nxt = 0;
  reg mouse_left_nxt = 0;

  // Synchronical logic

  always @(posedge pclk)
    begin
      // pass these through if rst not activ then put 0 on the output.
      if (rst) begin
                mouse_xpos <= 12'b0;
                mouse_ypos <= 12'b0;
                mouse_left_nxt <= 1'b0;
                counter    <= 12'b0;
        end
        else begin
                mouse_xpos <= xpos_nxt;
                mouse_ypos <= ypos_nxt;
                mouse_left <= mouse_left_nxt;
                counter   <= counter_nxt;
        end
    end

    // Combinational logic

  always @*
   begin
        counter_nxt = counter + 1;
        
        if(counter == 3000)
            mouse_left_nxt = 1'b1;
        else
            mouse_left_nxt =  mouse_left;
        if(counter < 2000) begin
                xpos_nxt =  12'b0 ;
                ypos_nxt =  12'b0 ;
        end else if((counter > 2000) && (counter < 4000)) begin 
                xpos_nxt =  mouse_xpos + 1 ;
                ypos_nxt =  mouse_ypos + 1 ;          
        end else if(counter == 800_000) begin
                counter_nxt = 0;
                mouse_left_nxt = 1'b0;
        end else begin
                mouse_left_nxt = mouse_left;
        end
   end

endmodule
