`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 01:47:17 PM
// Design Name: 
// Module Name: text_screen_gen
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


module text_screen_gen(
    input wire clk,
    input wire video_on,
    input wire [2:0] btn,
    input wire [6:0] sw,
    input wire [9:0] pixel_x, pixel_y,
    output reg [2:0] rgb_text
   );

   // signal declaration
   //Font ROM
   wire [10:0] rom_addr;
   wire [6:0] char_addr;
   wire [3:0] row_addr;
   wire [2:0] bit_addr;
   wire [7:0] font_word;
   wire font_bit;
   //Tile RAM
   wire we;
   wire [11:0]addr_r , addr_w;
   wire [6:0] din, dout;
   //map tiling 80x30
   localparam max_x = 80;
   localparam max_y = 30;
   // cursor text
   reg [6:0] cur_x_reg;
   wire [6:0] cur_x_next;
   reg [4:0] cur_y_reg;
   wire [4:0]cur_y_next;
   
   wire mov_x_tick, mov_y_tick, curso_on;
   //pxiel delay
   reg [9:0] pix_x1_reg, pix_y1_reg;
   reg [9:0] pix_x2_reg, pix_y2_reg;
   //object output
   wire [2:0] font_rgb, font_rev_rgb;

   // body
   // instantiate font ROM
   Font_ROM font_unit
      (.clk(clk), .addr(rom_addr), .data(font_word));
   // font ROM interface
   xilinx_dual_port_ram_sync
      #(.ADDR_WIDTH(12), .DATA_WIDTH(7)) video_ram
      (.clk(clk), .we(we), .addr_a(addr_w), .addr_b(addr_r),
       .din_a(din), .dout_a(), .dout_b(dout));
   always @(posedge clk)
      begin
         cur_x_reg <= cur_x_next;
         cur_y_reg <= cur_y_next;
         pix_x1_reg <= pixel_x;
         pix_x2_reg <= pix_x1_reg;
         pix_y1_reg <= pixel_y;
         pix_y2_reg <= pix_y1_reg;
      end
   
   // tile RAM write
   assign addr_w = {cur_y_reg, cur_x_reg};
   assign we = btn[2];
   assign din = sw;
   
   // tile RAM read
   // use nondelayed coordinates to form tile RAM address
   assign addr_r = {pixel_y[8:4], pixel_x[9:3]};
   assign char_addr = dout;
   
   // font ROM
   assign row_addr = pixel_y[3:0];
   assign rom_addr = {char_addr, row_addr};
   
   // use delayed coordinate to select a bit
   assign bit_addr = pix_x2_reg[2:0];
   assign font_bit = font_word[~bit_addr];
   
   // new cursor position
   assign cur_x_next =
      (mov_x_tick && (cur_x_reg==max_x-1)) ? 0 : // wrap
      (mov_x_tick) ? cur_x_reg + 1 : cur_x_reg;
   assign cur_y_next =
      (mov_y_tick && (cur_x_reg==max_y-1)) ? 0 : // wrap
      (mov_y_tick) ? cur_y_reg + 1 : cur_y_reg;
    
    //object signals
    assign font_rgb = (font_bit) ? 3'b010 : 3'b000;
    assign font_rev_rgb = (font_bit) ? 3'b000 : 3'b010;
    
    //delayed coord comparison
    assign cursor_on = (pix_y2_reg[8:4]==cur_y_reg) &&
                       (pix_x2_reg[9:3]==cur_x_reg);
                       
     //rgb multiplexing
     always @*
        if (~video_on)
            rgb_text =3'b000;
        else
            if (cursor_on)
                rgb_text = font_rev_rgb;
            else
                rgb_text = font_rgb;
endmodule