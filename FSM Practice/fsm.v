module fsm_fixed #(
    parameter s0 = 2'b00, 
    parameter s5 = 2'b01, 
    parameter s10 = 2'b10, 
    parameter s15 = 2'b11
) (
    input wire clk, // Added clock input
    input wire reset, 
    input wire [1:0] coins, // 2-bit input: 00=no coin, 01=5 cents, 10=10 cents
    output reg open // State is 2-bit, so curr/nxt should be 2-bit
);

    reg [1:0] nxt, curr;

    // --- State Register: Synchronous update on posedge clk, asynchronous reset ---
    always @(posedge clk or posedge reset) begin
        if (reset) 
            curr <= s0;
        else 
            curr <= nxt;
    end

    // --- Next State Logic: Combinationally determines nxt based on curr and coins ---
    always @(*) begin
        nxt = curr; // Default: stay in current state
        case (curr)
            s0: begin
                if (coins == 2'b10)      // 10 cents -> s10
                    nxt = s10;
                else if (coins == 2'b01) // 5 cents -> s5
                    nxt = s5;
                // else (coins == 2'b00) nxt = s0 (default)
            end
            s5: begin
                if (coins == 2'b10)      // 10 cents -> s15 (5+10)
                    nxt = s15;
                else if (coins == 2'b01) // 5 cents -> s10 (5+5)
                    nxt = s10;
                // else nxt = s5
            end
            s10: begin
                if (coins != 2'b00)      // Any coin (5 or 10) -> s15
                    nxt = s15;
                // else nxt = s10
            end
            s15: begin
                // Once open, we assume the machine resets to s0 (next clock cycle)
                if (coins == 2'b10)      // 10 cents -> s10
                    nxt = s10;
                else if (coins == 2'b01) // 5 cents -> s5
                    nxt = s5; 
                else nxt = s0;
            end
            default: nxt = s0;
        endcase
    end

    // --- Output Logic: Moore Machine (Output depends only on state) ---
    always @(curr) begin
        if (curr == s15)
            open = 1'b1;
        else
            open = 1'b0;
    end
    
endmodule