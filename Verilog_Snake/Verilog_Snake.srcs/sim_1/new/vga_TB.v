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
    reg clk_TB;
    wire hsync_TB, vsync_TB, inDisplayArea;
    wire [9:0] ycnt;
    wire [9:0] xcnt;
    reg clk_out;
    
     vga_sync uut(.clk(clk_TB), .h_sync(hsync_TB), 
                 .v_sync(vsync_TB), 
                 .h_counter(ycnt), .v_counter(xcnt), .clk_out(clk_out));
                 
    always #1 clk_TB <= ~clk_TB; // one cycle is 2
    
    localparam period = 5;
    
    initial begin
        clk_TB = 0;
        
        #1;
    end  
    always @(posedge clk_TB) begin
        #period;   
    end     
endmodule