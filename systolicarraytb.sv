`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 09:03:53 AM
// Design Name: 
// Module Name: systolicarraytb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Test bench for the matrix multiplication
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_systolic_array_4x4;
    reg clk;
    reg rst;
    reg signed [7:0] A [0:3][0:3];
    reg signed [7:0] B [0:3][0:3];
    wire signed [15:0] C [0:3][0:3];

    matmul4x4 uut (
        .a(A),
        .b(B),
        .ans(C),
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        // Initialize matrix A
        A[0][0] = 8'd1; A[0][1] = 8'd0; A[0][2] = 8'd0; A[0][3] = 8'd0;
        A[1][0] = 8'd0; A[1][1] = 8'd1; A[1][2] = 8'd0; A[1][3] = 8'd0;
        A[2][0] = 8'd0; A[2][1] = 8'd0; A[2][2] = 8'd1; A[2][3] = 8'd0;
        A[3][0] = 8'd0; A[3][1] = 8'd0; A[3][2] = 8'd0; A[3][3] = 8'd1;

        // Initialize matrix B
        B[0][0] = 8'd1; B[0][1] = 8'd2; B[0][2] = 8'd3; B[0][3] = 8'd4;
        B[1][0] = 8'd9; B[1][1] = 8'd10; B[1][2] = 8'd11; B[1][3] = 8'd12;
        B[2][0] = 8'd17; B[2][1] = 8'd14; B[2][2] = 8'd19; B[2][3] = 8'd20;
        B[3][0] = 8'd25; B[3][1] = 8'd26; B[3][2] = 8'd27; B[3][3] = 8'd24;
        # 1000
        rst = 1'b0;
        // Display the result matrix C
        $display("Matrix C:");
        for (integer i = 0; i < 4; i = i + 1) begin
            $display("%d %d %d %d",
                C[i][0], C[i][1], C[i][2], C[i][3]);
        end

        // Finish the simulation
    end

    // Clock generation
    initial begin
        forever #10 clk = ~clk;
    end

endmodule




