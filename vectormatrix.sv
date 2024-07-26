`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TeamWSL
// Engineer: Warren Jayakumar
// 
// Create Date: 07/23/2024 11:54:53 PM
// Design Name: Matrix Vector Multiply
// Module Name: systolicmatrixvector
// Project Name: DVCON 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module systolicmatrixvector(
    input logic signed [7:0] in_vector [63:0],
    input clk,
    input rstn,
    output logic signed [7:0] out_vector [63:0]
);
    reg signed [7:0] matrix [63:0][63:0];
    reg signed [15:0] sum;
    //    integer i,j;

    // for testing purposes, we initialize the matrix with random values
    initial begin
        // Example: Initializing matrix with a pattern
        for (int i = 0; i < 64; i = i + 1) begin
            for (int j = 0; j < 64; j = j + 1) begin
                matrix[i][j] = $random % 256 - 128; // Random value between -128 and 127
            end
        end
    end

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (int i = 0; i < 64; i = i + 1) begin
                out_vector[i] <= 8'sd0;
            end
        end else begin
            for (int i = 0; i < 64; i = i + 1) begin
                sum = 16'sd0;
                for (int j = 0; j < 64; j = j + 1) begin
                    sum += in_vector[j] * matrix[i][j];
                end
                if (sum > 16'sd127)
                    out_vector[i] <= 8'sd127;
                else if (sum < -16'sd128)
                    out_vector[i] <= -8'sd128;
                else
                    out_vector[i] <= sum[7:0];
            end
        end
    end
endmodule
