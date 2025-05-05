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
        input wire video_on, eaten,
        input wire [3:0] btn,
        input wire [9:0] pix_x,
        input wire [9:0] pix_y,
        
        output reg [2:0] graph_rgb
    );
<<<<<<< Updated upstream
    
    // Location of fruit
    reg  [9:0] FRUIT_X_REG, FRUIT_Y_REG;
    wire [9:0] FRUIT_X_NEXT, FRUIT_Y_NEXT;
    
    // Border of the screen
    localparam MAX_X = 352;
    localparam MIN_X = 288;
    
    localparam MAX_Y = 272;
    localparam MIN_Y = 208;
    
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
=======

// screen sizes + accounting for score at the top
localparam MIN_X = 0;
localparam MAX_X = 640;
localparam MIN_Y = 0;
localparam MAX_Y = 480 - 16;

// clk or smthn idk
wire refr_tick;

// TO-DO: ADD SNAKE TAIL
wire [9:0] snake_head_x, snake_head_y, snake_tail_x, snake_tail_y; // current snake head/tail position
wire [9:0] snake_head_x_next, snake_head_y_next, snake_tail_x_next, snake_tail_y_next; // next snake head/tail positions
reg [9:0] snake_head_x_reg, snake_head_y_reg, snake_tail_x_reg, snake_tail_y_reg; // track snake position
// direction is initialized to right
reg [3:0] direction = 4'b0010; // bit 0 is up, bit 1 is right, bit 2 is down, bit 3 is left

// snake velocities
integer SNAKE_PV = 1;
integer SNAKE_0V = 0;
integer SNAKE_NV = -1;
reg snake_head_x_delta_next, snake_head_y_delta_next, snake_tail_x_delta_next, snake_tail_y_delta_next; // next snake head/tail velocity
wire snake_head_x_delta_reg = SNAKE_PV, snake_head_y_delta_reg = SNAKE_0V; // current snake head velocity
wire snake_tail_x_delta_reg = SNAKE_PV, snake_tail_y_delta_reg = SNAKE_0V; // current snake tail velocity
// TO-DO: ADD SNAKE TAIL
// initialize to move right
// snake velocities, move up, down, or neither

integer game_end = 0;
reg fruit = 0;

// to add:
// snake_body: location of snake body parts

// snake location in board
assign snake_head_x = snake_head_x_reg; // *snake is currently 1 pixel
assign snake_head_y = snake_head_y_reg;
assign snake_tail_x = snake_tail_x_reg;
assign snake_tail_y = snake_tail_y_reg;

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

integer i = 0;
reg [31:0] on_temp;
reg [9:0] turns1x, turns1y, turns2x, turns2y;
// fill in 
// check num of turns
always@(*) begin
if (turns == 0) begin
    // check direction
    // wait i have cases
    case(direction)
        4'b0001 : snake_on = ((snake_tail_y <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x)); // up
        4'b0010 : snake_on = ((snake_tail_x <= pix_x) && (pix_x <= snake_head_x) && (pix_x == snake_head_y)); // right
        4'b0100 : snake_on = ((snake_head_y <= pix_y) && (pix_y <= snake_tail_y) && (pix_x == snake_head_x)); // down
        4'b1000 : snake_on = ((snake_head_x <= pix_x) && (pix_x <= snake_tail_x) && (pix_x == snake_head_y)); // left
        default : snake_on = snake_on;
    endcase
    //assign snake_on = (snake_head_x <= snake_tail_x) && (snake_head_y <= snake_tail_y);
