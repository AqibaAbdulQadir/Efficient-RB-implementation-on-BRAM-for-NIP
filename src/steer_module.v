module steer_module (
    input  wire en,
    input  wire [`RB_ADDR-1:0] sel,
    input  wire [`BRAM_R_DATA_WIDTH-1:0] in,
    output wire [`BRAM_R_DATA_WIDTH-1:0] out
);
    genvar i, j;

    generate
        for(i = 0; i < `RBs; i = i + 1) begin : MUX_BANK
            wire [`BRAM_R_DATA_WIDTH-1:0] rotated_in;
            
            // rotate the input for this mux
            for(j = 0; j < `RBs; j = j + 1) begin : ROTATE
                assign rotated_in[j*`PIXEL_WIDTH +: `PIXEL_WIDTH] = 
                       in[((j+i)%`RBs)*`PIXEL_WIDTH +: `PIXEL_WIDTH];
            end
            mux_rb_to_1 m (en, sel, rotated_in, out[i*`PIXEL_WIDTH +: `PIXEL_WIDTH]);
        end
    endgenerate
endmodule
