module mux_4_to_1 (
    input en,
    input [1:0] sel,
    input [7:0] in0, in1, in2, in3,
    output reg [7:0] out
);

    always @(*) begin
        if (en) begin
            case (sel)
                2'b00: out = in0;
                2'b01: out = in1;
                2'b10: out = in2;
                2'b11: out = in3;
            endcase
        end
        else out = 8'b0;
    end
    
endmodule