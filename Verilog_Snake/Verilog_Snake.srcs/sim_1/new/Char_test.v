`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 10:59:49 PM
// Design Name: 
// Module Name: Char_test
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


module Char_test();
    reg clk_tb, reset_tb;
    wire hsync, vsync;
    //wire [9:0] pixel_x, pixel_y;
    wire [2:0] rgb_tb;
    //wire [6:0] sw;
    reg [3:0] btn;
    integer i;
    
    /*
    Font_test_top font_tb(.clk(clk_tb), .reset(reset_tb),.hsync(hsync),.vsync(vsync),
        .vid(video_on),.pixlx(pixel_x), .pixly(pixel_y), .rgb(rgb_tb));
    always #1 clk_tb <= ~clk_tb;
    
    localparam period = 5;
    
    initial begin
        clk_tb = 0;
        reset_tb=1;
        #1;
        reset_tb=0;
    end
      always @(posedge clk_tb) begin
        #period;
    end
    */
    text_top uut(.clk(clk_tb), .reset(reset_tb), .btn(btn), .sw(sw), .hsync(hsync), .vsync(vsync), .rgb(rgb_tb));
    always #1 clk_tb <= ~clk_tb;
    
    localparam period = 5;
    
    initial begin
    i=4'b0000;
        clk_tb = 0;
        reset_tb=1;
        #1;
        reset_tb=0;
    end
      always @(posedge clk_tb)
      begin
        #period;
        btn = i;
        i = i+ 4'b0001;
      end

     
    
    
    
endmodule
