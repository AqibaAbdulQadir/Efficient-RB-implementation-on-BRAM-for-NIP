`timescale 1ns/1ps
module tb_control_module;

    reg clk = 0;
    always #5 clk = ~clk;

    // Control and data signals
    reg start;
    wire complete;
    wire en_e_mem_addr;
    wire en_w_bram_addr;
    wire en_r_bram_addr;
    wire en_a;
    wire en_b;
 

    // Instantiate the memory module
    control_module uut (
        clk,
        start,
        complete,
        en_e_mem_addr,
        en_w_bram_addr,
        en_r_bram_addr,
        en_a,
        en_b
    );

    initial begin
        start = 0;
        #10
        start = 1;
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_control_module);

        #5000000 $finish;
    end

endmodule
