`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho
// 
// Create Date: 04/15/2025 11:35:00 AM
// Design Name: Apple
// Module Name: apple_spawn_TB
// Project Name: Verilog Snake
// Target Devices: Nexys A7-100T
// Description: 
//              Testing funciton of Apple spawning to make sure it's within frame
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module apple_spawn_TB(
    );
    reg eaten_TB;
    wire [9:0] x_pix_TB, y_pix_TB;
    
    apple_spawn uut(.eaten(eaten_TB), .x_pix(x_pix_TB), .y_pix(y_pix_TB));
    //apple_spawn uut(.clk(clk), .x_pix(x_pix_TB), .y_pix(y_pix_TB));  
    
    localparam period = 50;
    
    
    integer i;
    initial begin
        eaten_TB = 1;
        for(i = 0; i < 20; i = i + 1) begin
            $display("random x_tb %d", $urandom_range(639, 1));
            $display("random y_tb %d", $urandom_range(479, 2));
            $display("random x %d", x_pix_TB);
            $display("random Y %d", y_pix_TB);
            #period; 
            eaten_TB = ~eaten_TB;
        end
        $finish;
    end
endmodule
