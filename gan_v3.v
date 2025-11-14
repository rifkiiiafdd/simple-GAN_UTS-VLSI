module gan_v3 #(parameter WIDTH=32)
(
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] data_in,
    input wire [7:0] addr,
    input wire we,
    input wire start,

    // output
    output reg signed [WIDTH-1:0] data_out,

    output reg data_valid
);

   

    // memori 1 neuron
    reg signed [WIDTH-1:0] X1, X2, X3, X4;
    reg signed [WIDTH-1:0] Y [0:3];
    reg signed [WIDTH-1:0] W1, W2, W3, W4;
    reg signed [WIDTH-1:0] B;

    reg signed [WIDTH-1:0] mult_result [0:3];

    reg [2:0] y_key;
    reg [4:0] neuron_key;

    reg [2:0] output_key;


    reg signed [WIDTH-1:0] temp, temp_add1, temp_add2;

    // input\
     parameter n_x = 4;
    parameter n_w = 54;
    parameter n_b = 19;
    
    reg signed [WIDTH-1:0] x [0: n_x-1];

    reg signed [WIDTH-1:0] w [0: n_w-1];

    reg signed [WIDTH-1:0] b [0: n_b-1];

    // data input register

    reg done_loading;

    reg [3:0] STATE;
    parameter LOAD_DATA = 4'b0001, ASSIGN   = 4'b0010,
              MULTIPLY = 4'b0011, ADD_1      = 4'b0111, ADD_2      = 4'b1000,
                ADD_BIAS = 4'b0100, RELU       = 4'b0101, FINISH     = 4'b0110;


    always @(posedge clk ) begin

    if (rst) begin
        X1 <= 0; X2 <= 0; X3 <= 0; X4 <= 0;
        Y[0] <= 0; Y[1] <= 0; Y[2] <= 0; Y[3] <= 0;
        W1 <= 0; W2 <= 0; W3 <= 0; W4 <= 0;
        B <= 0;
        done_loading <= 1'b0;

        STATE <= LOAD_DATA;

    end // if rst

    else begin

        case (STATE)

            LOAD_DATA : begin

                if (we) begin

                    if (addr < n_x) begin
                        x[addr] <= data_in;
                    end // if x

                    else if (addr < n_x + n_w) begin
                        w[addr - n_x] <= data_in;
                    end // if w

                    else if (addr < n_x + n_w + n_b ) begin
                        b[addr - n_x - n_w] <= data_in;
                    end // if b

                    if (addr == n_x + n_w + n_b - 1) begin
                        STATE <= ASSIGN;
                        done_loading <= 1'b1;
                        neuron_key <= 0;
                    end

                end // if we

            end // LOAD_DATA

            ASSIGN : begin

                case (neuron_key) 
                // layer 1
                    0: begin
                        X1 <= x[0];
                        X2 <= x[1];
                        X3 <= x[2];
                        X4 <= x[3];

                        W1 <= w[0];
                        W2 <= w[1];
                        W3 <= w[2];
                        W4 <= w[3];

                        B  <= b[0];

                        y_key <= 0;
                        
                        neuron_key <= neuron_key + 1;
                    end //0

                    1: begin

                        W1 <= w[4];
                        W2 <= w[5];
                        W3 <= w[6];
                        W4 <= w[7];

                        B  <= b[1];

                        y_key <= 1;

                        neuron_key <= neuron_key + 1;
                    end //1

                    2: begin

                        W1 <= w[8];
                        W2 <= w[9];
                        W3 <= w[10];
                        W4 <= w[11];

                        B  <= b[2];

                        y_key <= 2;

                        neuron_key <= neuron_key + 1;
                    end //2

                    3: begin

                        W1 <= w[12];
                        W2 <= w[13];
                        W3 <= w[14];
                        W4 <= w[15];

                        B  <= b[3];

                        y_key <= 3;

                        STATE <= MULTIPLY;

                        neuron_key <= neuron_key + 1;

                    end //3

                    // layer 2
                    4 : begin 
                        X1 <= Y[0];
                        X2 <= Y[1];
                        X3 <= Y[2];
                        X4 <= Y[3];
                        W1 <= w[16];
                        W2 <= w[17];
                        W3 <= w[18];
                        W4 <= w[19];
                        B  <= b[4];
                        y_key <= 0;

                        neuron_key <= neuron_key + 1;
                        
                    end //4

                    5 : begin 
                        W1 <= w[20];
                        W2 <= w[21];
                        W3 <= w[22];
                        W4 <= w[23];

                        B  <= b[5];

                        y_key <= 1;
                        
                        neuron_key <= neuron_key + 1;

                    end //5

                    // layer 3
                    6 : begin
                        X1 <= Y[0];
                        X2 <= Y[1];
                        X3 <= 0;
                        X4 <= 0;
                        W1 <= w[24];
                        W2 <= w[25];
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[6];
                        y_key <= 0;

                        neuron_key <= neuron_key + 1;
                        
                    end //6

                    // layer 4
                    7 : begin
                        X1 <= Y[0];
                        X2 <= 0;
                        X3 <= 0;
                        X4 <= 0;
                        W1 <= w[26];
                        W2 <= 0;
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[7];
                        y_key <= 0;

                        neuron_key <= neuron_key + 1;
                        
                    end //7
                    // layer 5
                    8 : begin
                        X1 <= Y[0];
                        X2 <= 0;
                        X3 <= 0;
                        X4 <= 0;
                        W1 <= w[27];
                        W2 <= 0;
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[8];
                        y_key <= 0;

                        neuron_key <= neuron_key + 1;
                        
                    end //8

                    // layer 6
                    9 : begin
                        X1 <= Y[0];
                        X2 <= 0;
                        X3 <= 0;
                        X4 <= 0;
                        W1 <= w[28];
                        W2 <= 0;
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[9];
                        y_key <= 0;

                        neuron_key <= neuron_key + 1;
                        
                    end //9

                    10 : begin
                        W1 <= w[29];
                        W2 <= 0;
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[10];
                        y_key <= 1;

                        neuron_key <= neuron_key + 1;
                        
                    end //10

                    // layer 7
                    11 : begin
                        X1 <= Y[0];
                        X2 <= Y[1];
                        X3 <= 0;
                        X4 <= 0;
                        W1 <= w[30];
                        W2 <= w[31];
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[11];
                        y_key <= 0;

                        neuron_key <= neuron_key + 1;
                        
                    end //11

                    12 : begin
                        W1 <= w[32];
                        W2 <= w[33];
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[12];
                        y_key <= 1;

                        neuron_key <= neuron_key + 1;
                        
                    end //12

                    13 : begin
                        W1 <= w[34];
                        W2 <= w[35];
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[13];
                        y_key <= 2;

                        neuron_key <= neuron_key + 1;
                        
                    end //13

                    14 : begin
                        W1 <= w[36];
                        W2 <= w[37];
                        W3 <= 0;
                        W4 <= 0;
                        B  <= b[14];
                        y_key <= 3;

                        neuron_key <= neuron_key + 1;
                        
                    end //14

                    // layer 8

                    15 : begin
                        X1 <= Y[0];
                        X2 <= Y[1];
                        X3 <= Y[2];
                        X4 <= Y[3];

                        W1 <= w[38];
                        W2 <= w[39];
                        W3 <= w[40];
                        W4 <= w[41];

                        B  <= b[15];

                        y_key <= 0;

                        neuron_key <= neuron_key + 1;
                    end //15

                    16 : begin

                        W1 <= w[42];
                        W2 <= w[43];
                        W3 <= w[44];
                        W4 <= w[45];

                        B  <= b[16];

                        y_key <= 1;

                        neuron_key <= neuron_key + 1;
                    end //16

                    17 : begin

                        W1 <= w[46];
                        W2 <= w[47];
                        W3 <= w[48];
                        W4 <= w[49];

                        B  <= b[17];

                        y_key <= 2;

                        neuron_key <= neuron_key + 1;
                    end //17

                    18 : begin

                        W1 <= w[50];
                        W2 <= w[51];
                        W3 <= w[52];
                        W4 <= w[53];

                        B  <= b[18];

                        y_key <= 3;

                        neuron_key <= neuron_key + 1;
                    end //18


                    default: ;
                    


                endcase // neuron_key
                STATE <= MULTIPLY;
                end // ASSIGN

            MULTIPLY : begin

                mult_result[0] <= X1*W1;
                mult_result[1] <= X2*W2;
                mult_result[2] <= X3*W3;
                mult_result[3] <= X4*W4;

                STATE <= ADD_1;

            end // MULTIPLY


            ADD_1 : begin
                temp_add1 <= mult_result[0] + mult_result[1];
                temp_add2 <= mult_result[2] + mult_result[3];
                STATE <= ADD_2;
            end // ADD_1

            ADD_2 : begin
                Y[y_key] <= temp_add1 + temp_add2;
                STATE <= ADD_BIAS;
            end // ADD_2

            ADD_BIAS : begin

                Y[y_key] <= Y[y_key] + B;
                STATE <= RELU;

            end // ADD

            RELU : begin
                temp = Y[y_key];
                if (temp < 0)
                    Y[y_key] <= 0;
                else
                    Y[y_key] <= temp;

                if (neuron_key < 19) begin
                    STATE <= ASSIGN;
                end else begin
                    STATE <= FINISH;
                    output_key <= 0;
                end

            end // ADD

           
            FINISH : begin
                case (output_key)
                    0: begin
                        data_out <= Y[0];
                        output_key <= output_key + 1;
                    end
                    1: begin
                        data_out <= Y[1];
                        output_key <= output_key + 1;
                    end
                    2: begin
                        data_out <= Y[2];
                        output_key <= output_key + 1;
                    end
                    3: begin
                        data_out <= Y[3];
                        output_key <= output_key + 1;
                        data_valid <= 1'b1;
                    end
                    default: ;
                endcase // output_key
            end // FINISH



            default: ;
        endcase // state    

    end // else rst
    end // always posedge clk or rst

    
endmodule