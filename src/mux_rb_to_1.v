module mux_rb_to_1 (
    input en,
    input [`RB_ADDR-1:0] sel,
    input [`BRAM_R_DATA_WIDTH-1:0] in,
    output reg [`PIXEL_WIDTH-1:0] out
);
    always @(*) begin
        if (en) out = in[sel*`PIXEL_WIDTH +: `PIXEL_WIDTH];
        else out = 0;
    end
    
endmodule