module external_memory_module (
    input [31:0] addr, 
    output [7:0] pixel
);
    reg [7:0] memory [0:262143];
    initial begin
        $readmemh("data//ext_mem.mem", memory);
    end
    assign pixel = memory[addr];
endmodule