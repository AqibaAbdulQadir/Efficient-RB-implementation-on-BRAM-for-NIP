module m20k #(
    parameter WIDTH = 8,
    parameter DEPTH = 512
)(
    input clk,
    input w_en,
    input [$clog2(DEPTH)-1:0] w_addr,
    input [WIDTH-1:0] w_data,
    input [$clog2(DEPTH)-1:0] r_addr,
    output reg [WIDTH-1:0] r_data
);

    // This will be inferred as a true M20K IP in Quartus
    (* ramstyle = "M20K" *)
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (w_en)
            mem[w_addr] <= w_data;
        r_data <= mem[r_addr];
    end

endmodule
