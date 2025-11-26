`include "params.vh"

module memory_module (
    input clk,
    input  wire EN_A,
    input wire [`BRAM_ADDR-1:0] BRAM_W,
    input  wire [`BRAM_DEPTH_ADDR-1:0] ADDR_A,
    input  wire [`BRAM_W_DATA_WIDTH-1:0] DIN_A,

    input  EN_B,
    input   [`BRAM_R_ADDR_WIDTH-1:0] ADDR_B,
    output  [`BRAM_R_DATA_WIDTH-1:0] DOUT_B
);
    
    genvar i;
    wire [(`BRAMs<<5)-1:0] DOUT;

    generate
        for (i = 0; i < `BRAMs; i = i+1) begin : BRAMS
            BRAM18 bram (
                .clk(clk),
                .w_en(EN_A && (BRAM_W == i)),
                .w_addr(ADDR_A),
                .w_data(DIN_A),
                .r_en(EN_B),
                .r_addr(ADDR_B),
                .r_data(DOUT[i<<5+: 32])
            );
        end
    endgenerate

    assign DOUT_B = DOUT[`BRAM_R_DATA_WIDTH-1:0];

endmodule