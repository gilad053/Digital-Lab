// 0-9 counter
module counter(
	input logic clk, rst, en,
	output logic[3:0] counter,
	output logic carry_out
);

localparam MAX = 4'd9 ;
localparam zero = 4'd0 ;

logic[3:0] out ;

always_ff @(posedge clk, negedge rst)
	if(~rst) begin
      counter <= zero ;
      carry_out <= 1'b0 ;
	end
	else if (en) begin
		if (counter >= MAX) begin
			counter <= zero ;
			carry_out <= 1'b1 ;
		end
		else begin
			counter <= counter + 4'd1 ;
			carry_out <= 1'b0 ;
		end
	end
endmodule