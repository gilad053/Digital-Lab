module lab1_q2(
  input logic in,
  input logic clk,
  input logic rstb,
  output logic [5:0]cur_state,
  output logic out
);
  
  typedef enum logic [2:0] {z_st,o_st,oz_st,ozo_st,ozoo_st,ozooz_st} sm_type; // z-stands for 0, o-stands for 1.
  sm_type  current_state;
  sm_type  next_state;
  initial begin
    current_state = z_st;
    next_state = z_st;
    out = 1'b0;
	 cur_state = 6'b00000;
  end
  
  // Output logic
  always_comb begin
    out = 1'b0;
    case (current_state)
		z_st: begin
			cur_state = 6'b000001;
		end
		o_st: begin
			cur_state = 6'b000010;
		end
		oz_st: begin
			cur_state = 6'b000100;
		end
		ozo_st: begin
			cur_state = 6'b001000;
		end
		ozoo_st: begin
			cur_state = 6'b010000;
		end
      ozooz_st: begin
			out = 1'b1;
			cur_state = 1'b100000;
		end
      default: out = 1'b0;
    endcase
  end
  
  always_comb begin
    case (current_state) // cases of the FSM that detects an input sequence of 10110 
      z_st: begin
        if(in==1'b1) begin
          next_state = o_st;
        end else begin
			 next_state = current_state;
			 end
      end
      o_st: begin
        if(in==1'b0) begin
          next_state = oz_st;
        end else begin
			 next_state = current_state;
			 end
      end
      oz_st: begin
        if(in==1'b1) begin
          next_state = ozo_st;
        end
        else if(in==1'b0) begin
          next_state = z_st;
        end else begin
			 next_state = current_state;
			 end
      end
      ozo_st: begin
        if(in==1'b1) begin
          next_state = ozoo_st;
        end
        else if(in==1'b0) begin
          next_state = oz_st;
        end else begin
			 next_state = current_state;
			 end
      end
      ozoo_st: begin
        if(in==1'b1) begin
          next_state = o_st;
        end
        else if(in==1'b0) begin
          next_state = ozooz_st;
        end else begin
			 next_state = current_state;
			 end
      end
      ozooz_st: begin
        if(in==1'b1) begin
          next_state = ozo_st;
        end
        else if(in==1'b0) begin
          next_state = z_st;
        end else begin
			 next_state = current_state;
			 end
      end
		default next_state = z_st;
    endcase
  end

  always_ff @(posedge clk,negedge rstb) begin
    if(~rstb) begin
      current_state <= z_st;
    end else begin
      current_state <= next_state;
    end
  end

endmodule
