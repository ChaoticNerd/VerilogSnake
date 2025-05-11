`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2025 09:30:15 PM
// Design Name: 
// Module Name: vga_top
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

module vga_top(
    input clk, reset,
    output hsync, vsync,
    output [0:11] rgb_vga
    );
    wire display;
    wire [9:0] x,y;
    clk_dvdr clkdiv(.clk_in(clk), .rst(reset), .clk_div(clk_div));
    
    vga_sync vga(.clk(clk_div), .reset(reset), .h_sync(hsync), .v_sync(vsync), .display(display), 
                .x(pix_x), .y(pix_y));
                
    assign rgb_vga = display ? 10'b1111111111 : 4'b0000;
endmodule
