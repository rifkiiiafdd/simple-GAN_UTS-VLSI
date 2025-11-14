`timescale 1ns/1ps
module tb_gan_v3;

    parameter WIDTH = 28;

    reg clk;
    reg rst;
    reg we;
    reg start;
    reg signed [WIDTH-1:0] data_in;
    reg [7:0] addr;
    wire signed [WIDTH-1:0] data_out;
    wire data_valid;

    // DUT (Device Under Test)
    gan_v3 #(WIDTH) uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .addr(addr),
        .we(we),
        .start(start),
        .data_out(data_out),

        .data_valid(data_valid)
    );

    // clock generator
    always #5 clk = ~clk;

    integer i;

    parameter n_x = 4;
    parameter n_w = 54;
    parameter n_b = 19;

    reg signed [WIDTH-1:0] x_in [0:n_x-1];
    reg signed [WIDTH-1:0] w_in [0:n_w-1];
    reg signed [WIDTH-1:0] b_in [0:n_b-1];


    

    // reg signed [WIDTH-1:0] y_out [0:3];
    reg signed [WIDTH-1:0] y_out [0:3];



    initial begin

    $dumpfile("wave.vcd");  // nama file untuk GTKWave
    $dumpvars(0, tb_gan_v3); // rekam semua sinyal dalam testbench

    x_in[0] = 32'sd0;
    x_in[1] = 32'sd1;
    x_in[2] = 32'sd1;
    x_in[3] = 32'sd0;

    w_in[0]  = 32'sd6; // w11
    w_in[1]  = -32'sd3; // w21
    w_in[2]  = 32'sd5; // w31
    w_in[3]  = -32'sd16; // w41

    w_in[4]  = 32'sd21; // w12
    w_in[5]  = 32'sd16; // w22
    w_in[6]  = -32'sd6; // w32
    w_in[7]  = -32'sd9; // w42

    w_in[8]  = 32'sd3;  // w13
    w_in[9]  = -32'sd3; // w23
    w_in[10] = -32'sd15; // w33
    w_in[11] = -32'sd17; // w43

    w_in[12] = 32'sd18; // w14
    w_in[13] = 32'sd12; // w24
    w_in[14] = -32'sd4; // w34
    w_in[15] = -32'sd8; // w44

    b_in[0] = 32'sd1;
    b_in[1] = 32'sd0;
    b_in[2] = 32'sd2;
    b_in[3] = -32'sd1;

    w_in[16] = 32'sd4; // w11
    w_in[17] = 32'sd14; // w21
    w_in[18] = 32'sd8;  // w31
    w_in[19] = 32'sd15; // w41

    w_in[20] = -32'sd14; // w12
    w_in[21] = 32'sd14;  // w22
    w_in[22] = 32'sd9;   // w32
    w_in[23] = 32'sd15;  // w42

    b_in[4] = 32'sd1; // b14
    b_in[5] = 32'sd4; // b24

    w_in[24] = 32'sd14; // w11
    w_in[25] = 32'sd6;  // w21

    b_in[6] = 32'sd5;

    w_in[26] = 32'sd7; // w11
    b_in[7] = 32'sd10;

    w_in[27] = 32'sd1; // w11
    b_in[8] = -32'sd4;

    w_in[28] = -32'sd8; // w11
    w_in[29] = 32'sd14; // w12
    b_in[9] = 32'sd20;
    b_in[10] = 32'sd0;

    w_in[30] = 32'sd4; //w11
    w_in[31] = -32'sd14; // w21

    w_in[32] = 32'sd14; // w12
    w_in[33] = 32'sd14; // w22

    w_in[34] = 32'sd8; // w13
    w_in[35] = 32'sd9; // w23

    w_in[36] = 32'sd15; // w14
    w_in[37] = 32'sd15; // w24

    b_in[11] = 32'sd5;
    b_in[12] = 32'sd3;
    b_in[13] = 32'sd1;
    b_in[14] = 32'sd2;
   // layer 8
    w_in[38] = 32'sd11; // w11
    w_in[39] = 32'sd9;  // w21
    w_in[40] = 32'sd10; // w31
    w_in[41] = 32'sd1;  // w41

    w_in[42] = -32'sd7; // w12
    w_in[43] = -32'sd6; // w22
    w_in[44] = -32'sd15; // w32
    w_in[45] = 32'sd17; // w42

    w_in[46] = 32'sd10; // w13
    w_in[47] = 32'sd11; // w23
    w_in[48] = -32'sd5; // w33
    w_in[49] = 32'sd4;  // w43

    w_in[50] = -32'sd7; // w14
    w_in[51] = -32'sd7; // w24
    w_in[52] = 32'sd7;  // w34
    w_in[53] = 32'sd12; // w44

    b_in[15] = -32'sd10;
    b_in[16] = 32'sd10;
    b_in[17] = 32'sd10;
    b_in[18] = -32'sd10;

    clk = 0;
    rst = 1;
        we  = 0;
        start = 0;
        addr = 0;
        data_in = 0;

        #10 rst = 0;

        // mulai loading data
        we = 1;
        for (i = 0; i < 4; i = i + 1) begin  // 4 (x) + 16 (w) + 4 (b)
            @(posedge clk);
            addr <= i;  
            data_in <= x_in[i];  // isi dengan nilai 0,1,2,...23
        end

        for (i = 0; i < 54; i = i + 1) begin  // 4 (x) + 16 (w) + 4 (b)
            @(posedge clk);
            addr <= i + 4;  
            data_in <= w_in[i];  // isi dengan nilai 0,1,2,...23
        end

        for (i = 0; i < 19; i = i + 1) begin  // 4 (x) + 16 (w) + 4 (b)
            @(posedge clk);
            addr <= i + 58;  
            data_in <= b_in[i];  // isi dengan nilai 0,1,2,...23
        end
        repeat(2) @(posedge clk);

        we = 0;

        // tunggu sebentar

        // print isi register x, w, b
        // $display("\n=== ISI REGISTER X ===");
        // for (i = 0; i < uut.n_x; i = i + 1)
        //     $display("x[%0d] = %0d", i, uut.x[i]);

        // $display("\n=== ISI REGISTER W ===");
        // for (i = 0; i < uut.n_w; i = i + 1)
        //     $display("w[%0d] = %0d", i, uut.w[i]);

        // $display("\n=== ISI REGISTER B ===");
        // for (i = 0; i < uut.n_b; i = i + 1)
        //     $display("b[%0d] = %0d", i, uut.b[i]);

        // $display ("\n nilai addr: %0d", addr);
        $display("== GAN LEVEL 3 : Hardware Sharing ==");

        $display("\n nilai done_loading: %b", uut.done_loading);
        
        $display("\n=== TEST SELESAI ===");

        repeat(114) @(posedge clk);
        $display("neuron_key = %0d", uut.neuron_key);


        @(posedge clk);
        $display("data_out1 = %0d", uut.data_out);
        @(posedge clk);
        $display("data_out2 = %0d", uut.data_out);
        @(posedge clk);
        $display("data_out3 = %0d", uut.data_out);
        @(posedge clk);
        $display("data_out4 = %0d", uut.data_out);



        $stop;
        $finish;
    end


    
endmodule
