`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho
// 
// Create Date: 04/14/2025 06:24:37 PM
// Design Name: Apple
// Module Name: apple_spawn
// Project Name: Verilog Snake
// Target Devices: Nexys A7-100T
// Revision 0.01 - File Created
// Additional Comments:
// This file generates where the apple will spawn
//////////////////////////////////////////////////////////////////////////////////


module apple_spawn(
    input eaten,
    output reg [9:0] x_pix, y_pix
    );
    // Border of the screen
    localparam MAX_X = 352;
    localparam MIN_X = 288;
    
    localparam MAX_Y = 272;
    localparam MIN_Y = 208;
    
    always @(posedge eaten) begin
        // $urandom for unsigned random values
        x_pix = $urandom_range(MAX_X, MIN_X);
        y_pix = $urandom_range(MAX_Y, MIN_Y);
    end
endmodule
