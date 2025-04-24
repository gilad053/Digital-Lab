module Traffic_Control(
    input logic clk,
    input logic rstb
);
logic [1:0] EW_ctrl;
logic   EW_rstb;
logic [1:0] EW_out;
logic [1:0] NS_ctrl;
logic   NS_rstb;
logic [1:0] NS_out;

Traffic_Light EW_light(
    .in(EW_ctrl),
    .clk(clk),
    .resetb(EW_rstb),
    .out(EW_out)
)  ;

Traffic_Light NS_light(
    .in(NS_ctrl),
    .clk(clk),
    .resetb(NS_rstb),
    .out(NS_out)
)  ;
logic start_count;
logic end_count ;
logic count_rst;

counter #(.TIME_TO_COUNT(6'b00_0100)) ctrl_counter(
    .start_count(start_count),
    .end_count(end_count),
    .clk(clk),
    .resetb(count_rst)
);

logic phase; // a "flag" bit for the control unit to know which traffic light to operate.
             // phase =1 operate EW, phase=0 operate NS
logic count_rst_flag;
typedef enum  {EW_pass,NS_pass,NO_traffic} sm_junction; // machine states for who is passing
// NO_traffic-means two red lights, EW_pass- EW light will enter operation cycle, NS_pass- NS light will enter operation cycle
    sm_junction current;
    sm_junction next;
    initial begin
        current = NO_traffic; 
        next = NO_traffic;
        phase = 1'b1;
        start_count = 1'b0;
        count_rst = 1'b1;
        EW_ctrl = 2'b00;
        EW_rstb = 1'b1;
        NS_ctrl = 2'b00;
        NS_rstb = 1'b1;
        count_rst_flag = 1'b0;
    end
logic phase_nxt;
always_comb begin // FSM cases
    next= current;
    // start_count = 1'b1;
    EW_ctrl= 2'b00;
    NS_ctrl= 2'b00;
    phase_nxt= phase;
    if (count_rst_flag) begin
        count_rst_flag = 1'b0;
        count_rst = 1'b0;
    end else begin
        count_rst= 1'b1;
    end 


    case(current)
        NO_traffic: begin
            if(phase==1'b1) begin
                next = EW_pass;
            end
            else begin
                next = NS_pass;
            end
        end
        EW_pass: begin // light traffic cycle RED->YELLOW_1->GREEN->YELLOW_2->RED
            
            if(EW_out==2'b00) begin //RED
                start_count = 1'b1;
                EW_ctrl = 2'b01; 
            end
            else if(EW_out==2'b01 && end_count==1'b1 && phase==1'b1) begin // YELLOW_1 change light only when count ends
                count_rst_flag = 1'b1;
                start_count = 1'b1;
                EW_ctrl = 2'b10;
                phase_nxt = 1'b0;
            end //else if(EW_out==2'b01) begin // YELLOW waiting to counter to finish


            else if(EW_out ==2'b10 && end_count==1'b1) begin // GREEN
                count_rst_flag = 1'b1;
                start_count = 1'b1;
                EW_ctrl = 2'b01;
            end
            else if(EW_out==2'b01 && end_count==1'b1 && phase==1'b0) begin // YELLOW_2
                count_rst_flag = 1'b1;
                EW_ctrl = 2'b11; // change light to RED
                next = NO_traffic;
            end  
        end
        NS_pass: begin // light traffic cycle RED->YELLOW_1->GREEN->YELLOW_2->RED
            if(NS_out==2'b00) begin //RED
                start_count = 1'b1;
                NS_ctrl = 2'b01; 
            end
            else if(NS_out==2'b01 && end_count==1'b1 && phase==1'b0) begin // YELLOW_1 change light only when count ends
                count_rst_flag = 1'b1;
                start_count = 1'b1;
                NS_ctrl = 2'b10;
                phase_nxt = 1'b1;
            end
            else if(NS_out ==2'b10 && end_count==1'b1) begin // GREEN
                count_rst_flag = 1'b1;
                start_count = 1'b1;
                NS_ctrl = 2'b01;
            end
            else if(NS_out==2'b01 && end_count==1'b1 && phase==1'b1) begin // YELLOW_2
                count_rst_flag = 1'b1;
                NS_ctrl = 2'b11; // change light to RED
                next = NO_traffic;
            end  
        end
    endcase
end

always_ff @(posedge clk ,negedge rstb) begin //sync block
    if(~rstb) begin
        current<= NO_traffic;
        phase<= 1'b1;
        EW_rstb<= 1'b0;   // hold the sub‑modules in reset
        NS_rstb<= 1'b0;
        count_rst_flag = 1'b0;
        count_rst = 1'b0;
    end
    else begin
        current<=next;
        EW_rstb<= 1'b1;
        NS_rstb<= 1'b1;
        phase <= phase_nxt;
    end
end

endmodule

