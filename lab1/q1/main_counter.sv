// Main module
module main_counter(
	input logic CLK_50, rst,
	output logic[6:0] HEX0, HEX1
);

// clock module
clock_1_sec clock_1_sec_inst
(
	.clk(CLK_50) ,	// input  clk_sig
	.rst(rst) ,	// input  rst_sig
	.carry_out(clk_out) 	// output  carry_out_sig
);

defparam clock_1_sec_inst.N = 'd2;

//seconds counter
counter counter_sec
(
	.clk(CLK_50) ,	// input  clk_sig
	.rst(rst) ,	// input  rst_sig
	.en(clk_out) ,	// input  en_sig
	.counter(sec_counter) ,	// output [3:0] counter_sig
	.carry_out(sec_carry_out) 	// output  carry_out_sig
);

//tens counter
counter counter_tens
(
	.clk(CLK_50) ,	// input  clk_sig
	.rst(rst) ,	// input  rst_sig
	.en(sec_carry_out) ,	// input  en_sig
	.counter(tens_counter) ,	// output [3:0] counter_sig
	.carry_out(tens_carry_out) 	// output  carry_out_sig
);

//seconds displayer
seven_segment_disp seven_segment_disp_sec
(
	.digit(sec_counter) ,	// input [3:0] digit_sig
	.segments(HEX0) 	// output [6:0] segments_sig
);

//tens displayer
seven_segment_disp seven_segment_disp_inst
(
	.digit(tens_counter) ,	// input [3:0] digit_sig
	.segments(HEX1) 	// output [6:0] segments_sig
);

endmodule