`timescale 1ns / 1ps

module tb_address_generator_module;

    // Parameters
    parameter DATA_WIDTH_W = 8;
    parameter DATA_WIDTH_R = 32;
    parameter BRAM_DEPTH   = 16384;

    // Clock and control signals
    reg clk = 0;
    reg reset = 0;
    reg en_e = 0, en_w = 0, en_r = 0;
    reg next_image = 0;

    // DUT outputs
    wire [31:0] E_MEM_ADDR;
    wire [$clog2(BRAM_DEPTH / DATA_WIDTH_W)-1:0] W_BRAM_ADDR;
    wire [$clog2(BRAM_DEPTH / DATA_WIDTH_R)-1:0] R_BRAM_ADDR;

    // DUT instantiation
    address_generator_module #(
        .DATA_WIDTH_W(DATA_WIDTH_W),
        .DATA_WIDTH_R(DATA_WIDTH_R),
        .BRAM_DEPTH(BRAM_DEPTH)
    ) dut (
        .en_e(en_e),
        .en_w(en_w),
        .en_r(en_r),
        .E_MEM_ADDR(E_MEM_ADDR),
        .W_BRAM_ADDR(W_BRAM_ADDR),
        .R_BRAM_ADDR(R_BRAM_ADDR)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_address_generator_module);

        // Initial reset
        reset = 1;
        #20 reset = 0;

        // Enable write and external address increments
        en_e = 1;
        en_w = 1;
        #100;

        // Enable read simultaneously
        en_r = 1;
        #100;

        // Pause read
        en_r = 0;
        #50;

        // Trigger next image reset
        next_image = 1;
        #10 next_image = 0;
        #50;

        // Re-enable all
        en_e = 1; en_w = 1; en_r = 1;
        #100;

        // Finish simulation
        $display("Simulation complete at time %t", $time);
        $finish;
    end

endmodule
