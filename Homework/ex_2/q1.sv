module (
  input logic in,
  output logic out
);
  
  typedef enum {z_st,o_state,oz_st,ozo_st,ozoo_st,ozooz_st} sm_type; // z-stands for 0, o-stands for 1.
  sm_type current_state;
  sm_type next_state;
  initial begin
    current_state = z_st;
    out = 1'b0;
  end
  always_comb begin
    next_state = current_state;
    case (current_state)
