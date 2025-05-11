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
    input clk, reset,
    input [0:3] btn,
    output hsync, vsync,
    output [0:3] red, green, blue
    );
    wire video_on, eaten, clk_div;
    wire [9:0] pix_x, pix_y;
    wire [3:0] text_on;
    wire [3:0] r, g, b;
    
    clk_dvdr clkdiv(.clk_in(clk), .rst(reset), .clk_div(clk_div));
    
    //apple_spawn e(.eaten(eaten), .x_pix(apple_x), .y_pix(apple_y));
    // another variable to connect apple_x and apple_y to snake_graph_animate
    vga_sync vga(.clk(clk_div), .reset(reset), .h_sync(hsync), .v_sync(vsync), .inDisplayArea(video_on), 
                .h_counter(pix_x), .v_counter(pix_y));
    
    snake_graph_animate snake_graph (.clk(clk_div), .reset(reset), .eaten(eaten), .video_on(video_on),
                                    .btn(btn) , .pix_x(pix_x), .pix_y(pix_y), 
                                    .red(red), .blue(blue), .green(green));
                                    
    //snake_screen screen (.display(video_on), .x_val(pix_x), .y_val(pix_y), .screen_RGB(graph_rgb));       
    
    //snake_text text(.clk(clk), .pix_x(pix_X), .pix_y(pix_y),.text_on(text_on), .text_rgb());
    
    
    // Connect game output to VGA output
    assign red      = video_on ? r : 4'b0000;
    assign green    = video_on ? g : 4'b0000;
    assign blue     = video_on ? b : 4'b0000;
endmodule
