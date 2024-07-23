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
    output logic signed [7:0] out_vector [63:0]
);
    reg signed [7:0] matrix [63:0][63:0];
    reg [15:0] sum;
    always_ff @(posedge clk)
    begin
        if (!rstn)
            out_vector <= '{default: '0};
        else
            begin
                for (int i = 0; i < 64; i = i + 1) begin
                    sum = 16'b0;
                    for (int j = 0; j < 64; j = j + 1)
                        sum += in_vector[j] * matrix[i][j];
                end
                if (sum > 8'sd127)
                    out_vector[i] <= 8'sd127;
                else if (sum < -8'sd128)
                    out_vector[i] <= -8'sd128;
                else
                    out_vector[i] <= sum[7:0];
            end
    end
endmodule
