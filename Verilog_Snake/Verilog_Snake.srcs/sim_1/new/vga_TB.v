`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho
// 
// Create Date: 04/15/2025 02:51:33 PM
// Design Name: VGA
// Module Name: vga_TB
// Project Name: Verilog Snake
// Target Devices: Nexys A7-100T
// Description: 
//              Testing VGA Sync
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_TB();
    reg clk_TB, reset_TB;
    wire hsync_TB, vsync_TB, vid, p_tick;
    wire [9:0] ycnt;
    wire [9:0] xcnt;
    
    vga_sync uut(.clk(clk_TB), .reset(reset_TB), .hsync(hsync_TB), 
                 .vsync(vsync_TB), .video(vid), .p_tick(p_tick), 
                 .pixel_y(ycnt), .pixel_x(xcnt));
    
    always #3 clk_TB <= ~clk_TB; // one cycle is 20
    
    localparam period = 25;
    
    initial begin
        clk_TB = 0;
        reset_TB = 1;
        #1;
        reset_TB = 0;
        while(vsync_TB == 0)begin
           #period; 
        end

    end
endmodule