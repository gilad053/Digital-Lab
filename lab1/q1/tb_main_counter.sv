`timescale 1ns/1ps

module tb_main_counter;

  // Signals
  logic clk;
  logic resetb;
  logic [6:0] segments;
  logic [6:0] anodes;

  // Instantiate the DUT (Device Under Test)
  main_counter uut (
    .CLK_50(clk),
    .rst(resetb),
    .HEX0(segments),
    .HEX1(anodes)
  );

  // Clock generation: 100 MHz clock (10ns period)
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset logic
  initial begin
    resetb = 0;
    #20;
    resetb = 1;
  end

  // Waveform dump
  initial begin
    $dumpfile("main_counter.vcd");
    $dumpvars(0, tb_main_counter);
  end

  // Monitor output
  initial begin
    $display("Time\tclk\tresetb\tsegments\tanodes");
    $monitor("%0t\t%b\t%b\t%07b\t%04b", $time, clk, resetb, segments, anodes);
  end

  // Simulation time limit
  initial begin
    #500000;  // Simulate for 500 us (or more depending on your clk_1_sec setup)
    $finish;
  end

endmodule
