module counter (
				start_count,
				end_count,
				clk,
				resetb);
				
	// input and output declrations
	
	input wire start_count;
	output reg end_count;
	input wire resetb;
	input wire clk;
	
	// internal signals
	reg [5:0] counter;
	reg en_count;
	wire end_count_internal;
	
	//deafult parameter value
	parameter TIME_TO_COUNT = 6'b11_1111;
	
	assign end_count_internal = (counter == TIME_TO_COUNT - 6'b00_0001);
	 
	//counter enable
	always @(posedge clk or negedge resetb)
		begin
			if(~resetb)
				    begin
					    en_count <= 1'b0;
			       	end
			else if(start_count)
				    begin
					    en_count <= 1'b1;
				    end
			else if(end_count)
				    begin
					    en_count <= 1'b0;
				    end
			else
					begin
						 en_count <= en_count;
					end
		end
	
	
	// counter flop
	always @(posedge clk or negedge resetb)
		begin
				if(~resetb)
				    begin
					      counter <= 6'b00_0000;
			       	end
				else if(en_count)
				      begin
					      counter <= counter + 6'b00_0001;
				      end
				else 
				      begin
					     counter <= 6'b00_0000;
				      end
		end
		


	//sample register end_count
	always @(posedge clk or negedge resetb)
		begin
			if(~resetb)
				begin
					end_count <= 1'b0;
				end
			else 
				begin
					if (end_count_internal) begin
						end_count<= 1'b1;
					end else begin
						end_count <= end_count_internal;
				end
			end
		end
		
		
endmodule //counter