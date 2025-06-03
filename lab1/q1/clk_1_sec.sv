module clock_1_sec #(
	parameter int unsigned N = 50000000
)(
   input logic clk, rst,
   output logic carry_out
);

    localparam COUNT_MAX = N;// 50MHz clock to 1 second pulse
    
    logic [26:0] count;
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 26'd0;
            carry_out <= 1'b0;
        end else if (count == COUNT_MAX) begin
            count <= 26'd0;
            carry_out <= 1'b1;
        end else begin
            count <= count + 26'd1;
            carry_out <= 1'b0;
        end
    end

endmodule