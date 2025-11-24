`include "params.vh"

module memory_module (
    
    input  wire EN_A,
    input  wire [`BRAM_W_ADDR_WIDTH-1:0] ADDR_A,
    input  wire [`BRAM_W_DATA_WIDTH-1:0] DIN_A,

    input  wire EN_B,
    input  wire [`BRAM_R_ADDR_WIDTH-1:0] ADDR_B,
    output reg  [`BRAM_R_DATA_WIDTH-1:0] DOUT_B
);

    

    // Number of addressable BRAM_DEPTH for write port
    // localparam LOCATIONS = BRAM_DEPTH;

    // (* ram_style = "block" *)  // uncomment in Vivado
    reg [`BRAM_W_DATA_WIDTH-1:0] bram [0:`BRAM_DEPTH-1];
    reg [`BRAM_R_DATA_WIDTH-1:0] readpack;
    integer i;

    initial begin
        for (i = 0; i < `BRAM_DEPTH; i = i + 1)
            bram[i] = 0;
    end

    // WRITE Port (Port A)
    always @(*) begin
        if (EN_A)
            bram[ADDR_A] <= DIN_A;
    end

    // READ Port (Port B) - packs 4 consecutive pixels into 32-bit word
    always @(*)
        if (EN_B) 
            for (i=0; i<`RBs; i=i+1) 
                DOUT_B[i*`PIXEL_WIDTH +: `PIXEL_WIDTH] = bram[(ADDR_B*`RBs)+i];
        else
            DOUT_B = 0;
endmodule
