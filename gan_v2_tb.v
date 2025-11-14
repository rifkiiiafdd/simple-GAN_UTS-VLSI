`timescale 1ns/1ps
module gan_tb;

    parameter WIDTH = 8;
    parameter WIDTH_L8 = 77; // perbesar untuk mencegah overflow

    // Clock dan reset
    reg clk;
    reg rst;

    // Input utama
    reg signed [WIDTH-1:0] x_1;
    reg signed [WIDTH-1:0] x_2;
    reg signed [WIDTH-1:0] x_3;
    reg signed [WIDTH-1:0] x_4;

    // Semua weight dan bias layer 1–8
    reg signed [WIDTH-1:0] 
        w1_11, w1_12, w1_13, w1_14,
        w1_21, w1_22, w1_23, w1_24,
        w1_31, w1_32, w1_33, w1_34,
        w1_41, w1_42, w1_43, w1_44,
        b1_1, b1_2, b1_3, b1_4;

    reg signed [WIDTH-1:0] w2_11;
    reg signed [WIDTH-1:0] w2_12;
    reg signed [WIDTH-1:0] w2_31;
    reg signed [WIDTH-1:0] w2_32;

    reg signed [WIDTH-1:0] w2_21;
    reg signed [WIDTH-1:0] w2_22;
    reg signed [WIDTH-1:0] w2_41;
    reg signed [WIDTH-1:0] w2_42;

    reg signed [WIDTH-1:0] b2_1, b2_2;

    reg signed [WIDTH-1:0] 
        w3_11, w3_21, b3_1;

    reg signed [WIDTH-1:0] 
        w4_11, b4_1;

    reg signed [WIDTH-1:0] 
        w5_11, b5_1;

    reg signed [WIDTH-1:0] 
        w6_11, w6_12, b6_1, b6_2;

    reg signed [WIDTH-1:0] 
        w7_11, w7_12, w7_13, w7_14,
        w7_21, w7_22, w7_23, w7_24,
        b7_1, b7_2, b7_3, b7_4;

    reg signed [WIDTH-1:0] 
        w8_11, w8_12, w8_13, w8_14,
        w8_21, w8_22, w8_23, w8_24,
        w8_31, w8_32, w8_33, w8_34,
        w8_41, w8_42, w8_43, w8_44,
        b8_1, b8_2, b8_3, b8_4;

    // Output
    wire signed [WIDTH_L8-1:0] out1, out2, out3, out4;

    // === Instansiasi Unit Under Test (UUT) ===
    gan_v2 #(.WIDTH(WIDTH), .WIDTH_L8(WIDTH_L8)) uut (
        .clk(clk),
        .rst(rst),

        .x_1(x_1), .x_2(x_2), .x_3(x_3), .x_4(x_4),

        // Layer 1
        .w1_11(w1_11), .w1_12(w1_12), .w1_13(w1_13), .w1_14(w1_14),
        .w1_21(w1_21), .w1_22(w1_22), .w1_23(w1_23), .w1_24(w1_24),
        .w1_31(w1_31), .w1_32(w1_32), .w1_33(w1_33), .w1_34(w1_34),
        .w1_41(w1_41), .w1_42(w1_42), .w1_43(w1_43), .w1_44(w1_44),
        .b1_1(b1_1), .b1_2(b1_2), .b1_3(b1_3), .b1_4(b1_4),

        // Layer 2
        .w2_11(w2_11), .w2_12(w2_12), .w2_31(w2_31), .w2_32(w2_32),
        .w2_21(w2_21), .w2_22(w2_22), .w2_41(w2_41), .w2_42(w2_42),
        .b2_1(b2_1), .b2_2(b2_2),

        // Layer 3
        .w3_11(w3_11), .w3_21(w3_21), .b3_1(b3_1),

        // Layer 4–8
        .w4_11(w4_11), .b4_1(b4_1),
        .w5_11(w5_11), .b5_1(b5_1),
        .w6_11(w6_11), .w6_12(w6_12), .b6_1(b6_1), .b6_2(b6_2),
        .w7_11(w7_11), .w7_12(w7_12), .w7_13(w7_13), .w7_14(w7_14),
        .w7_21(w7_21), .w7_22(w7_22), .w7_23(w7_23), .w7_24(w7_24),
        .b7_1(b7_1), .b7_2(b7_2), .b7_3(b7_3), .b7_4(b7_4),
        .w8_11(w8_11), .w8_12(w8_12), .w8_13(w8_13), .w8_14(w8_14),
        .w8_21(w8_21), .w8_22(w8_22), .w8_23(w8_23), .w8_24(w8_24),
        .w8_31(w8_31), .w8_32(w8_32), .w8_33(w8_33), .w8_34(w8_34),
        .w8_41(w8_41), .w8_42(w8_42), .w8_43(w8_43), .w8_44(w8_44),
        .b8_1(b8_1), .b8_2(b8_2), .b8_3(b8_3), .b8_4(b8_4),

        .out1(out1), .out2(out2), .out3(out3), .out4(out4)
    );

    // === Clock generation ===
    always #5 clk = ~clk; // periode 10 ns

    // === Stimulus utama ===
    initial begin
        $display("==== Starting GAN Testbench ====");
        clk = 0;
        rst = 1;
        #10;
        rst = 0;

        // Inisialisasi input dan bobot (sama dengan punyamu)
        x_1 = 8'sd0;
        x_2 = 8'sd1;
        x_3 = 8'sd1;
        x_4 = 8'sd0;

        w1_11 = 8'sd6;
        w1_12 = 8'sd21;
        w1_13 = 8'sd3;
        w1_14 = 8'sd18;

        w1_21 = -8'sd3;
        w1_22 = 8'sd16;
        w1_23 = -8'sd3;
        w1_24 = 8'sd12;

        w1_31 = 8'sd5;
        w1_32 = -8'sd6;
        w1_33 = -8'sd15;
        w1_34 = -8'sd4;

        w1_41 = -8'sd16;
        w1_42 = -8'sd9;
        w1_43 = -8'sd17;
        w1_44 = -8'sd8;

        b1_1 = 8'sd1;
        b1_2 = 8'sd0;
        b1_3 = 8'sd2;
        b1_4 = -8'sd1;

        w2_11 = 8'sd4;
        w2_21 = 8'sd14; 

        w2_12 = -8'sd14;
        w2_22 = 8'sd14;

        w2_31 = 8'sd8;
        w2_32 = 8'sd9;

        w2_41 = 8'sd15;
        w2_42 = 8'sd15;

        b2_1 = 8'sd1;
        b2_2 = 8'sd4;

        w3_11 = 8'sd14;
        w3_21 = 8'sd6;

        b3_1 = 8'sd5;

        w4_11 = 8'sd7;
        b4_1 = 8'sd10;

        w5_11 = 8'sd1;
        b5_1 = -8'sd4;

        w6_11 = -8'sd8;
        w6_12 = 8'sd14;
        b6_1 = 8'sd20;
        b6_2 = 8'sd0;

        w7_11 = 8'sd4;
        w7_12 = 8'sd14;
        w7_13 = 8'sd8;
        w7_14 = 8'sd15;

        w7_21 = -8'sd14;
        w7_22 = 8'sd14;
        w7_23 = 8'sd9;
        w7_24 = 8'sd15;

        b7_1 = 8'sd5;
        b7_2 = 8'sd3;
        b7_3 = 8'sd1;
        b7_4 = 8'sd2;
        
        w8_11 = 8'sd11;
        w8_12 = -8'sd7;
        w8_13 = 8'sd10;
        w8_14 = -8'sd7;

        w8_21 = 8'sd9;
        w8_22 = -8'sd6;
        w8_23 = 8'sd11;
        w8_24 = -8'sd7;

        w8_31 = 8'sd10;
        w8_32 = -8'sd15;
        w8_33 = -8'sd5;
        w8_34 = 8'sd7;

        w8_41 = 8'sd1;
        w8_42 = 8'sd17;
        w8_43 = 8'sd4;
        w8_44 = 8'sd12;

        b8_1 = -8'sd10;
        b8_2 = 8'sd10;
        b8_3 = 8'sd10;
        b8_4 = -8'sd10;

        // Tunggu beberapa siklus clock agar tiap layer sempat memproses
        repeat (20) @(posedge clk);

        $display("==== GAN LEVEL 2 : Testbench Results ====");

        $display("Output: %d", out1);
        $display("Output: %d", out2);
        $display("Output: %d", out3);
        $display("Output: %d", out4);

        // Simulasi berakhir
        #10;
        $finish;
    end

endmodule
