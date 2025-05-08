`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2025 09:08:03 PM
// Design Name: 
// Module Name: clk_div_tb
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


module clk_div_tb();
    reg clk;
    reg reset;
    wire clk_out;
    clk_dvdr clk_div(.clk_in(clk), .rst(reset), .clk_div(clk_out));
    
    initial begin
        reset = 1;
        clk = 0;
        #10;
        reset = 0;
    end
    always #1 clk <= ~clk; // one cycle is 2
endmodule
