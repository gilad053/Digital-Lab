module Traffic_Light(
    input logic[1:0] in,
    input logic clk,
    input logic resetb,
    output logic[1:0] out
);
    typedef enum {RED,YELLOW,GREEN} sm_light;
    sm_light current_light;
    sm_light next_light;
    initial begin       //intializion of traffic light 
        current_light = RED;
        next_light = RED;
        out = 2'b00;
    end

    always_comb begin  // output logic
        case (current_light)
            RED: out = 2'b00;
            YELLOW: out = 2'b01;
            GREEN: out = 2'b10;
    
        endcase
    end 
    
    always_comb begin //FSM states.
        case(current_light)
            RED: begin
                if(in== 2'b01) begin
                    next_light=YELLOW;
                end
                else begin
                    next_light=RED;
                end
            end
            YELLOW: begin
                if(in == 2'b10) begin
                    next_light=GREEN;
                end else if(in==2'b00 || in==2'b01)begin
                    next_light = YELLOW;
                end else begin
                    next_light = RED;
                end
            end
            GREEN: begin
                if(in == 2'b00) begin
                    next_light = GREEN;
                end
                else begin
                    next_light = YELLOW;
                end
            end
        endcase
    end

    always_ff @(posedge clk ,negedge resetb) begin
        if (resetb==1'b0) begin
            current_light = RED;
            next_light = RED;
            out = 2'b00;
        end
        else begin
            current_light <= next_light;
        end
    end
endmodule



