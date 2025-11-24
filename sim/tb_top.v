`timescale 1ns/1ps
`include "params.vh"

module tb_top;

    reg clk = 0;
    reg start;
    wire complete;
    wire [`K*`PIXEL_WIDTH-1:0] out;

    wire [`PIXEL_WIDTH-1:0] pixels [`K-1:0];
    genvar i;
    generate
        for (i = 0; i < `K; i = i + 1) begin : PIXELS
            assign pixels[i] = out[(i+1)*`PIXEL_WIDTH-1 -: `PIXEL_WIDTH];
        end
    endgenerate

    always #0.5 clk = ~clk;

    integer f, j;
    initial begin
        f = $fopen("data/pixels.txt", "w");
        if (f == 0) begin
            $display("Error opening file!");
            $finish;
        end
    end

    always @(posedge clk) begin
        if (out !== {`K*`PIXEL_WIDTH{1'bz}}) begin
            // print all pixels
            for (j = 0; j < `K; j = j + 1)
                $fwrite(f, "%h ", pixels[j]);
            $fwrite(f, "\n");
        end
        // else $display("%0d %0d", `BRAM_W_ADDR_WIDTH, `BRAM_DEPTH);
        
    end

    top uut (
        clk,
        start,
        complete,
        out
    );

    initial begin
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_top);

        start = 1; #0.1
        start = 0;

        #262250
        $fclose(f);
        $finish;
    end

endmodule
