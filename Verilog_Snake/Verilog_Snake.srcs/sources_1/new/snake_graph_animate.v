`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 07:20:24 PM
// Design Name: 
// Module Name: snake_graph_animate
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


module snake_graph_animate(
    input wire clk,
    input wire reset,
    input wire video_on,
    input wire [3:0] btn,
    input wire pix_x,
    input wire pix_y,
    
    output reg [2:0] graph_rgb
    );

wire refr_tick;

reg snake_head_next, snake_head_reg;
reg [3:0] direction; // bit 0 is up, bit 1 is right, bit 2 is down, bit 3 is left

// to add:
// MAX_Y: top of board
// MIN_Y: bottom of board
// MAX_X: right of board
// MIN_X: left of board
// snake_head: location of snake head
// snake_body: location of snake body parts

// refer to ball movement bc its more similar
// at each tick, update position; else, keep position same
assign snake_head_x_next = (refr_tick) ? (snake_head_x_reg + snake_head_x_delta_reg) : (snake_head_x_reg);
assign snake_head_y_next = (refr_tick) ? (snake_head_y_reg + snake_head_y_delta_reg) : (snake_head_y_reg);

// update snake velocity
always@(*) begin
    // snake only moves at every tick
    if (refr_tick) begin
        if (!((direction[0] & btn[2]) | (direction[1] & btn[3]) | (direction[2] & btn[0]) | (direction[3] & btn[1]))) begin
            // checks if button press in opposite direction so that it cannot turn backwards
            if (btn[0] & (snake_head < (MAX_Y - 1 - SNAKE_V))) begin
                end
            else begin
                snake_head_next_x = snake_head_reg_x + snake_head_v_x;
                end
            end
        end
    end


endmodule
