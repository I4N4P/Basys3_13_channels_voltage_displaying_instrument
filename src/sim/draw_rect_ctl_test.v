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
  wire data2,my_tick;
uart_control my_uart_control(
                .clk (clk),
                .rst (rst),
                .in(16'd0089),

                .sign(data2),
                .tick(my_tick)
                
        );

  // Describe a process that generates a clock
  // signal. The clock is 100 MHz.

  always
  begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
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
        rst = 1'b1;
        #10;
        rst = 1'b0;
    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");
    
    
    @(negedge my_tick) ;
    @(negedge my_tick) ;
    @(negedge my_tick) ;
    @(negedge my_tick) ;
    //@(negedge vs) $display("Info: negedge VS at %t",$time);
    //@(negedge vs) $display("Info: negedge VS at %t",$time);
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $stop;
  end

endmodule
