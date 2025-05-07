`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 12:42:38 PM
// Design Name: 
// Module Name: snake_animate_tb
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


module snake_animate_tb(

    );
    
//input wire clk,
//        input wire reset,
//        input wire video_on, eaten,
//        input wire [3:0] btn,
//        input wire [9:0] apple_x, apple_y,
//        input wire [9:0] pix_x,
//        input wire [9:0] pix_y,
        
//        output reg [2:0] graph_rgb

reg clk = 0;
reg reset, vid_on, eaten;
reg [3:0] btn;
reg [9:0] pix_x, pix_y;
reg [9:0] apple_x, apple_y;
wire [2:0] graph_rgb;
snake_graph_animate UUT (.clk(clk), .reset(reset), .video_on(vid_on), .eaten(eaten), .btn(btn), .apple_x(apple_x), .apple_y(apple_y), .pix_x(pix_x), .pix_y(pix_y), .graph_rgb(graph_rgb));
localparam MAX_X = 352;
localparam MIN_X = 288;

localparam MAX_Y = 272;
localparam MIN_Y = 208;
always #5 clk <= ~clk;
//reg [9:0] snake_head;
// 320 x 340 y

initial begin
    vid_on = 1;
    reset = 1;
    pix_x = 319;
    pix_y = 240;
    eaten = 0;
    clk = 0;
    btn = 4'b0010;
    apple_x = 320;
    apple_y = 239;
    #10;
    reset = 0;
    pix_x = 320;
    pix_y = 239;
    #10;
    pix_x = 320;
    pix_y = 240;
    #10;
end


always @(posedge clk) begin
    for (pix_x = MIN_X; pix_x < MAX_X; pix_x = pix_x + 1) begin
    for (pix_y = MIN_Y; pix_y < MAX_Y; pix_y = pix_y + 1) begin
    if (graph_rgb == 3'b010) begin
        $display("snake", pix_x, pix_y);
    end
    if (graph_rgb == 3'b001) begin
        $display("fruit", pix_x, pix_y);
    end
    end
    end
    //pix_x  = pix_x + 1;
    //if (pix_x > MAX_X) begin
    //    pix_x = MAX_X;
    //end
end
   
endmodule
