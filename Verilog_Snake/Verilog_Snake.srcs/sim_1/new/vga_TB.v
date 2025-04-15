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

module vga_TB(
    input wire clk, reset,
    input wire [2:0] sw,
    output wire hsync, vsync,
    output wire [2:0] rgb
    );
    
    reg [2:0] rgb_reg;
    wire video;
    
    vga_sync uut(.clk(clk), .reset(reset), .hori_sync(hsync), .vert_sync(vsync), 
                 .vid_on(video), .p_tick(), .pixel_x(), .pixel_y());
                 
    always @(posedge clk, posedge reset)begin
        if(reset)
            rgb_reg <= 0;
        else
            rgb_reg <= sw;
    end
    assign rgb = (video)? rgb_reg : 3'b0;
endmodule
