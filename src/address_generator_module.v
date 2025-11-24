`include "params.vh"

module address_generator_module (
    input  wire clk,

    input  wire en_e_mem_addr,
    input  wire en_w_bram_addr,
    input  wire en_r_bram_addr,

    output reg [`EMEM_W_ADDR_WIDTH-1:0] E_MEM_ADDR,
    output reg [`BRAM_W_ADDR_WIDTH-1:0] W_BRAM_ADDR,
    output reg [`BRAM_R_ADDR_WIDTH-1:0] R_BRAM_ADDR
);
    

    // For write pattern
    reg [`RB_ADDR-1:0] row_index;           // 0..3
    reg [`BRAM_R_ADDR_WIDTH-1:0] loc_index;           // 0..511

    // For reset detection
    // wire all_disabled = !en_e_mem_addr && !en_w_bram_addr && !en_r_bram_addr;

    // MAIN LOGIC
    initial begin
        E_MEM_ADDR   <= -1;
        W_BRAM_ADDR  <= 0;
        R_BRAM_ADDR  <= 0;

        row_index <= 0;
        loc_index <= 0;
    end
    always @(posedge clk) begin
        if (en_e_mem_addr)
                E_MEM_ADDR <= E_MEM_ADDR + 1;

        if (en_w_bram_addr) begin
            W_BRAM_ADDR <= row_index + ((loc_index)*`RBs);

            if (loc_index == (`RB_DEPTH-1)) begin
                loc_index <= 0;
                row_index <= (row_index == (`RBs-1)) ? 0 : row_index + 1;
            end
            else loc_index <= loc_index + 1;
        end
        if (en_r_bram_addr) R_BRAM_ADDR <= R_BRAM_ADDR + 1; // it can only go till 511 in all cases
    end

endmodule
