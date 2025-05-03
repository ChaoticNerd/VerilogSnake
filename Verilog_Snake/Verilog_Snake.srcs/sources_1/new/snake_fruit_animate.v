`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho
// 
// Create Date: 04/15/2025 03:51:27 PM
// Design Name: Animations
// Module Name: snake_fruit_animate
// Project Name: Verilog Snake
// Target Devices: Nexys A7-100T
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module snake_fruit_animate(
    input wire clk, reset, video,
    input wire [1:0] btn,
    input wire[9:0] x_val, y_val,
    output reg [2:0] graph_RGB
    );
    
    wire [2:0] fruit_rom_addr, fruit_col;
    reg [3:0] fruit_rom_data;
    wire rom_bit;
    
    // Boundaries for fruit
    wire [9:0] FRUIT_L, FRUIT_R, FRUIT_T, FRUIT_B;
    
    // Location of fruit
    reg  [9:0] FRUIT_X_REG, FRUIT_Y_REG;
    wire [9:0] FRUIT_X_NEXT, FRUIT_Y_NEXT;
    
    //---------------------------------- FRUIT ---------------------------------------
    
    always @(posedge clk, posedge reset) begin
        if(reset)begin
            // RESET SNAKE POSITION HERE
            FRUIT_X_REG <= 0;
            FRUIT_Y_REG <= 0;
        end else begin
            FRUIT_X_REG <= FRUIT_X_NEXT;
            FRUIT_Y_REG <= FRUIT_Y_NEXT;
        end
    end
        
    assign sq_fruit_on = (FRUIT_L <= x_val) && (x_val <= FRUIT_R);
    assign fruit_rom_addr = y_val[2:0] - FRUIT_T[2:0];
    assign fruit_col = x_val[2:0] - FRUIT_L[2:0];
    assign rom_bit = fruit_rom_data[fruit_col];
    assign rd_fruit_on = sq_fruit_on & rom_bit;
endmodule
