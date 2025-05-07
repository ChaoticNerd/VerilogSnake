`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho
// 
// Create Date: 05/05/2025 03:56:10 PM
// Design Name: Snake Top Module
// Module Name: snake_top
// Project Name: Verilog Snake
// Target Devices: NexysA7-100T
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module snake_top(
    input  clk, reset,
    input [0:3] btn,
    output  hsync, vsync,
    output [0:11] vga
    );
    
    wire video_on, eaten;
    wire [9:0] pix_x, pix_y;
    wire [9:0] apple_x, apple_y;
    
    wire [2:0] graph_rgb;
    
    apple_spawn(.eaten(eaten), .x_pix(apple_x), .y_pix(apple_y));
    // another variable to connect apple_x and apple_y to snake_graph_animate
    snake_graph_animate snake_graph (.clk(clk), .reset(reset), .video_on(video_on), .eaten(eaten), 
                                    .btn(btn), .apple_x(apple_x), .apple_y(apple_y) ,.pix_x(pix_x), .pix_y(pix_y), .graph_rgb(graph_rgb));
                                    
    //snake_screen screen (.display(video_on), .x_val(pix_x), .y_val(pix_y), .screen_RGB(graph_rgb));       

    text_top text(.clk(clk), .reset(reset), .btn(btn), .sw(), .hsync(hsync), .vsync(vsync), .rgb(graph_rgb));
                     
endmodule
