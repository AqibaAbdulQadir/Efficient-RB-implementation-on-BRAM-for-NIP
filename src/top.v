module top #(
    parameter DATA_WIDTH_W = 8,   // write port width
    parameter DATA_WIDTH_R = 32,  // read port width
    parameter BRAM_DEPTH   = 16384
)(
    input clk,
    input start,
    output complete,
    output [39:0] out
);
    wire en_e_mem_addr;
    wire en_w_bram_addr;
    wire en_r_bram_addr;
    wire en_a;
    wire en_b;
    wire [31:0] E_MEM_ADDR;
    wire [$clog2(BRAM_DEPTH / DATA_WIDTH_W)-1:0] W_BRAM_ADDR;
    wire [$clog2(BRAM_DEPTH / DATA_WIDTH_R)-1:0] R_BRAM_ADDR;
    wire [31:0] out_mm;
    wire [1:0] steer;
    wire [7:0] data_in_a;
    wire [31:0] hold_out;
    reg [31:0] curr;
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
        W_BRAM_ADDR,
        R_BRAM_ADDR 
    );

    external_memory_module em(
        E_MEM_ADDR,
        data_in_a
    );

    memory_module mm (
        // clk,
        en_a,
        W_BRAM_ADDR,
        data_in_a,
        en_b,
        R_BRAM_ADDR,
        out_mm
    );

    // assign hold_out[39:32] = data_in_a;

    steer_module sm (
        steer_en,
        steer,
        out_mm[31:24], out_mm[23:16], out_mm[15:8], out_mm[7:0], 
        hold_out[31:24], hold_out[23:16], hold_out[15:8], hold_out[7:0]
    );
    always @(posedge clk) curr <= hold_out;
    assign out = (en_e_mem_addr && en_r_bram_addr && !complete)? {data_in_a, curr}:40'bz;
    // assign out = {data_in_a, hold_out};
endmodule
