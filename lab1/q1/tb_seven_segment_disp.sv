`timescale 1ns/1ps

module tb_seven_segment_disp;

  logic [3:0] value;       // 4-bit input
  logic [6:0] segments;    // 7-bit output

  // Instantiate the DUT
  seven_segment_disp uut (
    .digit(value),
    .segments(segments)
  );

  // Waveform dump
  initial begin
    $dumpfile("seven_segment_disp.vcd");
    $dumpvars(0, tb_seven_segment_disp);
  end

  // Test all 16 values
  initial begin
    $display("Time\tValue\tSegments");
    for (int i = 0; i < 16; i++) begin
      value = i;
      #10;  // Wait for signals to settle
      $display("%0t\t%0d\t%b", $time, value, segments);
    end
    $finish;
  end

endmodule
