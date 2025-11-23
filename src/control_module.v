module control_module (
    input clk,
    input start,
    output reg complete,
    output reg en_e_mem_addr,
    output reg en_w_bram_addr,
    output reg en_r_bram_addr,
    output reg en_a,
    output reg en_b,
    output reg [1:0] steer,
    output reg steer_en
);

    localparam S_IDLE = 3'b000, S_WRITE = 3'b001, S_READ = 3'b010, S_RW = 3'b011, S_DONE = 3'b100, max_writes = 18'd260095;

    reg [2:0]  state, next_state;
    reg [10 + 1:0] write_cnt; // one cycle wasted in the beginning due to write address generation
    reg [17:0] rw_cnt;
    reg [10:0] buff_add;

    initial begin
        en_e_mem_addr <= 0;
        en_w_bram_addr <= 0;
        en_r_bram_addr <= 0;
        en_a <= 0;
        en_b <= 0;
        state <= S_IDLE;
        buff_add <= 0;
        steer <= 0;
    end

    // combinational next state logic
    always @(*) begin
        if (start) next_state = S_IDLE;
        else begin
            case (state)
                S_IDLE: next_state = S_WRITE;
                S_WRITE: if (write_cnt == 12'd2048) next_state = S_READ;
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
                write_cnt = 11'd0;
                rw_cnt = 18'd0;
                buff_add = 11'd0;
            end
            S_WRITE: begin
                if (write_cnt == 12'd2048) write_cnt <= 12'd0;
                else write_cnt <= write_cnt + 12'd1;
            end
            S_READ: begin
                buff_add <= buff_add + 11'd1;
            end
            S_RW: begin
                if (rw_cnt == max_writes) rw_cnt <= 18'd0;
                else begin 
                    rw_cnt <= rw_cnt + 18'd1;
                    buff_add <= buff_add + 11'd1;
                end
            end
            S_DONE: begin
                write_cnt = 12'd0;
                rw_cnt = 18'd0;
            end
        endcase
    end


    // Combinational Output Logic
    always @(*) begin
        case (state)
            S_IDLE: begin
                en_e_mem_addr <= 0;
                en_w_bram_addr <= 0;
                en_r_bram_addr <= 0;
                en_a <= 0;
                en_b <= 0;
                steer_en <= 0;
            end
            S_WRITE: begin
                en_e_mem_addr <= 1;
                en_w_bram_addr <= 1;
                en_r_bram_addr <= 0;
                en_a <= 1;
                en_b <= 0;
                steer_en <= 0;
            end
            S_READ: begin
                en_e_mem_addr <= 0;
                en_w_bram_addr <= 0;
                en_r_bram_addr <= 1;
                en_a <= 0;
                en_b <= 1;
                steer_en <= 1;
            end
            S_RW: begin
                en_e_mem_addr <= 1;
                en_w_bram_addr <= 1;
                en_r_bram_addr <= 1;
                en_a <= 1;
                en_b <= 1;
                steer_en <= 1;

                if (buff_add <= 511) steer = 0;
                else if (buff_add <= 1023) steer = 1;
                else if (buff_add <= 1535) steer = 2;
                else steer = 3;

            end
            S_DONE: begin
                en_e_mem_addr <= 0;
                en_w_bram_addr <= 0;
                en_r_bram_addr <= 0;
                en_a <= 0;
                en_b <= 0;
                steer_en <= 0;
            end
        endcase
        complete <= (state == S_DONE);
    end
    
endmodule
