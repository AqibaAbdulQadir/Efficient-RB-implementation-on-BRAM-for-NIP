// module memory_module #(
//     parameter DATA_WIDTH_A = 8,        // write port width
//     parameter DATA_WIDTH_B = 32,       // read port width
//     parameter DEPTH = 16384            // total bits (fits in BRAM18)
// )(
//     input  wire clk,
//     input  wire EN_A,
//     input  wire [$clog2(DEPTH / DATA_WIDTH_A)-1:0] ADDR_A,
//     input  wire [DATA_WIDTH_A-1:0] DIN_A,

//     // READ port (Port B)
//     input  wire EN_B,
//     input  wire [$clog2(DEPTH / DATA_WIDTH_B)-1:0] ADDR_B,
//     output reg  [DATA_WIDTH_B-1:0] DOUT_B
// );

//     // Number of addressable locations for write port
//     localparam LOCATIONS = DEPTH / DATA_WIDTH_A;

//     // (* ram_style = "block" *)  // uncomment in Vivado
//     reg [DATA_WIDTH_A-1:0] bram [0:LOCATIONS-1];

//     integer i;
//     initial begin
//         for (i = 0; i < LOCATIONS; i = i + 1)
//             bram[i] = 0;
//     end

//     // WRITE Port (Port A)
//     always @(posedge clk) begin
//         if (EN_A)
//             bram[ADDR_A] <= DIN_A;
//     end

//     // READ Port (Port B) - packs 4 consecutive pixels into 32-bit word
//     always @(posedge clk) begin
//         if (EN_B)
//             DOUT_B <= { bram[(ADDR_B<<2) + 3],
//                         bram[(ADDR_B<<2) + 2],
//                         bram[(ADDR_B<<2) + 1],
//                         bram[(ADDR_B<<2) + 0] };
//     end

// endmodule

module memory_module #(
    parameter DATA_WIDTH_A = 8,        // write port width
    parameter DATA_WIDTH_B = 32,       // read port width
    parameter DEPTH = 16384            // total bits (fits in BRAM18)
)(
    // input  wire clk,
    input  wire EN_A,
    input  wire [$clog2(DEPTH / DATA_WIDTH_A)-1:0] ADDR_A,
    input  wire [DATA_WIDTH_A-1:0] DIN_A,

    // READ port (Port B)
    input  wire EN_B,
    input  wire [$clog2(DEPTH / DATA_WIDTH_B)-1:0] ADDR_B,
    output reg  [DATA_WIDTH_B-1:0] DOUT_B
);

    // Number of addressable locations for write port
    localparam LOCATIONS = DEPTH / DATA_WIDTH_A;

    // (* ram_style = "block" *)  // uncomment in Vivado
    reg [DATA_WIDTH_A-1:0] bram [0:LOCATIONS-1];

    integer i;
    initial begin
        for (i = 0; i < LOCATIONS; i = i + 1)
            bram[i] = 0;
    end

    // WRITE Port (Port A)
    always @(*) begin
        if (EN_A)
            bram[ADDR_A] <= DIN_A;
    end

    // READ Port (Port B) - packs 4 consecutive pixels into 32-bit word
    always @(*) begin
        if (EN_B)
            DOUT_B <= { bram[(ADDR_B<<2) + 3],
                        bram[(ADDR_B<<2) + 2],
                        bram[(ADDR_B<<2) + 1],
                        bram[(ADDR_B<<2) + 0] };
    end

endmodule
