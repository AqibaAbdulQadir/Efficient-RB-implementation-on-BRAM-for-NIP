`include "params.vh"

module control_module (
    input clk,
    input start,
    output reg complete,
    output reg en_e_mem_addr,
    output reg en_w_bram_addr,
    output reg en_r_bram_addr,
    output reg en_a,
    output reg en_b,
    output reg [`RB_ADDR-1:0] steer,
    output reg steer_en
);

    localparam S_IDLE = 3'b000, S_WRITE = 3'b001, S_READ = 3'b010, S_RW = 3'b011, S_DONE = 3'b100, max_writes = `IMAGE_SIZE-`BRAM_DEPTH-1;

    reg [2:0]  state, next_state;
    reg [`BRAM_W_ADDR_WIDTH:0] write_cnt; // one cycle wasted in the beginning due to write address generation
    reg [`IMAGE_ADDR-1:0] rw_cnt;
    reg [`BRAM_W_ADDR_WIDTH-1:0] buff_add;

    initial begin
        en_e_mem_addr = 0;
        en_w_bram_addr = 0;
        en_r_bram_addr = 0;
        en_a = 0;
        en_b = 0;
        state = S_IDLE;
        buff_add = 0;
        steer = 0;
    end

    // combinational next state logic
    always @(*) begin
        if (start) next_state = S_IDLE;
        else begin
            case (state)
                S_IDLE: next_state = S_WRITE;
                S_WRITE: if (write_cnt == `BRAM_DEPTH) next_state = S_READ;
                S_READ: next_state = S_RW;
                S_RW: if (rw_cnt == max_writes) next_state = S_DONE;  
            endcase
        end
    end

    // sequential logic to transition current state to next state and increment state counters(syncronous)
    always @(posedge clk) begin
        state <= next_state;
        case (state)
            S_IDLE: begin
                write_cnt = 0;
                rw_cnt = 0;
                buff_add = 0;
            end
            S_WRITE: begin
                if (write_cnt == `BRAM_DEPTH) write_cnt <= 0;
                else write_cnt <= write_cnt + 1;
            end
            // S_READ: begin
            //     if (buff_add < `BRAM_DEPTH-1) buff_add <= buff_add + 1;
            //     else buff_add <= 0;
            // end
            S_RW: begin
                if (rw_cnt == max_writes) rw_cnt <= 0;
                else begin 
                    rw_cnt <= rw_cnt + 1;
                    if (buff_add < `BRAM_DEPTH-1) buff_add <= buff_add + 1;
                    else buff_add <= 0;
                end
            end
            S_DONE: begin
                write_cnt = 0;
                rw_cnt = 0;
            end
        endcase
    end


    // Combinational Output Logic
    always @(*) begin
        case (state)
            S_IDLE: begin
                en_e_mem_addr = 0;
                en_w_bram_addr = 0;
                en_r_bram_addr = 0;
                en_a = 0;
                en_b = 0;
                steer_en = 0;
            end
            S_WRITE: begin
                en_e_mem_addr = 1;
                en_w_bram_addr = 1;
                en_r_bram_addr = 0;
                en_a = 1;
                en_b = 0;
                steer_en = 0;
            end
            S_READ: begin
                en_e_mem_addr = 0;
                en_w_bram_addr = 0;
                en_r_bram_addr = 1;
                en_a = 0;
                en_b = 1;
                steer_en = 0;
                // steer = buff_add / `RB_DEPTH;
            end
            S_RW: begin
                en_e_mem_addr = 1;
                en_w_bram_addr = 1;
                en_r_bram_addr = 1;
                en_a = 1;
                en_b = 1;
                steer_en = 1;
                steer = buff_add / `RB_DEPTH;

            end
            S_DONE: begin
                en_e_mem_addr = 0;
                en_w_bram_addr = 0;
                en_r_bram_addr = 0;
                en_a = 0;
                en_b = 0;
                steer_en = 0;
            end
        endcase
        complete = (state == S_DONE);
    end
    
endmodule
