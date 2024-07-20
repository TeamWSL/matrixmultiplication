`timescale 1ns / 1ps

module systolic_array_16x16 (
    input wire clk,
    input wire reset,
    input wire signed [7:0] A [0:15][0:15], // matrix
    input wire signed [7:0] B [0:15],       // vector
    output reg signed [7:0] C [0:15]
);
    
    reg signed [15:0] c_out [0:15][0:15];
    integer i, j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    c_out[i][j] <= 16'b0;
                end
            end

            for (i = 0; i < 16; i = i + 1) begin
                C[i] <= 8'b0;
            end

        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    if (i == 0) begin
                        c_out[i][j] <= A[i][j] * B[j];
                    end else begin
                        c_out[i][j] <= A[i][j] * B[j] + c_out[i-1][j];
                    end
                end
            end

            for (j = 0; j < 16; j = j + 1) begin
                C[j] <= c_out[15][j][7:0]; 
            end
        end
    end

endmodule
