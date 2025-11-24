`include "params.vh"

module memory_module (
    input clk,
    input  wire EN_A,
    input  wire [`BRAM_R_ADDR_WIDTH-1:0] ADDR_A,
    input  wire [`RB_ADDR-1:0] RB_A,
    input  wire [`BRAM_W_DATA_WIDTH-1:0] DIN_A,

    input  wire EN_B,
    input  wire [`BRAM_R_ADDR_WIDTH-1:0] ADDR_B,
    output wire  [`BRAM_R_DATA_WIDTH-1:0] DOUT_B
);


    // // (* ram_style = "block" *)  // uncomment in Vivado
    // reg [`BRAM_W_DATA_WIDTH-1:0] bram [0:`BRAM_DEPTH-1];
    // reg [`BRAM_R_DATA_WIDTH-1:0] readpack;
    // integer i;

    // // WRITE Port (Port A)
    // always @(posedge clk) begin
    //     if (EN_A)
    //         bram[ADDR_A] <= DIN_A;
    // end

    // // READ Port (Port B) - packs 4 consecutive pixels into 32-bit word
    // always @(posedge clk)
    //     if (EN_B) 
    //         for (i=0; i<`RBs; i=i+1) 
    //             DOUT_B[i*`PIXEL_WIDTH +: `PIXEL_WIDTH] <= bram[(ADDR_B*`RBs)+i];
    //     else
    //         DOUT_B <= 0;
    genvar i;
    wire [`RBs-1:0] one_hot_RB ;
    generate
        for (i = 0; i < `RBs; i = i+1) begin : RBs
            
            // Each RB instantiated as an IP
            m20k #(
                .WIDTH(`PIXEL_WIDTH),
                .DEPTH(`RB_DEPTH)
            ) rb_inst (
                .clk(clk),
                .w_en(EN_A && RB_A == i),
                .w_addr(ADDR_A),
                .w_data(DIN_A),
                .r_addr(ADDR_B),
                .r_data(DOUT_B[i*`PIXEL_WIDTH +: `PIXEL_WIDTH])
            );
        end
    endgenerate
endmodule
