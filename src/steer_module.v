module steer_module (
    input en,
    input [1:0] sel,
    input [7:0] in4, in3, in2, in1,
    output [7:0] out4, out3, out2, out1
);

    mux_4_to_1 m1(en, sel, in4, in1, in2, in3, out4); // [31:24]
    mux_4_to_1 m2(en, sel, in3, in4, in1, in2, out3); // [23:16]
    mux_4_to_1 m3(en, sel, in2, in3, in4, in1, out2); // [15: 8]
    mux_4_to_1 m4(en, sel, in1, in2, in3, in4, out1); // [ 7: 0]
    
endmodule