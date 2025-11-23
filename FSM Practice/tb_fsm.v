`timescale 1ns / 1ps

module tb_fsm;

    // --- Signals for DUT (Device Under Test) ---
    reg clk;
    reg reset;
    reg [1:0] coins;
    wire open;
    
    // --- Instantiate the FSM (Device Under Test) ---
    fsm_fixed DUT (
        .clk(clk),
        .reset(reset),
        .coins(coins),
        .open(open)
    );

    // --- Clock Generation ---
    parameter CLK_PERIOD = 10; // 10 ns period (100 MHz)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk; // Toggle every 5 ns
    end

    // --- Test Stimulus ---
    initial begin
        // Initialize inputs
        reset = 1;
        coins = 2'b00;
        
        // Wait for a short time and then de-assert reset
        @(posedge clk);
        #1; // Wait 1 ns after clock edge
        reset = 0;
        $display("\n--- Simulation Started ---");
        
        // --- Test Sequence 1: 5 cents (s0->s5), 5 cents (s5->s10), 5 cents (s10->s15) ---
        $display("Time=%0t: Starting Sequence 1 (5, 5, 5)", $time);
        
        @(posedge clk); coins = 2'b01; // Insert 5 cents (s0 -> s5)
        @(posedge clk); coins = 2'b01; // Insert 5 cents (s5 -> s10)
        @(posedge clk); coins = 2'b01; // Insert 5 cents (s10 -> s15) -> OPEN=1

        // --- Test Sequence 2: 10 cents (s0->s10), 10 cents (s0->s15) ---
        $display("Time=%0t: Starting Sequence 2 (10, 10)", $time);

        @(posedge clk); coins = 2'b10; // Insert 10 cents (s0 -> s10)
        @(posedge clk); coins = 2'b10; // Insert 10 cents (s10 -> s15) -> OPEN=1

        // --- Test Sequence 3: 5 cents (s0->s5), 10 cents (s5->s15) ---
        $display("Time=%0t: Starting Sequence 3 (5, 10)", $time);

        @(posedge clk); coins = 2'b01; // Insert 5 cents (s0 -> s5)
        @(posedge clk); coins = 2'b10; // Insert 10 cents (s5 -> s15) -> OPEN=1
        @(posedge clk); coins = 2'b00; // After s15, it should transition to s0
        $display("Time=%0t: --- Simulation Finished ---", $time);
        $finish;
    end

    // --- Monitor and Display Changes ---
    initial begin
        $monitor("Time=%0t | clk=%b reset=%b | coins=%b | curr_state=%d | open=%b", 
                 $time, clk, reset, coins, DUT.curr, open);
    end
    initial begin
    // Specify the VCD file name
    $dumpfile("fsm.vcd"); 
    
    // Dump all signals in the testbench module (or specific modules/signals)
    $dumpvars(0, tb_fsm); 
    
    // ... rest of your stimulus code
end

endmodule