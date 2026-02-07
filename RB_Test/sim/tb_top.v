`timescale 1ns/1ps

module tb_top;
    parameter K_SIZE = 3;
    parameter PIXEL = 8;
    parameter EADDR = 32;
    parameter OUT_SIZE = 512 - K_SIZE + 1;
    
    reg clk = 0;
    reg start;
    wire complete;
    wire read;
//    wire [K_SIZE*PIXEL-1:0] out;
    wire [PIXEL-1:0] out;
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
        else $display("Successful");
    end
    integer row = 0;
    integer col = 0;
    integer pixel_count = 0;

    always @(posedge clk) begin
        if (read) begin
            // write one output pixel
            $fwrite(f, "%02h ", out);
    
            col = col + 1;
            pixel_count = pixel_count + 1;
    
            // end of one row
            if (col == OUT_SIZE) begin
                $fwrite(f, "\n");
                col = 0;
                row = row + 1;
            end
    
            // stop after full image
            if (pixel_count == OUT_SIZE * OUT_SIZE) begin
                $display("Finished writing output image");
                $fclose(f);
                $finish;
            end
        end
    end

    
    external_memory_module em(
        E_MEM_ADDR,
        data_in_a
    );
    
    top #(.K_SIZE(K_SIZE), .PIXEL(PIXEL), .EADDR(EADDR), .OUT_SIZE(OUT_SIZE))
    uut(
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
