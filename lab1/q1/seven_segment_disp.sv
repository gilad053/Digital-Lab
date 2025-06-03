// seven segments controller
module seven_segment_disp (
    input logic [3:0] digit, // 4-bit input representing 0-9
    output logic [6:0] segments // 7-bit output bus for seven-segment display
);

    always_comb begin
        case (digit)
            4'd0: segments = 7'b1000000 ;// Display 0
            4'd1: segments = 7'b1111001 ;// Display 1
            4'd2: segments = 7'b0100100 ;// Display 2
            4'd3: segments = 7'b0110000 ;// Display 3
            4'd4: segments = 7'b0011001 ;// Display 4
            4'd5: segments = 7'b0010010 ;// Display 5
            4'd6: segments = 7'b0000010 ;// Display 6
            4'd7: segments = 7'b1111000 ;// Display 7
            4'd8: segments = 7'b0000000 ;// Display 8
            4'd9: segments = 7'b0010000 ;// Display 9
            default: segments = 7'b1111111 ;// Blank display
        endcase
    end

endmodule