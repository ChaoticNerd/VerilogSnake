`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 03:39:50 PM
// Design Name: 
// Module Name: Font_test_top
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


module Font_test_top(
    input wire clk, reset,
    output wire hsync, vsync, vid,
    output wire [2:0] rgb,
    output wire [9:0] pixlx, pixly
   );

   // signal declaration
   wire [9:0] pixel_x, pixel_y;
   wire video_on, pixel_tick;
   reg [2:0] rgb_reg;
   wire [2:0] rgb_next;

   // body
   // instantiate vga sync circuit
   vga_sync vsync_unit(.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
       .video(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
   // font generation circuit
   Font_test_gen font_gen_unit(.clk(clk), .video_on(video_on), .pixel_x(pixel_x),
       .pixel_y(pixel_y), .rgb_text(rgb_next));
   // rgb buffer
   always @(posedge clk)
      if (pixel_tick)
         rgb_reg <= rgb_next;
   // output
   assign rgb = rgb_reg;
   assign vid = video_on;
   assign pixlx = pixel_x;
   assign pixly = pixel_y;
endmodule
