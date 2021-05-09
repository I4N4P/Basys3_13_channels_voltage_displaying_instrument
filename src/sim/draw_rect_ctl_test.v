// File: draw_rect_ctl_test.v
// This is a top level testbench for the
// vga_example design, which is part of
// the EE178 Lab #4 assignment.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

module draw_rect_ctl_test;

  // Declare wires to be driven by the outputs
  // of the design, and regs to drive the inputs.
  // The testbench will be in control of inputs
  // to the design, and will check the outputs.
  // Then, instantiate the design to be tested.
  reg rst;
  reg clk;
  wire mouse_left;
  wire [11:0] mouse_xpos, mouse_ypos;
  // Instantiate the vga_example module.
  
  draw_rect_ctl_tb my_draw_rect_ctl_tb (
    .pclk(clk),
    .rst(rst),

    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos)

  );

  draw_rect_ctl my_draw_rect_ctl (
    .pclk(clk),
    .rst(rst),

    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos)

  );

  // Describe a process that generates a clock
  // signal. The clock is 100 MHz.

  always
  begin
    clk = 1'b0;
    #12;
    clk = 1'b1;
    #13;
  end

  // Assign values to the input signals and
  // check the output results. This template
  // is meant to get you started, you can modify
  // it as you see fit. If you simply run it as
  // provided, you will need to visually inspect
  // the output waveforms to see if they make
  // sense...

  initial  
  begin
        rst = 1'b0;
    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");
    
    
    wait (mouse_ypos > 99);
        #100;
        rst = 1'b1;
        #100;
        rst = 1'b0;
    @(negedge mouse_left) ;
    @(negedge mouse_left) ;
    //@(negedge vs) $display("Info: negedge VS at %t",$time);
    //@(negedge vs) $display("Info: negedge VS at %t",$time);
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $stop;
  end

endmodule
