`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho
// 
// Create Date: 05/07/2025 07:44:51 PM
// Design Name: Clock divider
// Module Name: clk_dvdr
// Project Name: Verilog Snake
// Target Devices: NexysA7-100T
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_dvdr(
    input clk_in, rst,
    output reg clk_div
    );
    
	reg pulse;
	
	initial begin // Set all of them initially to 0
		clk_div = 0;
		pulse = 0;
	end
	
	always @(posedge clk_in)
		pulse = ~pulse;
	always @(posedge pulse)
		clk_div = ~clk_div;
endmodule