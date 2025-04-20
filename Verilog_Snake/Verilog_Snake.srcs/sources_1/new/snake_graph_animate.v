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
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    
    output reg [2:0] graph_rgb
    );

localparam MIN_X = 0;
localparam MAX_X = 640;
localparam MIN_Y = 0;
localparam MAX_Y = 480 - 16;

wire refr_tick;

wire [9:0] snake_head_x, snake_head_y, snake_end_x, snake_end_y; // current snake head position
wire [9:0] snake_head_x_next, snake_head_y_next; // next snake head positions
reg [9:0] snake_head_x_reg, snake_head_y_reg; // track snake position
reg [3:0] direction = 4'b0010; // bit 0 is up, bit 1 is right, bit 2 is down, bit 3 is left

integer SNAKE_PV = 1;
integer SNAKE_0V = 0;
integer SNAKE_NV = -1;
reg snake_head_x_delta_next, snake_head_y_delta_next; // next snake head velocity
wire snake_head_x_delta_reg = SNAKE_PV, snake_head_y_delta_reg = SNAKE_0V; // current snake head velocity
// initialize to move right
// snake velocities, move up, down, or neither

integer game_end = 0;

// to add:
// snake_body: location of snake body parts

// snake location in board
assign snake_head_x = snake_head_x_reg; // *snake is currently 1 pixel
assign snake_head_y = snake_head_y_reg;

integer turns = 0;
// supports up to 32 turns idk
reg [31:0] parts; // parts = body part, returns 1 whenever a part exists
wire [319:0] turn_x;
wire [319:0] turn_y;
reg snake_on;
// i think the best way to do this is to put a location for every turn
// update turn x and turn y so body 1 and body 2 can use it or smthn
// max # of turns: ??? 16 maybe
// but that means 32 stored turn cases..... 
// no wait/
// an array of 9 bits each. so 9 * 144 bit thing with 9 bit shifts * turn number
// I THINK IVE COOKED??

// fill in 
// check num of turns
always@(*) begin
if (turns == 0) begin
    // check direction
    // wait i have cases
    case(direction)
        4'b0001 : snake_on = ((snake_end_y <= pix_y) && (pix_y <= snake_head_y)); // up
        4'b0010 : snake_on = ((snake_end_x <= pix_x) && (pix_x <= snake_head_x)); // right
        4'b0100 : snake_on = ((snake_head_y <= pix_y) && (pix_y <= snake_end_y)); // down
        4'b1000 : snake_on = ((snake_head_x <= pix_x) && (pix_x <= snake_end_x)); // left
        default : snake_on = snake_on;
    endcase
    assign snake_on = (snake_head_x <= snake_end_x) && (snake_head_y <= snake_end_y);
end
else begin
    // num turns = num shifts
    // foor loop n if statement?
    if (direction[0]) begin
        // use a for loop to return a 1 for pixels between each body part
        snake_on = ((snake_end_y <= pix_y) && (pix_y <= turn_y[9:0]));
    end
    else if (direction[1]) begin
        // fill similarly to direction 0
    end
    else if (direction[2]) begin
        // fill similarly to direction 0
    end
    else if (direction[3]) begin
        // fill similarly to direction 0
    end
    // maybe delete turns by checking if they are nonzero and total distance from head is greater than snake length?
end
end

// refer to ball movement bc its more similar
// at each tick, update position; else, keep position same
assign snake_head_x_next = (refr_tick) ? (snake_head_x_reg + snake_head_x_delta_reg) : (snake_head_x_reg);
assign snake_head_y_next = (refr_tick) ? (snake_head_y_reg + snake_head_y_delta_reg) : (snake_head_y_reg);

//note to self: add snake end

// update snake velocity
always@(*) begin
    // snake only moves at every tick
    snake_head_x_delta_next = snake_head_x_delta_reg;
    snake_head_y_delta_next = snake_head_y_delta_reg;
    case({btn[3], btn[2], btn[1], btn[0]})
        4'b0001 : direction = 4'b0001;
        4'b0010 : direction = 4'b0010;
        4'b0100 : direction = 4'b0100;
        4'b1000 : direction = 4'b1000;
        default : direction = direction;
        endcase
    if ((snake_head_x < (MIN_X + 2)) || (snake_head_x > (MAX_X - 2)) || (snake_head_y < (MIN_Y + 2)) || (snake_head_y > (MAX_Y - 2))) begin
        // check if snake head is inside wall
        // game over function idk
        // also check if snake is touching snake (not implemented yet)
        game_end = 1;
        end
    else if (btn[0] & ~direction[0]) begin // turn
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_PV;
        turns = turns + 1;
        end
    else if (btn[1] & ~direction[1]) begin
        snake_head_x_delta_next = SNAKE_PV;
        snake_head_y_delta_next = SNAKE_0V;
        turns = turns + 1;
        end
    else if (btn[2] & ~direction[2]) begin
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_NV;
        turns = turns + 1;
        end
    else if (btn[3] & ~direction[3]) begin
        snake_head_x_delta_next = SNAKE_NV;
        snake_head_y_delta_next = SNAKE_0V;
        turns = turns + 1;
        end
    end

endmodule
