module BRAM18 (
    input clk,
    input w_en,
    input [10:0] w_addr,
    input [7:0] w_data,
    input r_en,
    input [8:0] r_addr,
    output reg [31:0] r_data
);
    localparam DEPTH = (1 << 11);

    (* ramstyle = "BRAM18" *)
    reg [7:0] mem [0:DEPTH-1];
    integer base;
    wire [7:0] right;

    always @(posedge clk) begin
        if (w_en)
            mem[w_addr] <= w_data;
    end

    always @(posedge clk) begin
        if (r_en) begin
            base = {r_addr, 2'b00}; 

            r_data <= {
                mem[base + 3],
                mem[base + 2],
                mem[base + 1],
                mem[base + 0]
            };
        end
    end

    // =========================
    // Simulation-only peek function
    // =========================
    // synthesis translate_off
    function [7:0] peek;
        input [10:0] addr;
        begin
            peek = mem[addr];
        end
    endfunction
    // synthesis translate_on

endmodule
