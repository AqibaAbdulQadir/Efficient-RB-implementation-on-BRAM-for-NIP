`timescale 1ns/1ps
module tb_top;

    reg clk = 0;
    reg start;
    wire complete;
    wire [39:0] out;

    wire [7:0] b4 = out[39:32];
    wire [7:0] b3 = out[31:24];
    wire [7:0] b2 = out[23:16];
    wire [7:0] b1 = out[15:8];
    wire [7:0] b0 = out[7:0];

    always #0.5 clk = ~clk;

    integer f;
    initial begin
        f = $fopen("data/pixels.txt", "w");
        if (f == 0) begin
            $display("Error opening file!");
            $finish;
        end
    end

    always @(posedge clk) begin
        if (out !== 40'bz) $fdisplay(f, "%h %h %h %h %h", b4, b3, b2, b1, b0);
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
