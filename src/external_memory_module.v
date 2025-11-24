`include "params.vh"

module external_memory_module (
    input [`EMEM_W_ADDR_WIDTH-1:0] addr, 
    output [`PIXEL_WIDTH-1:0] pixel
);

    reg [`PIXEL_WIDTH-1:0] memory [0:`IMAGE_SIZE-1]; // only to not make memory too large, I instatitae with image size instead of 4GB
    initial begin
        $readmemh("data//ext_mem.mem", memory);
    end
    assign pixel = memory[addr];
endmodule