module FSM(
  input logic in,
  input logic clk,
  output logic out
);
  
  typedef enum {z_st,o_st,oz_st,ozo_st,ozoo_st,ozooz_st} sm_type; // z-stands for 0, o-stands for 1.
  sm_type current_state;
  sm_type next_state;
  initial begin
    current_state = z_st;
    next_state = z_st;
    out = 1'b0;
  end
  
  // Output logic
  always_comb begin
    out = 1'b0;
    case (current_state)
      ozooz_st: out = 1'b1;
      default: out = 1'b0;
    endcase
  end
  
  always_comb begin
    case (current_state) // cases of the FSM that detects an input sequence of 10110 
      z_st: begin
        if(in==1'b1) begin
          next_state = o_st;
        end
      end
      o_st: begin
        if(in==1'b0) begin
          next_state = oz_st;
        end
      end
      oz_st: begin
        if(in==1'b1) begin
          next_state = ozo_st;
        end
        else if(in==1'b0) begin
          next_state = z_st;
        end
      end
      ozo_st: begin
        if(in==1'b1) begin
          next_state = ozoo_st;
        end
        else if(in==1'b0) begin
          next_state = oz_st;
        end
      end
      ozoo_st: begin
        if(in==1'b1) begin
          next_state = o_st;
        end
        else if(in==1'b0) begin
          next_state = ozooz_st;
        end
      end
      ozooz_st: begin
        if(in==1'b1) begin
          next_state = ozo_st;
        end
        else if(in==1'b0) begin
          next_state = z_st;
        end
      end
    endcase
  end

  always_ff @(negedge clk) begin
    current_state <= next_state;
  end

endmodule
