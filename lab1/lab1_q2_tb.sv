`timescale 1ns/1ps

module tb_lab1_q2;

  // Inputs
  logic in;
  logic clk;
  logic rstb;

  // Outputs
  logic [5:0] cur_state;
  logic out;

  // Instantiate the Unit Under Test (UUT)
  lab1_q2 uut (
    .in(in),
    .clk(clk),
    .rstb(rstb),
    .cur_state(cur_state),
    .out(out)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // 100MHz clock

  // Stimulus procedure
  initial begin
    $dumpfile("lab1_q2_tb.vcd"); // for GTKWave
    $dumpvars(0, tb_lab1_q2);
    
    // Initialize
    rstb = 0;
    in = 0;

    // Apply reset
    #10;
    rstb = 1;
    #10;

    // --- Test sequence: 10110 ---
    // This should trigger the output 'out' to be 1 for one clock cycle

    send_bit(1); // o
    send_bit(0); // z
    send_bit(1); // o
    send_bit(1); // o
    send_bit(0); // z --> triggers out=1

    // Hold some zeros to see FSM go back to start
    send_bit(0);
    send_bit(0);

    // Another sequence to check repeatability
    send_bit(1); // o
    send_bit(0); // z
    send_bit(1); // o
    send_bit(1); // o
    send_bit(0); // z --> triggers out=1 again

    // Test reset in the middle of sequence
    send_bit(1);
    send_bit(0);
    rstb = 0; // Apply reset
    #10;
    rstb = 1;
    #10;
    send_bit(1); // should be treated as new sequence

    #50;
    $finish;
  end

  // Helper task to send input bit and wait one cycle
  task send_bit(input logic val);
    begin
      in = val;
      #10;
    end
  endtask

endmodule
