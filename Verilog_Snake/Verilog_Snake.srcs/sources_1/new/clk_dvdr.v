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

always @ (posedge(clk_in), posedge(rst))
begin
    if (rst) clk_div <= 0;
    else clk_div <= !clk_div;
end
endmodule