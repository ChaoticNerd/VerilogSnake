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

module Font_test_gen
   (
    input wire clk,
    input wire video_on,
    input wire [9:0] pixel_x, pixel_y,
    output reg [2:0] rgb_text
   );

   // signal declaration
   wire [10:0] rom_addr;
   reg [6:0] char_addr_s;
   reg [6:0] char_addr;
   reg [3:0] row_addr;
   reg [2:0] bit_addr;
   wire [3:0] row_addr_s;
   wire [2:0] bit_addr_s;
   wire [7:0] font_word;
   wire font_bit,score_on;
   // body
   // instantiate font ROM
   Font_ROM font_unit(.clk(clk), .addr(rom_addr), .data(font_word));
   // font ROM interface
 
   //assign row_addr = pixel_y[3:0];
   //assign rom_addr = {char_addr, row_addr};
   //assign bit_addr = pixel_x[2:0];
   //assign font_bit = font_word[~bit_addr];

   assign score_on = (pixel_y[9:5]==0) && (pixel_x[9:4]<16);
   assign row_addr_s = pixel_y[4:1];
   assign bit_addr_s = pixel_x[3:1];
   always @*
      case (pixel_x[7:4])
         4'h0: char_addr_s = 7'h53; // S
         4'h1: char_addr_s = 7'h63; // c
         4'h2: char_addr_s = 7'h6f; // o
         4'h3: char_addr_s = 7'h72; // r
         4'h4: char_addr_s = 7'h65; // e
      endcase
   // rgb multiplexing circuit
   always @*
      if (score_on) begin
           char_addr = char_addr_s;
           row_addr = row_addr_s;
           bit_addr = bit_addr_s;
           if(font_bit)
               rgb_text = 3'b111;  // green
         end
         else
            rgb_text = 3'b000;  // black
     assign rom_addr = {char_addr, row_addr};
     assign font_bit = font_word[~bit_addr];
endmodule 