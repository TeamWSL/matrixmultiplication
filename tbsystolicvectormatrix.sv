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


module tb_systolicmatrixvector;

    // Parameters
    localparam WIDTH = 8;
    localparam SIZE = 64;

    // Signals
    logic clk;
    logic rstn;
    logic signed [WIDTH-1:0] in_vector [SIZE-1:0];
    logic signed [WIDTH-1:0] out_vector [SIZE-1:0];

    // Instantiate the DUT (Device Under Test)
    systolicmatrixvector dut (
        .clk(clk),
        .rstn(rstn),
        .in_vector(in_vector),
        .out_vector(out_vector)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Initial block for test stimulus
    initial begin
        // Initialize inputs
        rstn = 0;
        for (int i = 0; i < SIZE; i = i + 1) begin
            in_vector[i] = $urandom % 256 - 128; // Random number between -128 and 127
        end

        // Apply reset
        #20;
        rstn = 1;

        // Wait for some clock cycles to let the design process the input
        #100;

        // Monitor output
        $display("Output Vector:");
        for (int i = 0; i < SIZE; i = i + 1) begin
            $display("out_vector[%0d] = %0d", i, out_vector[i]);
        end

        // Finish simulation
        #20;
        rstn = 0;
        #20
        $stop;
    end

endmodule
