// module address_generator_module #(
//     parameter DATA_WIDTH_W = 8,   // write port width
//     parameter DATA_WIDTH_R = 32,  // read port width
//     parameter BRAM_DEPTH   = 16384
// )(
//     input  wire clk,
//     input  wire en_e_mem_addr, en_w_bram_addr, en_r_bram_addr,  // enable signals
//     output reg  [31:0] E_MEM_ADDR, // external memory address
//     output reg  [$clog2(BRAM_DEPTH / DATA_WIDTH_W)-1:0] W_BRAM_ADDR,
//     output reg  [$clog2(BRAM_DEPTH / DATA_WIDTH_R)-1:0] R_BRAM_ADDR
// );

//     localparam LOC_W = BRAM_DEPTH / DATA_WIDTH_W;
//     localparam LOC_R = BRAM_DEPTH / DATA_WIDTH_R;
//     reg[$clog2(LOC_W)-1:0] counter;
//     reg[2:0] rb_num;
//     reg[$clog2(LOC_R)-1:0] rb_loc, R_BRAM_ADDR_out;
//     reg  [31:0] E_MEM_ADDR_out;

//     initial begin
//         E_MEM_ADDR  <= 0;
//         W_BRAM_ADDR <= 0;
//         R_BRAM_ADDR <= 0;
//         counter     <= 1;
//         E_MEM_ADDR_out <= 0;
//         R_BRAM_ADDR_out <= 0;
//         rb_loc <= 0;
//         rb_num <= 0; 
//     end

//     always @(posedge clk) begin
//         if (!en_e_mem_addr && !en_w_bram_addr && !en_r_bram_addr) begin
//             E_MEM_ADDR  <= 0;
//             W_BRAM_ADDR <= 0;
//             R_BRAM_ADDR <= 0;
//             counter     <= 1;
//             E_MEM_ADDR_out <= 0;
//             R_BRAM_ADDR_out <= 0;
//             rb_loc <= 0;
//             rb_num <= 0;
//         end 
//         else begin
//             // External memory and write address increment
//             if (en_e_mem_addr && en_w_bram_addr) begin
//                 W_BRAM_ADDR <= (rb_loc << 2) + rb_num;
//                 E_MEM_ADDR  <= E_MEM_ADDR_out;
//                 E_MEM_ADDR_out <= E_MEM_ADDR_out + 1;
//                 counter <= counter + 1;
//                 rb_num <= counter / LOC_R;
//                 rb_loc <= counter % LOC_R;
//             end

//             // Read address increment
//             if (en_r_bram_addr) begin
//                 R_BRAM_ADDR <= R_BRAM_ADDR_out;
//                 R_BRAM_ADDR_out <= R_BRAM_ADDR_out + 1;
//             end
//         end
//     end
// endmodule

module address_generator_module #(
    parameter BRAM_DEPTH = 2048   // total locations
)(
    input  wire clk,

    input  wire en_e_mem_addr,
    input  wire en_w_bram_addr,
    input  wire en_r_bram_addr,

    output reg [31:0] E_MEM_ADDR,
    output reg [$clog2(BRAM_DEPTH)-1:0] W_BRAM_ADDR,
    output reg [$clog2(BRAM_DEPTH/4)-1:0] R_BRAM_ADDR
);

    // For write pattern
    reg [1:0] row_index;           // 0..3
    reg [8:0] loc_index;           // 0..511

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
            W_BRAM_ADDR <= row_index + ((loc_index) << 2);

            if (loc_index == 511) begin
                loc_index <= 0;
                row_index <= (row_index == 3) ? 0 : row_index + 1;
            end else begin
                loc_index <= loc_index + 1;
            end
        end
        if (en_r_bram_addr) R_BRAM_ADDR <= R_BRAM_ADDR + 1;
    end

endmodule
