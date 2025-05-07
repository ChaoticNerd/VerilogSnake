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
        input wire [9:0] apple_x, apple_y,
        input wire [9:0] pix_x,
        input wire [9:0] pix_y,
        
        output reg [2:0] graph_rgb
    );

// screen sizes + accounting for score at the top
localparam MAX_X = 352;
localparam MIN_X = 288;
    
localparam MAX_Y = 272;
localparam MIN_Y = 208;

// Location of fruit
reg  [9:0] FRUIT_X_REG, FRUIT_Y_REG;
wire [9:0] FRUIT_X_NEXT, FRUIT_Y_NEXT;

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

reg [4:0] turns = 5'b00000;
// supports up to 32 turns idk
reg [31:0] snake_parts; // parts = body part, returns 1 whenever a part exists
reg snake_head_on;
reg snake_tail_on;
reg fruit_on;
reg [319:0] turn_x;
reg [319:0] turn_y;
// i think the best way to do this is to put a location for every turn
// update turn x and turn y so body 1 and body 2 can use it or smthn
// max # of turns: ??? 16 maybe
// but that means 32 stored turn cases..... 
// no wait/
// an array of 9 bits each. so 9 * 144 bit thing with 9 bit shifts * turn number
// I THINK IVE COOKED??

integer i = 1;
reg [9:0] turns1x, turns1y, turns2x, turns2y;
reg [9:0] turn_x_temp, turn_y_temp;

//---------------------------------- BORDERS -------------------------------------
    localparam LEFT_BORDER_L  = MIN_X - 4;
    localparam LEFT_BORDER_R  = MIN_X - 2;
    
    localparam RIGHT_BORDER_L = MAX_X + 2;
    localparam RIGHT_BORDER_R = MAX_X + 4;
    
    localparam TOP_BORDER_T   = MAX_Y + 4; 
    localparam TOP_BORDER_B   = MAX_Y + 2;
    
    localparam BOT_BORDER_T   = MIN_Y - 2;
    localparam BOT_BORDER_B   = MIN_Y - 4;
    
    assign border_on = (LEFT_BORDER_L  <= pix_x) && (pix_x <= LEFT_BORDER_R)  &&
                       (RIGHT_BORDER_L <= pix_x) && (pix_x <= RIGHT_BORDER_R) &&
                       (TOP_BORDER_T   <= pix_y) && (pix_y <= TOP_BORDER_B)   &&
                       (BOT_BORDER_T   <= pix_y) && (pix_y <= BOT_BORDER_B);
    assign border_RGB = 3'b111; // WHITE

reg snake_on;
// fill in 
// check num of turns
always@(*) begin
if (turns == 0) begin
    fruit_on = (apple_x <= pix_x) && (apple_y <= pix_y);
    // check direction
    // wait i have cases
    case(direction)
        4'b0001 : snake_head_on = ((snake_tail_y <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x)); // up
        4'b0010 : snake_head_on = ((snake_tail_x <= pix_x) && (pix_x <= snake_head_x) && (pix_x == snake_head_y)); // right
        4'b0100 : snake_head_on = ((snake_head_y <= pix_y) && (pix_y <= snake_tail_y) && (pix_x == snake_head_x)); // down
        4'b1000 : snake_head_on = ((snake_head_x <= pix_x) && (pix_x <= snake_tail_x) && (pix_x == snake_head_y)); // left
        default : snake_head_on = snake_head_on;
    endcase
    snake_on = snake_head_on;
    //assign snake_on = (snake_head_x <= snake_tail_x) && (snake_head_y <= snake_tail_y);
