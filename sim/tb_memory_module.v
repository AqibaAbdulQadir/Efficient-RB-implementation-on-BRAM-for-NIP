`timescale 1ns/1ps
module tb_memory_module;

    reg clk = 0;
    always #5 clk = ~clk;

    // Control and data signals
    reg w_a = 0;
    reg en_b = 0;
    reg en_a = 0;
    reg [7:0] data_in_a;
    reg [10:0] addr_a = 0;  // write address (2K depth)
    reg [8:0] addr_b = 0;   // read address (512 depth)
    wire [31:0] data_out_b;

    // Instantiate the memory module
    memory_module uut (
        // .clk(clk),
        .EN_A(en_a),
        .W_A(w_a),
        .ADDR_A(addr_a),
        .DIN_A(data_in_a),
        .EN_B(en_b),
        .ADDR_B(addr_b),
        .DOUT_B(data_out_b)
    );

    initial begin
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_memory_module);

        // -------------------------------------------------------
        // Write Phase: Write 16 8-bit values sequentially
        // -------------------------------------------------------
        en_a = 1;
        w_a = 1;
        for (integer i = 0; i < 16; i = i + 1) begin
            data_in_a = i;
            addr_a = i;
            #10;
        end
        w_a = 0;
        // en_a = 0;

        // -------------------------------------------------------
        // Read Phase: Read back 4 packed 32-bit words
        // -------------------------------------------------------
        #20;
        en_b = 1;
        for (integer j = 0; j < 4; j = j + 1) begin
            addr_b = j;
            #10;
        end
        en_b = 0;

        #50 $finish;
    end

endmodule
