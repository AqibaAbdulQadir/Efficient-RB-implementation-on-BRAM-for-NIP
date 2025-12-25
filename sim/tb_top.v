`timescale 1ns/1ps

module tb_top #(
    `include "par.vh"
);
    localparam K_SIZE = K;
    localparam PIXEL = PIXEL_WIDTH;
    localparam EADDR = EMEM_W_ADDR_WIDTH;
    
    reg clk = 0;
    reg start;
    wire complete;
    wire read;
    wire [K_SIZE*PIXEL-1:0] out;
    wire [EADDR-1:0] E_MEM_ADDR;
    wire [PIXEL-1:0] data_in_a;

    wire [PIXEL-1:0] pixels [K_SIZE-1:0];
    genvar i;
    generate
        for (i = 0; i < K_SIZE; i = i + 1) begin : PIXELS
            assign pixels[i] = out[(i+1)*PIXEL-1 -: PIXEL];
        end
    endgenerate

    always #50 clk = ~clk;

    integer f, j;
    initial begin
        f = $fopen("pixels.mem","w");
        if (f == 0) begin
            $display("ERROR: cannot open file!");
            $finish;
        end 
    end
    

    always @(posedge clk) begin
        if (read) begin
            // print all pixels
            for (j = 0; j < K_SIZE; j = j + 1)
                $fwrite(f, "%h ", pixels[j]);
            $fwrite(f, "\n");
        end
        // else $display("%0d %0d", BRAM_W_ADDR_WIDTH, BRAM_DEPTH);
        
    end
    
    external_memory_module em(
        E_MEM_ADDR,
        data_in_a
    );
    
    top #(.K(K_SIZE)) uut (
        clk,
        start,
        read,
        E_MEM_ADDR,
        data_in_a,
        complete,
        out
    );

    initial begin
//        $dumpfile("sim/wave.vcd");
//        $dumpvars(0, tb_top);

        start = 1; #0.1
        start = 0;

        #26225000
        $fclose(f);
        $finish;
    end

endmodule
