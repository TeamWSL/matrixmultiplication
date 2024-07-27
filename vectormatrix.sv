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

module systolicmatrixvector
#(
    parameter  WIDTH = 8,
    parameter SIZE = 64)
    (
    input logic signed [7:0] in_vector [SIZE - 1:0],
    input clk,
    input rstn,
    input signed [WIDTH - 1:0] matrix [SIZE - 1:0][SIZE - 1:0],
    output logic signed [WIDTH - 1:0] out_vector [SIZE - 1:0]
);


    reg signed [2 * WIDTH - 1:0] sum [SIZE - 1:0];
    reg signed [2 * WIDTH - 1:0] partial_sum [SIZE - 1:0][SIZE - 1:0];

    // Always block for calculating partial sums
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (int i = 0; i < SIZE; i = i + 1) begin
                for (int j = 0; j < SIZE; j = j + 1) begin
                    partial_sum[i][j] <= 16'sd0;
                end
            end
        end else begin
            for (int i = 0; i < SIZE; i = i + 1) begin
                for (int j = 0; j < SIZE; j = j + 1) begin
                    partial_sum[i][j] <= in_vector[j] * matrix[i][j];
                end
            end
        end
    end

    // Always block for summing partial sums and assigning to output
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (int i = 0; i < SIZE; i = i + 1) begin
                sum[i] <= 16'sd0;
                out_vector[i] <= 8'sd0;
            end
        end else begin
            for (int i = 0; i < SIZE; i = i + 1) begin
                sum[i] <= 16'sd0;
            end

            for (int i = 0; i < SIZE; i = i + 1) begin
                for (int j = 0; j < SIZE; j = j + 1) begin
                    sum[i] = sum[i] + partial_sum[i][j];
                end
            end

            for (int i = 0; i < SIZE; i = i + 1) begin
                if (sum[i] > 16'sd127)
                    out_vector[i] <= 8'sd127;
                else if (sum[i] < -16'sd128)
                    out_vector[i] <= -8'sd128;
                else
                    out_vector[i] <= sum[i][WIDTH - 1:0]; // Only take the lower 8 bits of the sum
            end
        end
    end
endmodule