end
else if (turns == 1) begin
    //i wish i could use a case statement but it's reliant on diff things.
    // UNLESS i make a variable...
    if (snake_tail_x < turn_x[9:0]) begin
        // tail < pix x < turn x, pix_y = tail_
        on_temp[0] = ((snake_tail_x <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_x > turn_x[9:0]) begin
        on_temp[0] = ((turn_x[9:0] <= pix_x) && (pix_x <= snake_tail_x) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_y < turn_y[9:0]) begin
        on_temp[0] = ((snake_tail_y <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_tail_x));
    end
    else if (snake_tail_y > turn_y[9:0]) begin
        on_temp[0] = ((turn_y[9:0] <= pix_y) && (pix_y <= snake_tail_y) && (pix_x == snake_tail_x));
    end
    case(direction)
        4'b0001 : snake_on = (((turn_y[9:0] <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x)) || on_temp[0]); // up
        4'b0010 : snake_on = (((turn_x[9:0] <= pix_x) && (pix_x <= snake_head_x) && (pix_x == snake_head_y)) || on_temp[0]); // right
        4'b0100 : snake_on = (((snake_head_y <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_head_x)) || on_temp[0]); // down
        4'b1000 : snake_on = (((snake_head_x <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_x == snake_head_y)) || on_temp[0]); // left
        default : snake_on = snake_on;
    endcase
end
begin
    // num turns = num shifts
    // foor loop n if statement?
    // bit call HAS to be constant...
    // no i just have to concatenate ALL 10 bits in the for loop
    if (direction[0]) begin
        // use a for loop to return a 1 for pixels between each body part
        for (i = 1; i < turns; i = i + 1) begin
            // check ALL body parts and if it runs into a false it breaks?
            // no....
            turns1x = {turn_x[i*10-1],turn_x[i* 10-2],turn_x[i*10-3],turn_x[i*10-4],turn_x[i*10-5],turn_x[i*10-6],turn_x[i*10-7],turn_x[i*10-8],turn_x[i*10-9],turn_x[i*10-10]};
            turns1y = {turn_y[i*10-1],turn_y[i* 10-2],turn_y[i*10-3],turn_y[i*10-4],turn_y[i*10-5],turn_y[i*10-6],turn_y[i*10-7],turn_y[i*10-8],turn_y[i*10-9],turn_y[i*10-10]};
            on_temp[i] = 1'b1;
            // note: fill in BOTH X AND Y. CHECK IF X/Y VALUE SAME THEN CHECK IF PIX IS BETWEEN Y/X
            // use OR for snake_on. we are not filling in a square of snake. they are individual lines
            // in short it is checking OR for body parts. it is a SOP.
            // ((snake_tail_y <= pix_y) && (pix_y <= turn_y[i]) && (snake_tail_x == turn[x])) || etc.
        end
        snake_on = ((snake_tail_y <= pix_y) && (pix_y <= turn_y[i]));
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
assign snake_tail_x_next = (refr_tick) ? (snake_tail_x_reg + snake_tail_x_delta_reg) : (snake_tail_x_reg);
assign snake_tail_y_next = (refr_tick) ? (snake_tail_y_reg + snake_tail_y_delta_reg) : (snake_tail_y_reg);

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
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
    
    //---------------------------------- FRUIT ---------------------------------------
    
    always @(posedge clk, posedge reset, posedge eaten) begin
        if(reset)begin
            // RESET SNAKE POSITION HERE
            FRUIT_X_REG <= 0;
            FRUIT_Y_REG <= 0;
        end if(eaten)begin
            FRUIT_X_REG <= FRUIT_X_NEXT;
            FRUIT_Y_REG <= FRUIT_Y_NEXT;
        end else begin
=======
    else if (btn[0] & ~direction[0] & ~direction[2]) begin // turn
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_PV;
        turns = turns + 1;
        end
    else if (btn[1] & ~direction[1] & ~direction[3]) begin
        snake_head_x_delta_next = SNAKE_PV;
        snake_head_y_delta_next = SNAKE_0V;
        turns = turns + 1;
        end
    else if (btn[2] & ~direction[2] & ~direction[0]) begin
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_NV;
        turns = turns + 1;
        end
    else if (btn[3] & ~direction[3] & ~direction[1]) begin
        snake_head_x_delta_next = SNAKE_NV;
        snake_head_y_delta_next = SNAKE_0V;
        turns = turns + 1;
>>>>>>> Stashed changes
        end
    // add tail location check
    // check location is less than or more than latest turn or head
    end


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
