module address_generator_module #(
`include "par.vh"
) (
    input  wire clk,

    input  wire en_e_mem_addr,
    input  wire en_w_bram_addr,
    input  wire en_r_bram_addr,

    output reg [EMEM_W_ADDR_WIDTH-1:0] E_MEM_ADDR,
    // output reg [BRAM_W_ADDR_WIDTH-1:0] W_BRAM_ADDR,
    output reg [BRAM_ADDR-1:0] BRAM_W,
    output reg [BRAM_DEPTH_ADDR-1:0] W_BRAM_ADDR,
    output reg [BRAM_R_ADDR_WIDTH-1:0] R_BRAM_ADDR

);


    // For write pattern
    reg [1:0] row_index;           // 0..3 for buffers in a bram
    reg [RB_ADDR-1:0] buf_index;  // For counting on which buffer currently
    reg [BRAM_R_ADDR_WIDTH-1:0] loc_index;           // 0..511
    reg start;


    // For reset detection
    // wire all_disabled = !en_e_mem_addr && !en_w_bram_addr && !en_r_bram_addr;

    // MAIN LOGIC
    initial begin
        E_MEM_ADDR   <= -1;
        W_BRAM_ADDR  <= 0;
        R_BRAM_ADDR  <= 0;
        BRAM_W <= 0;
        buf_index <= 0;
        row_index <= 0;
        loc_index <= 0;
        start = 1;
    end
    always @(posedge clk) begin
        if (en_e_mem_addr)
                E_MEM_ADDR <= E_MEM_ADDR + 1;

        if (en_w_bram_addr) begin
            W_BRAM_ADDR <= row_index + (loc_index << 2); // location mult with 4(4RBs in one BRAM)
            start <= 0;

            if (loc_index == (RB_DEPTH-1)) begin
                loc_index <= 0;
                if (row_index == 3 || buf_index == RBs - 1) begin
                    row_index <= 0;
                    if (buf_index == (RBs - 1)) buf_index <= 0;
                    else buf_index <= buf_index + 1;
                end
                else begin 
                    row_index <= row_index + 1; // +0, +1, +2, +3 for each row buffer
                    buf_index <= buf_index + 1;
                end 
            end
            else loc_index <= loc_index + 1;

            if (loc_index == 0 && row_index == 0) begin
                if (buf_index == (RBs - 1) || start) BRAM_W <= 0; 
                else begin 
                    if (BRAM_W + 1 < BRAMs) BRAM_W <= BRAM_W + 1;
                    else BRAM_W <= 0; 
                end
            end
        end

        if (en_r_bram_addr) R_BRAM_ADDR <= R_BRAM_ADDR + 1; // it can only go till 511 in all cases
    end

endmodule
