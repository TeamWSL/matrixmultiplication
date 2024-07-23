`timescale 1ns / 1ps

module systolic_array_16x16_tb();

    parameter integer MATRIX_SIZE = 16;

    reg clk;
    reg reset;
    reg signed [7:0] A [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
    reg signed [7:0] B [0:MATRIX_SIZE-1];
    wire signed [7:0] C [0:MATRIX_SIZE-1];

    // UUT
    systolic_array_16x16 uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .C(C)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; 
    end


    initial begin
        reset = 1'b1;
        // make identity matrix 
        for (int i = 0; i < MATRIX_SIZE; i = i + 1) begin
            for (int j = 0; j < MATRIX_SIZE; j = j + 1) begin
                A[i][j] = (i == j) ? 8'd1 : 8'd0; 
            end
            // input vector with values 1 to 16
            B[i] = i + 1; 
        end
        #15;

        reset = 1'b0;
        #100;


        $display("Result Vector C:");
        for (int i = 0; i < MATRIX_SIZE; i = i + 1) begin
            $display("C[%0d] = %0d", i, C[i]);
        end
        $finish;
        
    end

endmodule
