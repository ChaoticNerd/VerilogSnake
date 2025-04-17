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

localparam MIN_X = 0;
localparam MAX_X = 640;
localparam MIN_Y = 0;
localparam MAX_Y = 480 - 16;

wire refr_tick;

reg snake_head_x, snake_head_y; // current snake head position
wire snake_head_x_next, snake_head_y_next; // next snake head positions
reg [9:0] snake_head_x_reg, snake_head_y_reg; // track snake position
reg [3:0] direction = 3'b0010; // bit 0 is up, bit 1 is right, bit 2 is down, bit 3 is left

reg snake_head_x_delta_next, snake_head_y_delta_next; // next snake head velocity
wire snake_head_x_delta_reg, snake_head_y_delta_reg; // current snake head velocity
// snake velocities, move up, down, or neither
integer SNAKE_PV = 1;
integer SNAKE_0V = 0;
integer SNAKE_NV = -1;

integer game_end = 0;

// to add:
// snake_body: location of snake body parts

// refer to ball movement bc its more similar
// at each tick, update position; else, keep position same
assign snake_head_x_next = (refr_tick) ? (snake_head_x_reg + snake_head_x_delta_reg) : (snake_head_x_reg);
assign snake_head_y_next = (refr_tick) ? (snake_head_y_reg + snake_head_y_delta_reg) : (snake_head_y_reg);

// update snake velocity
always@(*) begin
    // snake only moves at every tick
    snake_head_x_delta_next = snake_head_x_delta_reg;
    snake_head_y_delta_next = snake_head_y_delta_reg;
    case({btn[3], btn[2], btn[1], btn[0]})
        3'b0001 : direction = 3'b0001;
        3'b0010 : direction = 3'b0010;
        3'b0100 : direction = 3'b0100;
        3'b1000 : direction = 3'b1000;
        default : direction = direction;
        endcase
    if ((snake_head_x < (MIN_X + 2)) || (snake_head_x > (MAX_X - 2)) || (snake_head_y < (MIN_Y + 2)) || (snake_head_y > (MAX_Y - 2))) begin
        // check if snake head is inside wall
        // game over function idk
        game_end = 1;
        end
    else if (btn[0]) begin // turn
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_PV;
        end
    else if (btn[1]) begin
        snake_head_x_delta_next = SNAKE_PV;
        snake_head_y_delta_next = SNAKE_0V;
        end
    else if (btn[2]) begin
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_NV;
        end
    else if (btn[3]) begin
        snake_head_x_delta_next = SNAKE_NV;
        snake_head_y_delta_next = SNAKE_0V;
        end
    end

// check if direction change is opposite
// if (!((direction[0] & btn[2]) | (direction[1] & btn[3]) | (direction[2] & btn[0]) | (direction[3] & btn[1])))

endmodule
