module tb_counter;

    logic clk;
    logic rst;
    logic en;
    logic [3:0] counter;
    logic carry_out;

    // Instantiate the counter
    counter uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .counter(counter),
        .carry_out(carry_out)
    );

    // Generate clock (period = 10ns)
    always #2 clk = ~clk;

    // Enable signal toggles high every 4 clocks
    initial begin
        clk = 0;
        rst = 0;
        en  = 0;
        #12;

        rst = 1; // release reset

        // Run for 12 'seconds'
        repeat (12) begin
            en = 0;
            #6;  
            en = 1;
            #2;  // 1 clock cycle
            en = 0;
			end
			
			// tests the reset
			rst = 0 ;
			repeat (5) begin
            en = 0;
            #6;  
            en = 1;
            #2;  // 1 clock cycle
            en = 0;
			end
			rst = 1 ;
			repeat (5) begin
            en = 0;
            #6;  
            en = 1;
            #2;  // 1 clock cycle
            en = 0;
        end

        $finish;
    end

    initial begin
        $display("Time |\tclk\trst\ten\tcounter\tcarry_out");
        $monitor("%0t\t%b\t%b\t%b\t%0d\t%b", $time, clk, rst, en, counter, carry_out);
    end

endmodule