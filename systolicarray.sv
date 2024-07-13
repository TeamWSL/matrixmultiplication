`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 07:45:18 AM
// Design Name: 
// Module Name: systolicarray
// Project Name: 
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

module systolic_array_8x8 (
    input wire clk,
    input wire reset,
    input wire signed [7:0] A [0:7][0:7],
    input wire signed [7:0] B [0:7][0:7],
    output reg signed [15:0] C [0:7][0:7]
);
    reg signed [15:0] c_out [0:7][0:7];
    reg signed [7:0] a_out [0:7][0:7];
    reg signed [7:0] b_out [0:7][0:7];


genvar i, j;
generate
    for (i = 0; i < 8; i = i + 1) begin : row
        for (j = 0; j < 8; j = j + 1) begin : col
            if (i == 0 && j == 0) begin
                pe pe_inst (
                    .clk(clk),
                    .reset(reset),
                    .a(A[i][j]),
                    .b(B[i][j]),
                    .c_in(8'b0),
                    .c_out(c_out[i][j]),
                    .a_out(a_out[i][j]),
                    .b_out(b_out[i][j])
                );
            end else if (i == 0) begin
                pe pe_inst (
                    .clk(clk),
                    .reset(reset),
                    .a(A[i][j]),
                    .b(b_out[i][j-1]),
                    .c_in(c_out[i][j-1]),
                    .c_out(c_out[i][j]),
                    .a_out(a_out[i][j]),
                    .b_out(b_out[i][j])
                );
            end else if (j == 0) begin
                pe pe_inst (
                    .clk(clk),
                    .reset(reset),
                    .a(a_out[i-1][j]),
                    .b(B[i][j]),
                    .c_in(c_out[i-1][j]),
                    .c_out(c_out[i][j]),
                    .a_out(a_out[i][j]),
                    .b_out(b_out[i][j])
                );
            end else begin
                pe pe_inst (
                    .clk(clk),
                    .reset(reset),
                    .a(a_out[i-1][j]),
                    .b(b_out[i][j-1]),
                    .c_in(c_out[i-1][j] + c_out[i][j-1]),
                    .c_out(c_out[i][j]),
                    .a_out(a_out[i][j]),
                    .b_out(b_out[i][j])
                );
            end
        end
    end
endgenerate


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 8; i = i + 1) begin
                for (int j = 0; j < 8; j = j + 1) begin
                    C[i][j] <= 16'b0;
                end
            end
        end else begin
            for (int i = 0; i < 8; i = i + 1) begin
                for (int j = 0; j < 8; j = j + 1) begin
                    C[i][j] <= c_out[i][j];
                end
            end
        end
    end
endmodule

