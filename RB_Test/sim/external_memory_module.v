module external_memory_module (
    input [31:0] addr, 
    output [7:0] pixel
);

    reg [7:0] memory [0:512*512-1]; // only to not make memory too large, I instatitae with image size instead of 4GB
    initial begin
        $readmemh("ext_mem.mem", memory);
    end
    assign pixel = memory[addr];
endmodule