end
else if (turns == 1) begin
    fruit_on = (apple_x <= pix_x) && (apple_y <= pix_y);
    //i wish i could use a case statement but it's reliant on diff things.
    // UNLESS i make a variable...
    if (snake_tail_x < turn_x[9:0]) begin
        // tail < pix x < turn x, pix_y = tail_
        snake_tail_on = ((snake_tail_x <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_x > turn_x[9:0]) begin
        snake_tail_on = ((turn_x[9:0] <= pix_x) && (pix_x <= snake_tail_x) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_y < turn_y[9:0]) begin
        snake_tail_on = ((snake_tail_y <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_tail_x));
    end
    else if (snake_tail_y > turn_y[9:0]) begin
        snake_tail_on = ((turn_y[9:0] <= pix_y) && (pix_y <= snake_tail_y) && (pix_x == snake_tail_x));
    end
    case(direction)
        4'b0001 : snake_head_on = (((turn_y[9:0] <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x))); // up
        4'b0010 : snake_head_on = (((turn_x[9:0] <= pix_x) && (pix_x <= snake_head_x) && (pix_x == snake_head_y))); // right
        4'b0100 : snake_head_on = (((snake_head_y <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_head_x))); // down
        4'b1000 : snake_head_on = (((snake_head_x <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_x == snake_head_y))); // left
        default : snake_head_on = snake_head_on;
    endcase
    snake_on = snake_head_on || snake_tail_on;
    end
else if (turns >= 2) begin
    fruit_on = (apple_x <= pix_x) && (apple_y <= pix_y);
   //i = 1;
    //if (turns > 32) begin
    //    turns = 5;
    //end
    //turns = 32;
    // num turns = num shifts
    // foor loop n if statement?
    // bit call HAS to be constant...
    // no i just have to concatenate ALL 10 bits in the for loop
        // use a for loop to return a 1 for pixels between each body part
     /*   for (i = 1; i < turns; i = i + 1) begin
            // check ALL body parts and if it runs into a false it breaks?
            // no....
            turns1x = {turn_x[i*10-1],turn_x[i* 10-2],turn_x[i*10-3],turn_x[i*10-4],turn_x[i*10-5],turn_x[i*10-6],turn_x[i*10-7],turn_x[i*10-8],turn_x[i*10-9],turn_x[i*10-10]};
            turns1y = {turn_y[i*10-1],turn_y[i* 10-2],turn_y[i*10-3],turn_y[i*10-4],turn_y[i*10-5],turn_y[i*10-6],turn_y[i*10-7],turn_y[i*10-8],turn_y[i*10-9],turn_y[i*10-10]};
            turns2x = {turn_x[(i + 1)*10-1],turn_x[(i + 1)* 10-2],turn_x[(i + 1)*10-3],turn_x[(i + 1)*10-4],turn_x[(i + 1)*10-5],turn_x[(i + 1)*10-6],turn_x[(i + 1)*10-7],turn_x[(i + 1)*10-8],turn_x[(i + 1)*10-9],turn_x[(i + 1)*10-10]};
            turns2y = {turn_y[(i + 1)*10-1],turn_y[(i + 1)* 10-2],turn_y[(i + 1)*10-3],turn_y[(i + 1)*10-4],turn_y[(i + 1)*10-5],turn_y[(i + 1)*10-6],turn_y[(i + 1)*10-7],turn_y[(i + 1)*10-8],turn_y[(i + 1)*10-9],turn_y[(i + 1)*10-10]};

            if (turns1x < turns2x) begin
                snake_parts[i] = ((turns1x <= pix_x) && (pix_x <= turns2x) && (pix_y == turns1y));
            end
            else if (turns1x > turns2x) begin
                snake_parts[i] = ((turns2x <= pix_x) && (pix_x <= turns1x) && (pix_y == turns1y));
            end
            else if (turns1y < turns2y) begin
                snake_parts[i] = ((turns1x <= pix_x) && (pix_x <= turns2x) && (pix_x == turns1x));
            end
            else if (turns1y > turns2y) begin
                snake_parts[i] = ((turns1x <= pix_x) && (pix_x <= turns2x) && (pix_x == turns1x));
            end
            // note: fill in BOTH X AND Y. CHECK IF X/Y VALUE SAME THEN CHECK IF PIX IS BETWEEN Y/X
            // use OR for snake_on. we are not filling in a square of snake. they are individual lines
            // in short it is checking OR for body parts. it is a SOP.
            // ((snake_tail_y <= pix_y) && (pix_y <= turn_y[i]) && (snake_tail_x == turn[x])) || etc.
            //i = turns + 1;
        end*/
        case(direction)
        4'b0001 : snake_head_on = (((turn_y[9:0] <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x))); // up
        4'b0010 : snake_head_on = (((turn_x[9:0] <= pix_x) && (pix_x <= snake_head_x) && (pix_x == snake_head_y))); // right
        4'b0100 : snake_head_on = (((snake_head_y <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_head_x))); // down
        4'b1000 : snake_head_on = (((snake_head_x <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_x == snake_head_y))); // left
        default : snake_head_on = snake_head_on;
    endcase
    if (snake_tail_x < turns2x) begin
        // tail < pix x < turn x, pix_y = tail_
        snake_tail_on = ((snake_tail_x <= pix_x) && (pix_x <= turns2x) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_x > turns2x) begin
        snake_tail_on = ((turns2x <= pix_x) && (pix_x <= snake_tail_x) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_y < turns2y) begin
        snake_tail_on = ((snake_tail_y <= pix_y) && (pix_y <= turns2y) && (pix_x == snake_tail_x));
    end
    else if (snake_tail_y > turns2y) begin
        snake_tail_on = ((turns2y <= pix_y) && (pix_y <= snake_tail_y) && (pix_x == snake_tail_x));
    end
    snake_on = snake_head_on || snake_tail_on || snake_parts[31] || snake_parts[30] || snake_parts[29] || snake_parts[28] || snake_parts[26] || snake_parts[25] || snake_parts[24] || snake_parts[23] || snake_parts[22] || snake_parts[21] || snake_parts[20] || snake_parts[19] || snake_parts[18] || snake_parts[17] || snake_parts[16] || snake_parts[15] || snake_parts[14] || snake_parts[13] || snake_parts[12] || snake_parts[11] || snake_parts[10] || snake_parts[9] || snake_parts[8] || snake_parts[7] || snake_parts[6] || snake_parts[5] || snake_parts[4] || snake_parts[3] || snake_parts[2] || snake_parts[1] || snake_parts[0];



if ((snake_tail_x == turns2x) && (snake_tail_y == turns2y)) begin
    turns = turns - 5'b00001;
    turn_x = turn_x & (10'b0 << (turns * 10));
    turn_y = turn_y & (10'b0 << (turns * 10));
    // lets say turns = 1
    // turn_x[9:0]
    // turn = 0? bc no shift
    // nvm i need to subtract first
end
end
end

    // maybe delete turns by checking if they are nonzero and total distance from head is greater than snake length?
//end


// refer to ball movement bc its more similar
// at each tick, update position; else, keep position same
assign snake_head_x_next = (refr_tick) ? (snake_head_x_reg + snake_head_x_delta_reg) : (snake_head_x_reg);
assign snake_head_y_next = (refr_tick) ? (snake_head_y_reg + snake_head_y_delta_reg) : (snake_head_y_reg);
assign snake_tail_x_next = (refr_tick) ? (snake_tail_x_reg + snake_tail_x_delta_reg) : (snake_tail_x_reg);
assign snake_tail_y_next = (refr_tick) ? (snake_tail_y_reg + snake_tail_y_delta_reg) : (snake_tail_y_reg);

    //note to self: add snake end
    
    //---------------------------------- FRUIT ---------------------------------------
    // , posedge reset, posedge eaten
    always @(posedge clk) begin
        if(reset)begin
            // RESET SNAKE POSITION HERE
            FRUIT_X_REG <= 0;
            FRUIT_Y_REG <= 0;
            
        end
        if(eaten)begin
            FRUIT_X_REG <= FRUIT_X_NEXT;
            FRUIT_Y_REG <= FRUIT_Y_NEXT;
            // turn on fruit
            snake_tail_x_delta_next = SNAKE_0V;
            snake_tail_y_delta_next = SNAKE_0V;
        end
        else
        begin
        if (btn[0] && ~direction[0] && ~direction[2]) begin // turn
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_PV;
        turn_x = turn_x | (snake_head_x << (10 * turns));
        turn_y = turn_y | (snake_head_y << (10 * turns));
        turns = turns + 5'b00001;
        end
    else if (btn[1] && ~direction[1] && ~direction[3]) begin
        snake_head_x_delta_next = SNAKE_PV;
        snake_head_y_delta_next = SNAKE_0V;
        turn_x = turn_x | (snake_head_x << (10 * turns));
        turn_y = turn_y | (snake_head_y << (10 * turns));
        turns = turns + 5'b00001;
        end
    else if (btn[2] && ~direction[2] && ~direction[0]) begin
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_NV;
        turn_x = turn_x | (snake_head_x << (10 * turns));
        turn_y = turn_y | (snake_head_y << (10 * turns));
        turns = turns + 5'b00001;
        end
    else if (btn[3] && ~direction[3] && ~direction[1]) begin
        snake_head_x_delta_next = SNAKE_NV;
        snake_head_y_delta_next = SNAKE_0V;
        turn_x = turn_x | (snake_head_x << (10 * turns));
        turn_y = turn_y | (snake_head_y << (10 * turns));
        turns = turns + 5'b00001;
        end
    else begin
        snake_head_x_delta_next = snake_head_x_delta_next;
        snake_head_y_delta_next = snake_head_y_delta_next;
    end
    // add tail location check
    if (turns == 0) begin
        snake_tail_x_delta_next = snake_head_x_delta_next;
        snake_tail_y_delta_next = snake_head_y_delta_next;
    end
    else begin
        turn_x_temp = {turn_x[turns*10-1],turn_x[turns* 10-2],turn_x[turns*10-3],turn_x[turns*10-4],turn_x[turns*10-5],turn_x[turns*10-6],turn_x[turns*10-7],turn_x[turns*10-8],turn_x[turns*10-9],turn_x[turns*10-10]};
        turn_y_temp = {turn_y[turns*10-1],turn_y[turns* 10-2],turn_y[turns*10-3],turn_y[turns*10-4],turn_y[turns*10-5],turn_y[turns*10-6],turn_y[turns*10-7],turn_y[turns*10-8],turn_y[turns*10-9],turn_y[turns*10-10]};
        if (snake_tail_x < turns2x) begin
            snake_tail_x_delta_next = SNAKE_PV;
            snake_tail_y_delta_next = SNAKE_0V;
        end
        else if (snake_tail_x > turns2x) begin
            snake_tail_x_delta_next = SNAKE_NV;
            snake_tail_y_delta_next = SNAKE_0V;
        end
        else if (snake_tail_y < turns2y) begin
            snake_tail_x_delta_next = SNAKE_0V;
            snake_tail_y_delta_next = SNAKE_PV;
        end
        else if (snake_tail_y > turns2y) begin
            snake_tail_x_delta_next = SNAKE_0V;
            snake_tail_y_delta_next = SNAKE_NV;
        end
        else begin
            snake_tail_x_delta_next = snake_tail_x_delta_next;
            snake_tail_y_delta_next = snake_tail_y_delta_next;
        end
    end        
    // check location is less than or more than latest turn or head
    end
    end
    
always @* begin
    if (~video_on) begin
        graph_rgb = 3'b000;
    end
    else if (snake_on) begin
        graph_rgb = 3'b010;
    end
    else if (fruit_on) begin
        graph_rgb = 3'b001;
    end
    else begin
        graph_rgb = 3'b110;
    end
end

endmodule
