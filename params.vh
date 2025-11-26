`define K 17 // Kernel Size(Usually odd numbered)
`define RB_DEPTH  512
`define EMEM_W_ADDR_WIDTH  32 // external memory of 4GB
`define PIXEL_WIDTH  8
`define IMAGE_SIZE  512*512
`define BRAM_DEPTH_ADDR 11 // in pixels
`define BRAMs (((`K-1) + 4 - 1) >> 2) // as ceil(A / B)    (A + B - 1) / B
`define RBs (`K-1) //(`BRAM_DEPTH / `RB_DEPTH)
`define TOTAL_DEPTH (`RBs * `RB_DEPTH)// can be BRAMS*2048  later see // in terms of pixels(1 BRAM has 16K(2^14) locs or space of 2^11 pixels)
`define BRAM_W_ADDR_WIDTH ($clog2(`TOTAL_DEPTH)) // can be used for writing address bits in BRAM
`define BRAM_R_ADDR_WIDTH ($clog2(`RB_DEPTH)) // can be used for writing address bits in BRAM
`define BRAM_R_DATA_WIDTH (`RBs * `PIXEL_WIDTH) // in terms of bits
`define BRAM_W_DATA_WIDTH (`PIXEL_WIDTH) // in terms of bits
`define RB_ADDR ($clog2(`RBs))
`define BRAM_ADDR ($clog2(`BRAMs))
`define IMAGE_ADDR ($clog2(`IMAGE_SIZE))