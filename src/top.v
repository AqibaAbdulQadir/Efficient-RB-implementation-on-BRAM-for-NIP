module top #(
`include "par.vh"
)(
    input clk,
    input start,
    output read_allowed,
    output [EMEM_W_ADDR_WIDTH-1:0] E_MEM_ADDR,
    input [PIXEL_WIDTH-1:0] data_in_a,
    output complete,
    output [K*PIXEL_WIDTH-1:0] out
);

    wire en_e_mem_addr;
    wire en_w_bram_addr;
    wire en_r_bram_addr;
    wire en_a;
    wire en_b;
    
    wire [BRAM_ADDR-1:0] BRAM_W;
    wire [BRAM_DEPTH_ADDR-1:0] W_BRAM_ADDR;
    wire [BRAM_R_ADDR_WIDTH-1:0] R_BRAM_ADDR;


    wire [BRAM_R_DATA_WIDTH-1:0] out_mm;
    wire [RB_ADDR-1:0] steer;
   
    wire [BRAM_R_DATA_WIDTH-1:0] hold_out;
    reg [BRAM_R_DATA_WIDTH-1:0] curr;
    wire steer_en;

    control_module #(    
    .K(K),
    .RB_DEPTH(RB_DEPTH),
    .EMEM_W_ADDR_WIDTH(EMEM_W_ADDR_WIDTH),
    .PIXEL_WIDTH(PIXEL_WIDTH),
    .IMAGE_SIZE(IMAGE_SIZE),
    .BRAM_DEPTH_ADDR(BRAM_DEPTH_ADDR),
    .BRAMs(BRAMs),
    .RBs(RBs),
    .TOTAL_DEPTH(TOTAL_DEPTH),
    .BRAM_W_ADDR_WIDTH(BRAM_W_ADDR_WIDTH),
    .BRAM_R_ADDR_WIDTH(BRAM_R_ADDR_WIDTH),
    .BRAM_R_DATA_WIDTH(BRAM_R_DATA_WIDTH),
    .BRAM_W_DATA_WIDTH(BRAM_W_DATA_WIDTH),
    .RB_ADDR(RB_ADDR),
    .BRAM_ADDR(BRAM_ADDR),
    .IMAGE_ADDR(IMAGE_ADDR)) cm (        
        clk,
        start,
        complete,
        en_e_mem_addr,
        en_w_bram_addr,
        en_r_bram_addr,
        en_a,
        en_b,
        steer,
        steer_en
    );

    address_generator_module #(
        .K(K),
    .RB_DEPTH(RB_DEPTH),
    .EMEM_W_ADDR_WIDTH(EMEM_W_ADDR_WIDTH),
    .PIXEL_WIDTH(PIXEL_WIDTH),
    .IMAGE_SIZE(IMAGE_SIZE),
    .BRAM_DEPTH_ADDR(BRAM_DEPTH_ADDR),
    .BRAMs(BRAMs),
    .RBs(RBs),
    .TOTAL_DEPTH(TOTAL_DEPTH),
    .BRAM_W_ADDR_WIDTH(BRAM_W_ADDR_WIDTH),
    .BRAM_R_ADDR_WIDTH(BRAM_R_ADDR_WIDTH),
    .BRAM_R_DATA_WIDTH(BRAM_R_DATA_WIDTH),
    .BRAM_W_DATA_WIDTH(BRAM_W_DATA_WIDTH),
    .RB_ADDR(RB_ADDR),
    .BRAM_ADDR(BRAM_ADDR),
    .IMAGE_ADDR(IMAGE_ADDR)) agm (
        clk,
        en_e_mem_addr,
        en_w_bram_addr,
        en_r_bram_addr,

        E_MEM_ADDR,

        BRAM_W,
        W_BRAM_ADDR,
        R_BRAM_ADDR 
    );
     
    memory_module #(    .K(K),
    .RB_DEPTH(RB_DEPTH),
    .EMEM_W_ADDR_WIDTH(EMEM_W_ADDR_WIDTH),
    .PIXEL_WIDTH(PIXEL_WIDTH),
    .IMAGE_SIZE(IMAGE_SIZE),
    .BRAM_DEPTH_ADDR(BRAM_DEPTH_ADDR),
    .BRAMs(BRAMs),
    .RBs(RBs),
    .TOTAL_DEPTH(TOTAL_DEPTH),
    .BRAM_W_ADDR_WIDTH(BRAM_W_ADDR_WIDTH),
    .BRAM_R_ADDR_WIDTH(BRAM_R_ADDR_WIDTH),
    .BRAM_R_DATA_WIDTH(BRAM_R_DATA_WIDTH),
    .BRAM_W_DATA_WIDTH(BRAM_W_DATA_WIDTH),
    .RB_ADDR(RB_ADDR),
    .BRAM_ADDR(BRAM_ADDR),
    .IMAGE_ADDR(IMAGE_ADDR)) mm (
        clk,
        en_a,
        BRAM_W,
        W_BRAM_ADDR,
        data_in_a,

        en_b,
        R_BRAM_ADDR,
        out_mm
    );

    // assign hold_out[39:32] = data_in_a;

    steer_module #(    .K(K),
    .RB_DEPTH(RB_DEPTH),
    .EMEM_W_ADDR_WIDTH(EMEM_W_ADDR_WIDTH),
    .PIXEL_WIDTH(PIXEL_WIDTH),
    .IMAGE_SIZE(IMAGE_SIZE),
    .BRAM_DEPTH_ADDR(BRAM_DEPTH_ADDR),
    .BRAMs(BRAMs),
    .RBs(RBs),
    .TOTAL_DEPTH(TOTAL_DEPTH),
    .BRAM_W_ADDR_WIDTH(BRAM_W_ADDR_WIDTH),
    .BRAM_R_ADDR_WIDTH(BRAM_R_ADDR_WIDTH),
    .BRAM_R_DATA_WIDTH(BRAM_R_DATA_WIDTH),
    .BRAM_W_DATA_WIDTH(BRAM_W_DATA_WIDTH),
    .RB_ADDR(RB_ADDR),
    .BRAM_ADDR(BRAM_ADDR),
    .IMAGE_ADDR(IMAGE_ADDR)) sm (
        steer_en,
        steer,
        out_mm, 
        hold_out
    );
    // always @(posedge clk) curr <= hold_out;
    assign out = (en_e_mem_addr && en_r_bram_addr && !complete)? {data_in_a, hold_out}: {K*PIXEL_WIDTH{1'bz}};
    assign read_allowed = en_r_bram_addr && en_w_bram_addr;
    // assign out = {data_in_a, hold_out};
endmodule
