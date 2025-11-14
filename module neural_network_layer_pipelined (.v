module neural_network_layer_pipelined (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire signed [31:0] x_1, x_2, x_3, x_4,
    input wire signed [31:0] w1_11, w1_12, w1_13, w1_14, b1_1,
    input wire signed [31:0] w1_21, w1_22, w1_23, w1_24, b1_2,
    input wire signed [31:0] w1_31, w1_32, w1_33, w1_34, b1_3,
    input wire signed [31:0] w1_41, w1_42, w1_43, w1_44, b1_4,
    output reg signed [31:0] l1_1, l1_2, l1_3, l1_4,
    output reg valid
);

    // State machine states
    localparam IDLE = 5'd0;
    localparam CALC_L1_1_X1 = 5'd1;
    localparam CALC_L1_1_X2 = 5'd2;
    localparam CALC_L1_1_X3 = 5'd3;
    localparam CALC_L1_1_X4 = 5'd4;
    localparam CALC_L1_2_X1 = 5'd5;
    localparam CALC_L1_2_X2 = 5'd6;
    localparam CALC_L1_2_X3 = 5'd7;
    localparam CALC_L1_2_X4 = 5'd8;
    localparam CALC_L1_3_X1 = 5'd9;
    localparam CALC_L1_3_X2 = 5'd10;
    localparam CALC_L1_3_X3 = 5'd11;
    localparam CALC_L1_3_X4 = 5'd12;
    localparam CALC_L1_4_X1 = 5'd13;
    localparam CALC_L1_4_X2 = 5'd14;
    localparam CALC_L1_4_X3 = 5'd15;
    localparam CALC_L1_4_X4 = 5'd16;
    localparam DONE = 5'd17;

    reg [4:0] state, next_state;
    
    // Multiplier inputs and output
    reg signed [31:0] mult_a, mult_b;
    wire signed [63:0] mult_out;
    
    // Accumulator registers
    reg signed [63:0] acc_l1_1, acc_l1_2, acc_l1_3, acc_l1_4;
    
    // Single multiplier
    assign mult_out = mult_a * mult_b;
    
    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? CALC_L1_1_X1 : IDLE;
            CALC_L1_1_X1: next_state = CALC_L1_1_X2;
            CALC_L1_1_X2: next_state = CALC_L1_1_X3;
            CALC_L1_1_X3: next_state = CALC_L1_1_X4;
            CALC_L1_1_X4: next_state = CALC_L1_2_X1;
            CALC_L1_2_X1: next_state = CALC_L1_2_X2;
            CALC_L1_2_X2: next_state = CALC_L1_2_X3;
            CALC_L1_2_X3: next_state = CALC_L1_2_X4;
            CALC_L1_2_X4: next_state = CALC_L1_3_X1;
            CALC_L1_3_X1: next_state = CALC_L1_3_X2;
            CALC_L1_3_X2: next_state = CALC_L1_3_X3;
            CALC_L1_3_X3: next_state = CALC_L1_3_X4;
            CALC_L1_3_X4: next_state = CALC_L1_4_X1;
            CALC_L1_4_X1: next_state = CALC_L1_4_X2;
            CALC_L1_4_X2: next_state = CALC_L1_4_X3;
            CALC_L1_4_X3: next_state = CALC_L1_4_X4;
            CALC_L1_4_X4: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Multiplier input selection and accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mult_a <= 32'd0;
            mult_b <= 32'd0;
            acc_l1_1 <= 64'd0;
            acc_l1_2 <= 64'd0;
            acc_l1_3 <= 64'd0;
            acc_l1_4 <= 64'd0;
            l1_1 <= 32'd0;
            l1_2 <= 32'd0;
            l1_3 <= 32'd0;
            l1_4 <= 32'd0;
            valid <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 1'b0;
                    if (start) begin
                        acc_l1_1 <= {b1_1[31], b1_1, 31'd0}; // Initialize with bias
                        acc_l1_2 <= {b1_2[31], b1_2, 31'd0};
                        acc_l1_3 <= {b1_3[31], b1_3, 31'd0};
                        acc_l1_4 <= {b1_4[31], b1_4, 31'd0};
                    end
                end
                
                // Layer 1, Neuron 1
                CALC_L1_1_X1: begin
                    mult_a <= x_1;
                    mult_b <= w1_11;
                end
                CALC_L1_1_X2: begin
                    acc_l1_1 <= acc_l1_1 + mult_out;
                    mult_a <= x_2;
                    mult_b <= w1_12;
                end
                CALC_L1_1_X3: begin
                    acc_l1_1 <= acc_l1_1 + mult_out;
                    mult_a <= x_3;
                    mult_b <= w1_13;
                end
                CALC_L1_1_X4: begin
                    acc_l1_1 <= acc_l1_1 + mult_out;
                    mult_a <= x_4;
                    mult_b <= w1_14;
                end
                
                // Layer 1, Neuron 2
                CALC_L1_2_X1: begin
                    acc_l1_1 <= acc_l1_1 + mult_out;
                    l1_1 <= acc_l1_1[63:32] + mult_out[63:32]; // Store result
                    mult_a <= x_1;
                    mult_b <= w1_21;
                end
                CALC_L1_2_X2: begin
                    acc_l1_2 <= acc_l1_2 + mult_out;
                    mult_a <= x_2;
                    mult_b <= w1_22;
                end
                CALC_L1_2_X3: begin
                    acc_l1_2 <= acc_l1_2 + mult_out;
                    mult_a <= x_3;
                    mult_b <= w1_23;
                end
                CALC_L1_2_X4: begin
                    acc_l1_2 <= acc_l1_2 + mult_out;
                    mult_a <= x_4;
                    mult_b <= w1_24;
                end
                
                // Layer 1, Neuron 3
                CALC_L1_3_X1: begin
                    acc_l1_2 <= acc_l1_2 + mult_out;
                    l1_2 <= acc_l1_2[63:32] + mult_out[63:32]; // Store result
                    mult_a <= x_1;
                    mult_b <= w1_31;
                end
                CALC_L1_3_X2: begin
                    acc_l1_3 <= acc_l1_3 + mult_out;
                    mult_a <= x_2;
                    mult_b <= w1_32;
                end
                CALC_L1_3_X3: begin
                    acc_l1_3 <= acc_l1_3 + mult_out;
                    mult_a <= x_3;
                    mult_b <= w1_33;
                end
                CALC_L1_3_X4: begin
                    acc_l1_3 <= acc_l1_3 + mult_out;
                    mult_a <= x_4;
                    mult_b <= w1_34;
                end
                
                // Layer 1, Neuron 4
                CALC_L1_4_X1: begin
                    acc_l1_3 <= acc_l1_3 + mult_out;
                    l1_3 <= acc_l1_3[63:32] + mult_out[63:32]; // Store result
                    mult_a <= x_1;
                    mult_b <= w1_41;
                end
                CALC_L1_4_X2: begin
                    acc_l1_4 <= acc_l1_4 + mult_out;
                    mult_a <= x_2;
                    mult_b <= w1_42;
                end
                CALC_L1_4_X3: begin
                    acc_l1_4 <= acc_l1_4 + mult_out;
                    mult_a <= x_3;
                    mult_b <= w1_43;
                end
                CALC_L1_4_X4: begin
                    acc_l1_4 <= acc_l1_4 + mult_out;
                    mult_a <= x_4;
                    mult_b <= w1_44;
                end
                
                DONE: begin
                    acc_l1_4 <= acc_l1_4 + mult_out;
                    l1_4 <= acc_l1_4[63:32] + mult_out[63:32]; // Store result
                    valid <= 1'b1;
                end
            endcase
        end
    end

endmodule