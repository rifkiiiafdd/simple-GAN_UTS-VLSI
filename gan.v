module gan 

#(parameter WIDTH=32, 
    parameter WIDTH_L1=32,
    parameter WIDTH_L2=32,
    parameter WIDTH_L3=32,
    parameter WIDTH_L4=32,
    parameter WIDTH_L5=32,
    parameter WIDTH_L6=32,
    parameter WIDTH_L7=32,
    parameter WIDTH_L8=32
)


(
    // input
    input wire signed [WIDTH-1:0] x_1,
    input wire signed [WIDTH-1:0] x_2,
    input wire signed [WIDTH-1:0] x_3,
    input wire signed [WIDTH-1:0] x_4,

    // layer 1 weights and biases
    input wire signed [WIDTH-1:0] w1_11,
    input wire signed [WIDTH-1:0] w1_12,
    input wire signed [WIDTH-1:0] w1_13,
    input wire signed [WIDTH-1:0] w1_14,

    input wire signed [WIDTH-1:0] w1_21,
    input wire signed [WIDTH-1:0] w1_22,
    input wire signed [WIDTH-1:0] w1_23,
    input wire signed [WIDTH-1:0] w1_24,

    input wire signed [WIDTH-1:0] w1_31,
    input wire signed [WIDTH-1:0] w1_32,
    input wire signed [WIDTH-1:0] w1_33,
    input wire signed [WIDTH-1:0] w1_34,

    input wire signed [WIDTH-1:0] w1_41,
    input wire signed [WIDTH-1:0] w1_42,
    input wire signed [WIDTH-1:0] w1_43,
    input wire signed [WIDTH-1:0] w1_44,


    input wire signed [WIDTH-1:0] b1_1,
    input wire signed [WIDTH-1:0] b1_2,
    input wire signed [WIDTH-1:0] b1_3,
    input wire signed [WIDTH-1:0] b1_4,

    // layer 2 weights and biases

    input wire signed [WIDTH-1:0] w2_11,
    input wire signed [WIDTH-1:0] w2_12,
    input wire signed [WIDTH-1:0] w2_31,
    input wire signed [WIDTH-1:0] w2_32,

    input wire signed [WIDTH-1:0] w2_21,
    input wire signed [WIDTH-1:0] w2_22,
    input wire signed [WIDTH-1:0] w2_41,
    input wire signed [WIDTH-1:0] w2_42,

    input wire signed [WIDTH-1:0] b2_1,
    input wire signed [WIDTH-1:0] b2_2,

    // layer 3 weights and biases
    input wire signed [WIDTH-1:0] w3_11,
    input wire signed [WIDTH-1:0] w3_21,

    input wire signed [WIDTH-1:0] b3_1,






    // layer 4 weight and bias

    input wire signed [WIDTH-1:0] w4_11,
    input wire signed [WIDTH-1:0] b4_1,

    // generator
    // layer 5    
    input wire signed [WIDTH-1:0] w5_11,
    input wire signed [WIDTH-1:0] b5_1,

    // layer 6

    input wire signed [WIDTH-1:0] w6_11,
    input wire signed [WIDTH-1:0] w6_12,

    input wire signed [WIDTH-1:0] b6_1,
    input wire signed [WIDTH-1:0] b6_2,

    // layer 7

    input wire signed [WIDTH-1:0] w7_11,
    input wire signed [WIDTH-1:0] w7_12,
    input wire signed [WIDTH-1:0] w7_13,
    input wire signed [WIDTH-1:0] w7_14,

    input wire signed [WIDTH-1:0] w7_21,
    input wire signed [WIDTH-1:0] w7_22,
    input wire signed [WIDTH-1:0] w7_23,
    input wire signed [WIDTH-1:0] w7_24,

    input wire signed [WIDTH-1:0] b7_1,
    input wire signed [WIDTH-1:0] b7_2,
    input wire signed [WIDTH-1:0] b7_3,
    input wire signed [WIDTH-1:0] b7_4,


    // layer 8

    input wire signed [WIDTH-1:0] w8_11,
    input wire signed [WIDTH-1:0] w8_12,
    input wire signed [WIDTH-1:0] w8_13,
    input wire signed [WIDTH-1:0] w8_14,

    input wire signed [WIDTH-1:0] w8_21,
    input wire signed [WIDTH-1:0] w8_22,
    input wire signed [WIDTH-1:0] w8_23,
    input wire signed [WIDTH-1:0] w8_24,

    input wire signed [WIDTH-1:0] w8_31,
    input wire signed [WIDTH-1:0] w8_32,
    input wire signed [WIDTH-1:0] w8_33,
    input wire signed [WIDTH-1:0] w8_34,

    input wire signed [WIDTH-1:0] w8_41,
    input wire signed [WIDTH-1:0] w8_42,
    input wire signed [WIDTH-1:0] w8_43,
    input wire signed [WIDTH-1:0] w8_44,


    input wire signed [WIDTH-1:0] b8_1,
    input wire signed [WIDTH-1:0] b8_2,
    input wire signed [WIDTH-1:0] b8_3,
    input wire signed [WIDTH-1:0] b8_4,

    // output
    output reg signed [WIDTH_L8-1:0] out1,
    output reg signed [WIDTH_L8-1:0] out2,
    output reg signed [WIDTH_L8-1:0] out3,
    output reg signed [WIDTH_L8-1:0] out4
);

    // layer 1
    reg signed [WIDTH_L1-1:0] l1_1;
    reg signed [WIDTH_L1-1:0] l1_2;
    reg signed [WIDTH_L1-1:0] l1_3;
    reg signed [WIDTH_L1-1:0] l1_4;

    // layer 2

    reg signed [WIDTH_L2-1:0] l2_1;
    reg signed [WIDTH_L2-1:0] l2_2;

    // layer 3
    reg signed [WIDTH_L3-1:0] l3_1;

    // layer 4
    reg signed [WIDTH_L4-1:0] l4_1;

    // layer 5
    reg signed [WIDTH_L5-1:0] l5_1;
    // layer 6
    reg signed [WIDTH_L6-1:0] l6_1;
    reg signed [WIDTH_L6-1:0] l6_2;

    // layer 7
    reg signed [WIDTH_L7-1:0] l7_1;
    reg signed [WIDTH_L7-1:0] l7_2;
    reg signed [WIDTH_L7-1:0] l7_3;
    reg signed [WIDTH_L7-1:0] l7_4;

    // layer 8
    reg signed [WIDTH_L8-1:0] l8_1;
    reg signed [WIDTH_L8-1:0] l8_2;
    reg signed [WIDTH_L8-1:0] l8_3;
    reg signed [WIDTH_L8-1:0] l8_4;

    always @(*) begin

    // layer 1
    l1_1 = x_1*w1_11 + x_2*w1_21 + x_3*w1_31 + x_4*w1_41 + b1_1;
    l1_2 = x_1*w1_12 + x_2*w1_22 + x_3*w1_32 + x_4*w1_42 + b1_2;
    l1_3 = x_1*w1_13 + x_2*w1_23 + x_3*w1_33 + x_4*w1_43 + b1_3;
    l1_4 = x_1*w1_14 + x_2*w1_24 + x_3*w1_34 + x_4*w1_44 + b1_4;

    if (l1_1 < 0) l1_1 = 0;
    if (l1_2 < 0) l1_2 = 0;
    if (l1_3 < 0) l1_3 = 0;
    if (l1_4 < 0) l1_4 = 0;

    // layer 2

    l2_1 = l1_1*w2_11 + l1_2*w2_21 + l1_3*w2_31 + l1_4*w2_41 + b2_1;
    l2_2 = l1_1*w2_12 + l1_2*w2_22 + l1_3*w2_32 + l1_4*w2_42 + b2_2;

    if (l2_1 < 0) l2_1 = 0;
    if (l2_2 < 0) l2_2 = 0;

    // layer 3
    l3_1 = l2_1*w3_11 + l2_2*w3_21 + b3_1;

    if (l3_1 < 0) l3_1 = 0;

    // layer 4
    l4_1 = l3_1*w4_11 + b4_1;

    if (l4_1 < 0) l4_1 = 0;

    // layer 5
    l5_1 = l4_1*w5_11 + b5_1;
    if (l5_1 < 0) l5_1 = 0;

    // layer 6
    l6_1 = l5_1*w6_11 + b6_1;
    l6_2 = l5_1*w6_12 + b6_2;
    if (l6_1 < 0) l6_1 = 0;
    if (l6_2 < 0) l6_2 = 0;

    // layer 7
    l7_1 = l6_1*w7_11 + l6_2*w7_21 + b7_1;
    l7_2 = l6_1*w7_12 + l6_2*w7_22 + b7_2;
    l7_3 = l6_1*w7_13 + l6_2*w7_23 + b7_3;
    l7_4 = l6_1*w7_14 + l6_2*w7_24 + b7_4;

    if (l7_1 < 0) l7_1 = 0;
    if (l7_2 < 0) l7_2 = 0;
    if (l7_3 < 0) l7_3 = 0;
    if (l7_4 < 0) l7_4 = 0;

    // layer 8
    l8_1 = l7_1*w8_11 + l7_2*w8_21 + l7_3*w8_31 + l7_4*w8_41 + b8_1;
    l8_2 = l7_1*w8_12 + l7_2*w8_22 + l7_3*w8_32 + l7_4*w8_42 + b8_2;
    l8_3 = l7_1*w8_13 + l7_2*w8_23 + l7_3*w8_33 + l7_4*w8_43 + b8_3;
    l8_4 = l7_1*w8_14 + l7_2*w8_24 + l7_3*w8_34 + l7_4*w8_44 + b8_4;

    if (l8_1 < 0) l8_1 = 0;
    if (l8_2 < 0) l8_2 = 0;
    if (l8_3 < 0) l8_3 = 0;
    if (l8_4 < 0) l8_4 = 0;

    // output
    out1 = l8_1;
    out2 = l8_2;
    out3 = l8_3;
    out4 = l8_4;

    end

endmodule

