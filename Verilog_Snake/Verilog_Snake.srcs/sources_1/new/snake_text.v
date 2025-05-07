`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2025 12:15:25 PM
// Design Name: 
// Module Name: snake_text
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


module snake_text(
    input wire clk,
    input wire [3:0] dig0, dig1, dig2, hidig0, hidig1, hidig2,
    input wire [9:0] pix_x, pix_y,
    output wire [3:0] text_on,
    output reg [2:0] text_rgb
    );
    
   wire [10:0] rom_addr; // this is the address that will be sent to font rom,
   reg [6:0] char_addr, char_addr_s, char_addr_l, char_addr_r, char_addr_o, char_addr_hsr, char_addr_sr; 
   reg [3:0] row_addr;
   wire [3:0] row_addr_s, row_addr_l, row_addr_r, row_addr_o, row_addr_hsr, row_addr_sr;
   reg [2:0] bit_addr;
   wire [2:0] bit_addr_s, bit_addr_l,bit_addr_r, bit_addr_o, bit_addr_hsr, bit_addr_sr;
   wire [7:0] font_word;
   wire font_bit, score_on, logo_on, rule_on, over_on, hiscoreres_on, scoreres_on ;
   wire [7:0] rule_rom_addr, score_rom_addr;
    
   Font_ROM font_unit(.clk(clk), .addr(rom_addr), .data(font_word));
   
   //score regions (top left corner)
   //scale 16 by 32
   //displays: "Score:###"
   assign score_on = (pix_y[9:5]==0) && (pix_x[9:4]<16);
   assign row_addr_s = pix_y[4:1];
   assign bit_addr_s = pix_x[3:1];
   assign score_rom_addr = {pix_y[5:4], pix_x[6:3]};
   always @*
        case(score_rom_addr)
            //row 1
            6'h00: char_addr_s = 7'h53;// S
            6'h01: char_addr_s = 7'h63;// c
            6'h02: char_addr_s = 7'h6f;// o
            6'h03: char_addr_s = 7'h72;// r
            6'h04: char_addr_s = 7'h65;// e
            6'h05: char_addr_s = 7'h3a;// :
            6'h06: char_addr_s = {3'b011, dig2};
            6'h07: char_addr_s = {3'b011, dig1};
            6'h08: char_addr_s = {3'b011, dig0};
            6'h09: char_addr_s = 7'h00;//
            6'h0a: char_addr_s = 7'h00;//
            6'h0b: char_addr_s = 7'h00;//
            6'h0c: char_addr_s = 7'h00;//
            6'h0d: char_addr_s = 7'h00;//
            6'h0e: char_addr_s = 7'h00;//
            6'h0f: char_addr_s = 7'h00;// 
            // row 2
            6'h10: char_addr_s = 7'h48;// H
            6'h11: char_addr_s = 7'h69;// i
            6'h12: char_addr_s = 7'h2d;// - 
            6'h13: char_addr_s = 7'h53;// S
            6'h14: char_addr_s = 7'h63;// c
            6'h15: char_addr_s = 7'h6f;// o
            6'h16: char_addr_s = 7'h65;// r
            6'h17: char_addr_s = 7'h3a;// e
            6'h18: char_addr_s = 7'h00;// :
            6'h19: char_addr_s = {3'b011, hidig2};
            6'h1a: char_addr_s = {3'b011, hidig1};
            6'h1b: char_addr_s = {3'b011, hidig0};
            6'h1c: char_addr_s = 7'h00;//
            6'h1d: char_addr_s = 7'h00;//
            6'h1e: char_addr_s = 7'h00;// 
            6'h1f: char_addr_s = 7'h00;// 
         endcase
            
   //logo region (above game box)
   //scale 64-by-128
   //display:  Snake
   assign logo_on = (pix_y[9:7]==2) && (3<=pix_x[9:6]) && (pix_x[9:6]<=6);
   assign row_addr_1 = pix_y[6:3];
   assign bit_addr_1 = pix_x[5:3];
   always @*
        case(pix_x[8:6])
            3'o2: char_addr_l = 7'h53;// S
            3'o3: char_addr_l = 7'h4e;// N 
            3'o4: char_addr_l = 7'h41;// A
            3'o5: char_addr_l = 7'h53;// K
            3'o6: char_addr_l = 7'h53;// E
        endcase
   
   //rules region (idk)
   //display press any button to start
   
   
   
   //game over (replace logo)
   //scale 64-by-128
   //display: Game Over
   //
   assign over_on = (pix_y[9:7]==2) && (3<=pix_x[9:6]) && (pix_x[9:6]<=6);
   assign row_addr_1 = pix_y[6:3];
   assign bit_addr_1 = pix_x[5:3];
   always @*
        case(pix_x[8:6])
            3'o0: char_addr_o = 7'h47;// G
            3'o1: char_addr_o = 7'h41;// A
            3'o2: char_addr_o = 7'h4d;// M
            3'o3: char_addr_o = 7'h45;// E
            3'o4: char_addr_o = 7'h4f;// O
            3'o5: char_addr_o = 7'h56;// V
            3'o6: char_addr_o = 7'h45;// E
            3'o7: char_addr_o = 7'h52;// R
        endcase    
   
   
   //Score Result region (undergame box)
   //scale
   //display: Score:###
   //        
   assign scoreres_on = (pix_y[9:5]==0) && (pix_x[9:4]<16);
   assign row_addr_s = pix_y[4:1];
   assign bit_addr_s = pix_x[3:1];
   assign score_rom_addr = {pix_y[5:4], pix_x[6:3]};
   always @*
        case(score_rom_addr)
            //row 1
            6'h00: char_addr_s = 7'h53;// S
            6'h01: char_addr_s = 7'h63;// c
            6'h02: char_addr_s = 7'h6f;// o
            6'h03: char_addr_s = 7'h72;// r
            6'h04: char_addr_s = 7'h65;// e
            6'h05: char_addr_s = 7'h3a;// :
            6'h06: char_addr_s = {3'b011, dig2};
            6'h07: char_addr_s = {3'b011, dig1};
            6'h08: char_addr_s = {3'b011, dig0};
            6'h09: char_addr_s = 7'h00;//
            6'h0a: char_addr_s = 7'h00;//
            6'h0b: char_addr_s = 7'h00;//
            6'h0c: char_addr_s = 7'h00;//
            6'h0d: char_addr_s = 7'h00;//
            6'h0e: char_addr_s = 7'h00;//
            6'h0f: char_addr_s = 7'h00;// 
        endcase
   //Hi-Score Result region (undergame box)
   //scale
   //display: Score:###
   //        
   assign hiscoreres_on = (pix_y[9:5]==0) && (pix_x[9:4]<16);
   assign row_addr_s = pix_y[4:1];
   assign bit_addr_s = pix_x[3:1];
   assign score_rom_addr = {pix_y[5:4], pix_x[6:3]};
   always @* begin
        case(score_rom_addr)
            //row 1
            6'h00: char_addr_s = 7'h48;// H
            6'h01: char_addr_s = 7'h69;// i
            6'h02: char_addr_s = 7'h2d;// - 
            6'h03: char_addr_s = 7'h53;// S
            6'h04: char_addr_s = 7'h63;// c
            6'h05: char_addr_s = 7'h6f;// o
            6'h06: char_addr_s = 7'h65;// r
            6'h07: char_addr_s = 7'h3a;// e
            6'h08: char_addr_s = 7'h00;// :
            6'h09: char_addr_s = {3'b011, hidig2};
            6'h0a: char_addr_s = {3'b011, hidig1};
            6'h0b: char_addr_s = {3'b011, hidig0};
            6'h0c: char_addr_s = 7'h00;//
            6'h0d: char_addr_s = 7'h00;//
            6'h0e: char_addr_s = 7'h00;// 
            6'h0f: char_addr_s = 7'h00;//  
        endcase
   end
   // 
   // MUX for font rom adr and rgb
   //
   always @* begin
        text_rgb = 3'b000;
        if (score_on)
            begin
                char_addr = char_addr_s;
                row_addr = row_addr_s;
                bit_addr = bit_addr_s;
                if (font_bit)
                    text_rgb = 3'b001;
            end
        else if (logo_on)
            begin
                char_addr = char_addr_s;
                row_addr = row_addr_s;
                bit_addr = bit_addr_s;
                if (font_bit)
                    text_rgb = 3'b001;
            end
        else if (over_on)
            begin
                char_addr = char_addr_s;
                row_addr = row_addr_s;
                bit_addr = bit_addr_s;
                if (font_bit)
                    text_rgb = 3'b001;
            end
        else if (scoreres_on)
            begin
                char_addr = char_addr_sr;
                row_addr = row_addr_sr;
                bit_addr = bit_addr_sr;
                if (font_bit)
                    text_rgb = 3'b001;
            end
        else if (hiscoreres_on)
            begin
                char_addr = char_addr_hsr;
                row_addr = row_addr_hsr;
                bit_addr = bit_addr_hsr;
                if (font_bit)
                    text_rgb = 3'b001;
            end
        end

assign text_on = {score_on, logo_on, over_on, scoreres_on, hiscoreres_on};
//rom interface
assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr];
endmodule