`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 07:33:16 PM
// Design Name: 
// Module Name: pematmul
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


module pematmul(
    input clk,
    input rst,
    input [7:0] a1,
    input [7:0] b1,
    input [7:0] a2,
    input [7:0] b2,
    input [7:0] a3,
    input [7:0] b3,
    input [7:0] a4,
    input [7:0] b4,
    output [15:0] c
);

    wire [15:0] prod1;
    wire [15:0] prod2;
    wire [15:0] prod3;
    wire [15:0] prod4;
    
    // Instance 1: a1 * b1
    ADDMACC_MACRO #(
        .DEVICE("7SERIES"),
        .LATENCY(4),
        .WIDTH_PREADD(8),
        .WIDTH_MULTIPLIER(8),
        .WIDTH_PRODUCT(16)
    ) ADDMACC_MACRO_inst1 (
        .PRODUCT(prod1),
        .CARRYIN(1'b0),
        .CLK(clk),
        .CE(1'b1),
        .LOAD(1'b1),
        .LOAD_DATA(16'd0),
        .MULTIPLIER(a1),
        .PREADD2(8'd0),
        .PREADD1(b1),
        .RST(RST)
    );

    // Instance 2: a2 * b2
    ADDMACC_MACRO #(
        .DEVICE("7SERIES"),
        .LATENCY(4),
        .WIDTH_PREADD(8),
        .WIDTH_MULTIPLIER(8),
        .WIDTH_PRODUCT(16)
    ) ADDMACC_MACRO_inst2 (
        .PRODUCT(prod2),
        .CARRYIN(1'b0),
        .CLK(clk),
        .CE(1'b1),
        .LOAD(1'b1),
        .LOAD_DATA(16'd0),
        .MULTIPLIER(a2),
        .PREADD2(8'd0),
        .PREADD1(b2),
        .RST(RST)
    );

    // Instance 3: a3 * b3
    ADDMACC_MACRO #(
        .DEVICE("7SERIES"),
        .LATENCY(4),
        .WIDTH_PREADD(8),
        .WIDTH_MULTIPLIER(8),
        .WIDTH_PRODUCT(16)
    ) ADDMACC_MACRO_inst3 (
        .PRODUCT(prod3),
        .CARRYIN(1'b0),
        .CLK(clk),
        .CE(1'b1),
        .LOAD(1'b1),
        .LOAD_DATA(16'd0),
        .MULTIPLIER(a3),
        .PREADD2(8'd0),
        .PREADD1(b3),
        .RST(RST)
    );

    // Instance 4: a4 * b4
    ADDMACC_MACRO #(
        .DEVICE("7SERIES"),
        .LATENCY(4),
        .WIDTH_PREADD(8),
        .WIDTH_MULTIPLIER(8),
        .WIDTH_PRODUCT(16)
    ) ADDMACC_MACRO_inst4 (
        .PRODUCT(prod4),
        .CARRYIN(1'b0),
        .CLK(clk),
        .CE(1'b1),
        .LOAD(1'b1),
        .LOAD_DATA(16'd0),
        .MULTIPLIER(a4),
        .PREADD2(8'd0),
        .PREADD1(b4),
        .RST(RST)
    );

     //Sum up the products
    assign c = prod1 + prod2 + prod3 + prod4;
//    assign c = a1*b1 + a2*b2 + a3*b3 + a4*b4;

endmodule

