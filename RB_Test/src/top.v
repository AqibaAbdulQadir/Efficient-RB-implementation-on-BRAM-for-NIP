`timescale 1ns/1ps

module top #(parameter EADDR = 32, K_SIZE = 5, PIXEL = 8, OUT_SIZE = 508)(
    input clk,
    input start,
    output reg allow,
    output [EADDR-1:0] E_MEM_ADDR,
    input [PIXEL-1:0] data_in_a,
    output complete,
    output reg [PIXEL-1:0] pix
);
    wire [K_SIZE*PIXEL-1:0] out;
    wire read;
    RowBufferBRAM18_0 uut (
        clk,
        start,
        read,
        E_MEM_ADDR,
        data_in_a,
        complete,
        out
    );
    reg [K_SIZE*PIXEL-1:0] img_kernel [0:K_SIZE-1];
    reg [K_SIZE*PIXEL-1:0] kernel [0:K_SIZE-1];
    parameter IDLE = 2'b00, FILL = 2'b01, OUT = 2'b10, DONE = 2'b11;
    reg [1:0] state, next_state;
    integer i;
    reg [8:0] row;
    reg [$clog2(K_SIZE)-1:0] cnt;
    
    initial begin
        $readmemh("kernel.mem", kernel);
    end
    
    reg signed [31:0] mac;
    integer r, c;
    
    always @(*) begin
        mac = 0;
        for (r = 0; r < K_SIZE; r = r + 1)
            for (c = 0; c < K_SIZE; c = c + 1)
                mac = mac + img_kernel[r][(K_SIZE-1) * PIXEL - c*PIXEL +: PIXEL] * kernel[r][c*PIXEL +: PIXEL];
    end
    
    always @(posedge clk) begin
        state <= next_state;
        case (state)
            IDLE: begin 
                for(i = 1; i < K_SIZE; i=i+1) img_kernel[i] <= 0;
                img_kernel[0] <= out;
                cnt <= 1;  
            end
            FILL: begin
                img_kernel[cnt] <= out;
                cnt <= cnt + 1;
                row <= 0; 
            end
            OUT: begin
                // shift window left
                row <= row + 1;
                cnt <= 0;
                for (i = 0; i < K_SIZE-1; i = i + 1)
                    img_kernel[i] <= img_kernel[i+1];
                img_kernel[K_SIZE-1] <= out;  // new column
                if (row == OUT_SIZE - 1) begin
                     img_kernel[0] <= out;
                     cnt <= 1; 
                end
                
                end
        endcase
    end
    
    always @(*) begin
        next_state <= state;
        if (!read) next_state <= IDLE;
        else begin
            case (state)
                IDLE: next_state <= FILL;                                
                FILL: if (cnt == K_SIZE-1) next_state <= OUT;
                OUT: begin 
                    if (complete) next_state <= IDLE;
                    else if (row == OUT_SIZE - 1) next_state <= FILL;
//                    else next_state = OUT;
                end
            endcase
        end
    end
    
    always @(*) begin
        if (state == OUT) begin
//            if (mac < 0)
//                pix <= 0;
//            else if (mac > (1<<PIXEL)-1)
//                pix <= {PIXEL{1'b1}};
//            else
//                pix <= mac[PIXEL-1:0];
            pix <= mac[PIXEL-1:0];
            allow <= 1;
        end
        else allow <= 0;
    end

endmodule
