`timescale 1ns/1ps

module FSM_tb;

  // Testbench signals
  logic clk;
  logic in;
  logic out;

  // Instantiate the DUT
  FSM dut (
    .clk(clk),
    .in(in),
    .out(out)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;  // 100 MHz clock

  // Stimulus sequence
  logic [7:0] input_sequence [0:15];

  initial begin
        // Enable waveform dumping
    $dumpfile("fsm_wave.vcd");   // VCD output file
    $dumpvars(0, FSM_tb);        // Dump everything under this testbench

    $display("Starting FSM Test for pattern 10110 (negedge triggered)");
    $display("Time | clk | in | out | Notes");

    // Initialize
    clk = 0;
    in = 0;

    // Prepare sequence: contains 10110
    input_sequence[0] = 0;
    input_sequence[1] = 1;
    input_sequence[2] = 0;
    input_sequence[3] = 1;
    input_sequence[4] = 1;
    input_sequence[5] = 0;  // <-- Output should go high here
    input_sequence[6] = 1;
    input_sequence[7] = 0;

    // Apply inputs on each *negative edge*
    for (int i = 0; i < 8; i++) begin
      @(negedge clk);
      in = input_sequence[i];
    end

    #20;
    $finish;
  end

  // Monitor on each clock edge
  always @(negedge clk) begin
    $display("%4t |  %b   |  %b  |  %b   %s", 
      $time, clk, in, out, (out ? "<-- Pattern 10110 detected!" : ""));
  end

endmodule
