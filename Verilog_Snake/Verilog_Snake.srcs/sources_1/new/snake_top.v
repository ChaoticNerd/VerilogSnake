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
    wire video_on, eaten;
    wire [9:0] pix_x, pix_y;
    wire [3:0] text_on;
    wire [12:0] rgb;
    clk_dvdr clkdiv(.clk_in(clk), .rst(reset), .clk_div(clk_div));
    
    // another variable to connect apple_x and apple_y to snake_graph_animate
    vga_sync vga(.clk(clk), .hSync(hsync), .vSync(vsync), .bright(video_on), 
                .hCount(pix_x), .vCount(pix_y));
//    initial begin 
//        for(i = 0; i < 10000; i = i + 1) begin
//            if(i%2)begin
//                r = 4'b0000;
//                g = 4'b0000;
//                b = 4'b1111;
//            end else begin
//                r = 4'b1111;
//                g = 4'b0000;
//                b = 4'b0000;
//            end
//        end
//    end
    snake_graph_animate snake_graph (.clk(clk_div), .reset(reset), .eaten(eaten), .video_on(video_on),
                                    .btn(btn) , .pix_x(pix_x), .pix_y(pix_y), 
                                    .rgb(rgb));
                                 
    //snake_screen screen (.display(video_on), .x_val(pix_x), .y_val(pix_y), .screen_RGB(graph_rgb));       

    //assign {red,green,blue} = video_on ? rgb[3:0] : 0;
    //snake_text text(.clk(clk_div), .pix_x(pix_X), .pix_y(pix_y),.text_on(text_on), .text_rgb());
    // Connect game output to VGA output
    assign red      = video_on? rgb[3:0]: 0;
    assign green    = video_on? rgb[7:4]: 0;
    assign blue     = video_on? rgb[11:8]: 0;
endmodule
