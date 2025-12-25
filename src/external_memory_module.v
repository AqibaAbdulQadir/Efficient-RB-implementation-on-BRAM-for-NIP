module external_memory_module #(
`include "par.vh"
)(
    input  [EMEM_W_ADDR_WIDTH-1:0] addr, 
    output [PIXEL_WIDTH-1:0]        pixel
);


    // Simulation-only memory model
    reg [PIXEL_WIDTH-1:0] memory [0:IMAGE_SIZE-1];

    initial begin
        $display("Loading external memory from ext_mem.mem (simulation only)");
        $readmemh("ext_mem.mem", memory);
    end

    assign pixel = memory[addr];

endmodule
