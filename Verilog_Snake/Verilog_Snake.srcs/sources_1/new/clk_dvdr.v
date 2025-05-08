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
integer count = 0;
always @ (posedge(clk_in), posedge(rst))
begin
    if (rst) clk_div <= 0;
    else if(count == 3)begin 
        clk_div <= !clk_div;
        count = 0;
    end else count = count + 1;
end
endmodule