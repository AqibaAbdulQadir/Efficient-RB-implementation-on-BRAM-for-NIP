`include "params.vh"

module top (
    input clk,
    input start,
    output complete,
    output [`K*`PIXEL_WIDTH-1:0] out
);
    
    wire en_e_mem_addr;
    wire en_w_bram_addr;
    wire en_r_bram_addr;
    wire en_a;
    wire en_b;
    wire [`EMEM_W_ADDR_WIDTH-1:0] E_MEM_ADDR;
    wire [`BRAM_R_ADDR_WIDTH-1:0] R_BRAM_ADDR;
    wire [`BRAM_R_ADDR_WIDTH-1:0] W_BRAM_ADDR;
    wire [`RB_ADDR-1:0] W_BRAM_RB_SEL;
    wire [`BRAM_R_DATA_WIDTH-1:0] out_mm;
    wire [`RB_ADDR-1:0] steer;
    wire [`PIXEL_WIDTH-1:0] data_in_a;
    wire [`BRAM_R_DATA_WIDTH-1:0] hold_out;
    reg [`BRAM_R_DATA_WIDTH-1:0] curr;
    wire steer_en;
    
    control_module cm (        
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

    address_generator_module agm (
        clk,
        en_e_mem_addr,
        en_w_bram_addr,
        en_r_bram_addr,
        
        E_MEM_ADDR,
        R_BRAM_ADDR,
        W_BRAM_ADDR,
        W_BRAM_RB_SEL
    );

    external_memory_module em(
        E_MEM_ADDR,
        data_in_a
    );

    memory_module mm (
        clk,
        en_a,
        W_BRAM_ADDR,
        W_BRAM_RB_SEL,
        data_in_a,
        en_b,
        R_BRAM_ADDR,
        out_mm
    );

    // assign hold_out[39:32] = data_in_a;

    steer_module sm (
        steer_en,
        steer,
        out_mm, 
        hold_out
    );
    // always @(posedge clk) curr <= hold_out;
    assign out = (en_e_mem_addr && en_r_bram_addr && !complete)? {data_in_a, hold_out}: {`K*`PIXEL_WIDTH{1'bz}};
    // assign out = {data_in_a, hold_out};
endmodule
