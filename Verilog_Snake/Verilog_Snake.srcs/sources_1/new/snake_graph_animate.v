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
        
        output reg eaten,
        output reg [11:0] rgb
    );
// note: you haven't actually added collision = end yet

// screen size (64x64)
localparam MAX_X = 352;
localparam MIN_X = 288;
    
localparam MAX_Y = 272;
localparam MIN_Y = 208;

// Location of fruit
reg  [9:0] FRUIT_X_REG = 10'd0, FRUIT_Y_REG = 10'd0;
reg [9:0] FRUIT_X_NEXT = 10'd0, FRUIT_Y_NEXT = 10'd0;

// screen refresh time, based on beginning and end of screen
//wire refr_tick;

// snake positions
wire [9:0] snake_head_x, snake_head_y, snake_tail_x, snake_tail_y; // current snake head/tail position
wire [9:0] snake_head_x_next, snake_head_y_next, snake_tail_x_next, snake_tail_y_next; // next snake head/tail positions
reg [9:0] snake_head_x_reg = 10'd320, snake_head_y_reg = 10'd240, snake_tail_x_reg = 10'd318, snake_tail_y_reg = 10'd240; // track snake position
// direction is initialized to right
assign snake_head_x = snake_head_x_reg;
assign snake_head_y = snake_head_y_reg;
assign snake_tail_x = snake_tail_x_reg;
assign snake_tail_y = snake_tail_y_reg;
reg [3:0] direction = 4'b0010; // bit 0 is up, bit 1 is right, bit 2 is down, bit 3 is left

// snake velocities
localparam SNAKE_PV = 1;
localparam SNAKE_0V = 0;
localparam SNAKE_NV = -1;
integer snake_head_x_delta_next, snake_head_y_delta_next, snake_tail_x_delta_next, snake_tail_y_delta_next; // next snake head/tail velocity
integer snake_head_x_delta_reg = SNAKE_PV, snake_head_y_delta_reg = SNAKE_0V; // current snake head velocity
integer snake_tail_x_delta_reg = SNAKE_PV, snake_tail_y_delta_reg = SNAKE_0V; // current snake tail velocity

// check if game has ended
integer game_end = 0;

// supports up to 32 turns
reg [4:0] turns = 5'b00000;
reg turn; // to check if a turn occurs
// save each turn as 10 bits by saving head location whenever a turn happens
// shift by 10 * (turns - 1) for each turn
reg [319:0] turn_x = 320'b0;
reg [319:0] turn_y = 320'b0;

// for checking snake_on, check if parts, head, and tail are on
reg [31:0] snake_parts = 32'b0; // parts = body part, returns 1 whenever a part exists
reg snake_head_on = 0;
reg snake_tail_on = 0;
reg fruit_on = 0; // check if fruit is on
reg snake_on = 0;

// int i for loop
integer i = 1;
// temporary for checking turns. takes calues from turn_x and turn_y
reg [9:0] turns1x = 10'b0, turns1y = 10'b0, turns2x = 10'b0, turns2y = 10'b0;
wire [9:0] lastest_turn_x, latest_turn_y;

assign latest_turn_x = {turn_x[turns*10-1],turn_x[turns* 10-2],turn_x[turns*10-3],turn_x[turns*10-4],turn_x[turns*10-5],turn_x[turns*10-6],turn_x[turns*10-7],turn_x[turns*10-8],turn_x[turns*10-9],turn_x[turns*10-10]};
assign latest_turn_y = {turn_y[turns*10-1],turn_y[turns* 10-2],turn_y[turns*10-3],turn_y[turns*10-4],turn_y[turns*10-5],turn_y[turns*10-6],turn_y[turns*10-7],turn_y[turns*10-8],turn_y[turns*10-9],turn_y[turns*10-10]};


//---------------------------------- BORDERS -------------------------------------
    localparam LEFT_BORDER_L  = MIN_X - 4;
    localparam LEFT_BORDER_R  = MIN_X - 2;
    
    localparam RIGHT_BORDER_L = MAX_X + 2;
    localparam RIGHT_BORDER_R = MAX_X + 4;
    
    localparam TOP_BORDER_T   = MAX_Y + 4; 
    localparam TOP_BORDER_B   = MAX_Y + 2;
    
    localparam BOT_BORDER_T   = MIN_Y - 2;
    localparam BOT_BORDER_B   = MIN_Y - 4;
    
    /*assign border_on = (LEFT_BORDER_L  <= pix_x) && (pix_x <= LEFT_BORDER_R)  &&
                       (RIGHT_BORDER_L <= pix_x) && (pix_x <= RIGHT_BORDER_R) &&
                       (TOP_BORDER_T   <= pix_y) && (pix_y <= TOP_BORDER_B)   &&
                       (BOT_BORDER_T   <= pix_y) && (pix_y <= BOT_BORDER_B);*/
                       reg border_on;
    //assign border_RGB = 3'b111; // WHITE

// update position every clk cycle, or reset all positions
// this whole thing isn't running
// which is so odd like dude. the clk is running/
// HOW IT IS NOT FUCKNG RUNNING.
always @(posedge clk, posedge reset) begin
    if (reset) begin
        //fruit_on = (apple_x == pix_x) && (apple_y == pix_y);
        //snake_on = (snake_head_on || snake_tail_on || snake_parts[31] || snake_parts[30] || snake_parts[29] || snake_parts[28] || snake_parts[26] || snake_parts[25] || snake_parts[24] || snake_parts[23] || snake_parts[22] || snake_parts[21] || snake_parts[20] || snake_parts[19] || snake_parts[18] || snake_parts[17] || snake_parts[16] || snake_parts[15] || snake_parts[14] || snake_parts[13] || snake_parts[12] || snake_parts[11] || snake_parts[10] || snake_parts[9] || snake_parts[8] || snake_parts[7] || snake_parts[6] || snake_parts[5] || snake_parts[4] || snake_parts[3] || snake_parts[2] || snake_parts[1] || snake_parts[0]);
        // make it so that it stays still until a movement is made
        snake_head_x_reg <= 320;
        snake_head_y_reg <= 240;
        snake_tail_x_reg <= 318;
        snake_tail_y_reg <= 240;
        FRUIT_X_REG <= $urandom_range(MAX_X, MIN_X);
        FRUIT_Y_REG <= $urandom_range(MAX_Y, MIN_Y);
        turn_x <= 320'b0;
        turn_y <= 320'b0;
        turns1x <= 10'b0;
        turns1y <= 10'b0;
        turns2x <= 10'b0;
        turns2y <= 10'b0;
        turns <= 5'b00000;
        direction = 4'b0010;
        snake_head_x_delta_reg <= SNAKE_PV;
        snake_head_y_delta_reg <= SNAKE_0V; 
        snake_tail_x_delta_reg <= SNAKE_PV;
        snake_tail_y_delta_reg <= SNAKE_0V;
        snake_head_x_delta_next <= SNAKE_PV;
        snake_head_y_delta_next <= SNAKE_0V;
        snake_tail_x_delta_next <= SNAKE_PV;
        snake_tail_y_delta_next <= SNAKE_0V;
        
        snake_on <= 0;
        snake_head_on <= 0;
        snake_tail_on <= 0;
        snake_parts <= 32'b0;
    end
    else begin
        //fruit_on = (apple_x == pix_x) && (apple_y == pix_y);
        //snake_on = (snake_head_on || snake_tail_on || snake_parts[31] || snake_parts[30] || snake_parts[29] || snake_parts[28] || snake_parts[26] || snake_parts[25] || snake_parts[24] || snake_parts[23] || snake_parts[22] || snake_parts[21] || snake_parts[20] || snake_parts[19] || snake_parts[18] || snake_parts[17] || snake_parts[16] || snake_parts[15] || snake_parts[14] || snake_parts[13] || snake_parts[12] || snake_parts[11] || snake_parts[10] || snake_parts[9] || snake_parts[8] || snake_parts[7] || snake_parts[6] || snake_parts[5] || snake_parts[4] || snake_parts[3] || snake_parts[2] || snake_parts[1] || snake_parts[0]);
        snake_head_x_reg <= snake_head_x_next;
        snake_head_y_reg <= snake_head_y_next;
        snake_tail_x_reg <= snake_tail_x_next;
        snake_tail_y_reg <= snake_tail_y_next;
        FRUIT_X_REG <= FRUIT_X_NEXT;
        FRUIT_Y_REG <= FRUIT_Y_NEXT;
        snake_head_x_delta_reg <= snake_head_x_delta_next;
        snake_head_y_delta_reg <= snake_head_y_delta_next;
        snake_tail_x_delta_reg <= snake_tail_x_delta_next;
        snake_tail_y_delta_reg <= snake_tail_y_delta_next;
    end
end

//assign refr_tick = (pix_y==MAX_Y) && (pix_x==MAX_X); 


// turn on snake and appple if applicable

always@(posedge clk) begin
// check turns
// turns being 0 means snake is a straight line like -------
// in short: just check between head and tail 
if (turns == 5'b00000) begin
    case(direction)
        4'b0001 : snake_head_on = ((snake_tail_y_reg <= pix_y) && (pix_y <= snake_head_y_reg) && (pix_x == snake_head_x_reg)); // up
        4'b0010 : snake_head_on = ((snake_tail_x_reg <= pix_x) && (pix_x <= snake_head_x_reg) && (pix_y == snake_head_y_reg)); // right
        4'b0100 : snake_head_on = ((snake_head_y_reg <= pix_y) && (pix_y <= snake_tail_y_reg) && (pix_x == snake_head_x_reg)); // down
        4'b1000 : snake_head_on = ((snake_head_x_reg <= pix_x) && (pix_x <= snake_tail_x_reg) && (pix_y == snake_head_y_reg)); // left
        default : snake_head_on = snake_head_on;
    endcase
end

// otherwise
// snake is like
//  |- - -
//  |
//  |
// therefore: snake on is between head and first turn, then first turn and tail
else begin
    // check head
    case(direction)
        4'b0001 : snake_head_on = (((turn_y[9:0] <= pix_y) && (pix_y <= snake_head_y_reg) && (pix_x == snake_head_x_reg))); // up
        4'b0010 : snake_head_on = (((turn_x[9:0] <= pix_x) && (pix_x <= snake_head_x_reg) && (pix_y == snake_head_y_reg))); // right
        4'b0100 : snake_head_on = (((snake_head_y_reg <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_head_x_reg))); // down
        4'b1000 : snake_head_on = (((snake_head_x_reg <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_y == snake_head_y_reg))); // left
        default : snake_head_on = snake_head_on;
    endcase
    
    // check tail
    if (snake_tail_x_reg < latest_turn_x) begin
        snake_tail_on = ((snake_tail_x_reg <= pix_x) && (pix_x <= latest_turn_x) && (pix_y == snake_tail_y_reg));
    end
    else if (snake_tail_x_reg > latest_turn_x) begin
        snake_tail_on = ((latest_turn_x <= pix_x) && (pix_x <= snake_tail_x_reg) && (pix_y == snake_tail_y_reg));
    end
    else if (snake_tail_y_reg < latest_turn_y) begin
        snake_tail_on = ((snake_tail_y_reg <= pix_y) && (pix_y <= latest_turn_y) && (pix_x == snake_tail_x_reg));
    end
    else if (snake_tail_y_reg > latest_turn_y) begin
        snake_tail_on = ((latest_turn_y <= pix_y) && (pix_y <= snake_tail_y_reg) && (pix_x == snake_tail_x_reg));
    end
    
    for (i = 1; i < turns; i = i + 1) begin
            // check ALL body parts and if it runs into a false it breaks?
            // no....
            turns1x = {turn_x[i*10-1],turn_x[i* 10-2],turn_x[i*10-3],turn_x[i*10-4],turn_x[i*10-5],turn_x[i*10-6],turn_x[i*10-7],turn_x[i*10-8],turn_x[i*10-9],turn_x[i*10-10]};
            turns1y = {turn_y[i*10-1],turn_y[i* 10-2],turn_y[i*10-3],turn_y[i*10-4],turn_y[i*10-5],turn_y[i*10-6],turn_y[i*10-7],turn_y[i*10-8],turn_y[i*10-9],turn_y[i*10-10]};
            turns2x = {turn_x[(i + 1)*10-1],turn_x[(i + 1)* 10-2],turn_x[(i + 1)*10-3],turn_x[(i + 1)*10-4],turn_x[(i + 1)*10-5],turn_x[(i + 1)*10-6],turn_x[(i + 1)*10-7],turn_x[(i + 1)*10-8],turn_x[(i + 1)*10-9],turn_x[(i + 1)*10-10]};
            turns2y = {turn_y[(i + 1)*10-1],turn_y[(i + 1)* 10-2],turn_y[(i + 1)*10-3],turn_y[(i + 1)*10-4],turn_y[(i + 1)*10-5],turn_y[(i + 1)*10-6],turn_y[(i + 1)*10-7],turn_y[(i + 1)*10-8],turn_y[(i + 1)*10-9],turn_y[(i + 1)*10-10]};
            
            // here, fill in the in between
            // set it to snake parts i - 1 (-1 since i begins at 1)
            if (turns1x < turns2x) begin
                snake_parts[i - 1] = ((turns1x <= pix_x) && (pix_x <= turns2x) && (pix_y == turns1y));
            end
            else if (turns1x > turns2x) begin
                snake_parts[i - 1] = ((turns2x <= pix_x) && (pix_x <= turns1x) && (pix_y == turns1y));
            end
            else if (turns1y < turns2y) begin
                snake_parts[i - 1] = ((turns1y <= pix_y) && (pix_x <= turns2y) && (pix_x == turns1x));
            end
            else if (turns1y > turns2y) begin
                snake_parts[i - 1] = ((turns2y <= pix_y) && (pix_x <= turns1y) && (pix_x == turns1x));
            end
        end
    end
    
end


    // maybe delete turns by checking if they are nonzero and total distance from head is greater than snake length?



// refer to ball movement bc its more similar
// at each tick, update position; else, keep position same
//assign snake_head_x_next = (clk) ? (snake_head_x_reg + snake_head_x_delta_int/*snake_head_x_delta_reg*/) : (snake_head_x_reg);
//assign snake_head_y_next = (clk) ? (snake_head_y_reg + snake_head_y_delta_int/*snake_head_y_delta_reg*/) : (snake_head_y_reg);
//assign snake_tail_x_next = (clk) ? (snake_tail_x_reg + snake_tail_x_delta_int/*snake_tail_x_delta_reg*/) : (snake_tail_x_reg);
//assign snake_tail_y_next = (clk) ? (snake_tail_y_reg + snake_tail_y_delta_int/*snake_tail_y_delta_reg*/) : (snake_tail_y_reg);

// refer to ball movement bc its more similar
// at each tick, update position; else, keep position same
assign snake_head_x_next = (clk) ? (snake_head_x_reg + snake_head_x_delta_reg) : (snake_head_x_reg);
assign snake_head_y_next = (clk) ? (snake_head_y_reg + snake_head_y_delta_reg) : (snake_head_y_reg);
assign snake_tail_x_next = (clk) ? (snake_tail_x_reg + snake_tail_x_delta_reg) : (snake_tail_x_reg);
assign snake_tail_y_next = (clk) ? (snake_tail_y_reg + snake_tail_y_delta_reg) : (snake_tail_y_reg);

    //note to self: add snake end
    // fix eaten??
    //---------------------------------- FRUIT ---------------------------------------
    // , posedge reset, posedge eaten
    always @(posedge clk) begin
        if (btn == 4'b0000) begin
            direction = direction;
            snake_head_x_delta_next = snake_head_x_delta_next;
            snake_head_y_delta_next = snake_head_y_delta_next;
            turn = 0;
        end
        else if (btn[0] && ~direction[0] && ~direction[2]) begin
            // turn up, direction is not vertical
            // update direction, velocity
            direction = 4'b0001;
            snake_head_x_delta_next = SNAKE_0V;
            snake_head_y_delta_next = SNAKE_PV;
            turn = 1;
        end
        else if (btn[1] && ~direction[1] && ~direction[3]) begin
            // turn up, direction is not vertical
            // update direction, velocity
            direction = 4'b0010;
            snake_head_x_delta_next = SNAKE_PV;
            snake_head_y_delta_next = SNAKE_0V;
            turn = 1;
        end
        else if (btn[2] && ~direction[0] && ~direction[2]) begin
            // turn up, direction is not vertical
            // update direction, velocity
            direction = 4'b0100;
            snake_head_x_delta_next = SNAKE_0V;
            snake_head_y_delta_next = SNAKE_NV;
            turn = 1;
        end
        else if (btn[3] && ~direction[1] && ~direction[3]) begin
            // turn up, direction is not vertical
            // update direction, velocity
            direction = 4'b1000;
            snake_head_x_delta_next = SNAKE_NV;
            snake_head_y_delta_next = SNAKE_0V;
            turn = 1;
        end
        
        if ((snake_head_x_reg == FRUIT_X_REG) && (snake_head_y_reg == FRUIT_Y_REG)) begin
        // snake touches fruit -- eaten is true, update fruit location
            eaten = 1;
            FRUIT_X_REG = $urandom_range(MAX_X, MIN_X);
            FRUIT_Y_REG = $urandom_range(MAX_Y, MIN_Y);
        end
        
        if ((snake_tail_x == latest_turn_x) && (snake_tail_y == latest_turn_y)) begin
            turns = turns - 5'b00001;
            turn_x = turn_x & (10'b0 << (turns * 10));
            turn_y = turn_y & (10'b0 << (turns * 10));
        end
        
        if (eaten) begin
            // reset eaten, stall tail
            eaten = 0;
            snake_tail_x_delta_next = SNAKE_0V;
            snake_tail_y_delta_next = SNAKE_0V;
        end else
    
        if(eaten)begin
            // set a new fruit location
            FRUIT_X_NEXT = $urandom_range(MAX_X, MIN_X);
            FRUIT_Y_NEXT = $urandom_range(MAX_Y, MIN_Y);
            // keep tail the same
            snake_tail_x_delta_next = SNAKE_0V;
            snake_tail_y_delta_next = SNAKE_0V;
            // update turns normally
        end
        else
        begin
        
        if (turns == 5'b00000) begin
            snake_tail_x_delta_next = snake_head_x_delta_next;
            snake_tail_y_delta_next = snake_head_y_delta_next;
        end
        else begin
            if (snake_tail_x < latest_turn_x) begin
                snake_tail_x_delta_next = SNAKE_PV;
                snake_tail_y_delta_next = SNAKE_0V;
            end
            else if (snake_tail_x > latest_turn_x) begin
                snake_tail_x_delta_next = SNAKE_NV;
                snake_tail_y_delta_next = SNAKE_0V;
            end
            else if (snake_tail_y < latest_turn_y) begin
                snake_tail_x_delta_next = SNAKE_0V;
                snake_tail_y_delta_next = SNAKE_PV;
            end
            else if (snake_tail_y > latest_turn_y) begin
                snake_tail_x_delta_next = SNAKE_0V;
                snake_tail_y_delta_next = SNAKE_NV;
            end
        end
    end
end


always @(posedge turn) begin
    turn_x = turn_x | (snake_head_x << (10 * turns));
    turn_y = turn_y | (snake_head_y << (10 * turns));
    turns = turns + 5'b00001;
    turn = 0;
end


// so THIS runs...
always @(*) begin
    //snake_head_x_reg = 320;
    //snake_head_y_reg = 240;
    //snake_head_on = ((snake_head_x_reg == pix_x) && (snake_head_y_reg == pix_y));
    snake_on = (snake_head_on || snake_tail_on || snake_parts[31] || snake_parts[30] || snake_parts[29] || snake_parts[28] || snake_parts[26] || snake_parts[25] || snake_parts[24] || snake_parts[23] || snake_parts[22] || snake_parts[21] || snake_parts[20] || snake_parts[19] || snake_parts[18] || snake_parts[17] || snake_parts[16] || snake_parts[15] || snake_parts[14] || snake_parts[13] || snake_parts[12] || snake_parts[11] || snake_parts[10] || snake_parts[9] || snake_parts[8] || snake_parts[7] || snake_parts[6] || snake_parts[5] || snake_parts[4] || snake_parts[3] || snake_parts[2] || snake_parts[1] || snake_parts[0]);
    fruit_on = ((FRUIT_X_REG == pix_x) && (FRUIT_Y_REG == pix_y));
    border_on = (((LEFT_BORDER_L  <= pix_x) && (pix_x <= LEFT_BORDER_R) && (BOT_BORDER_B <= pix_y) && (pix_y <= TOP_BORDER_T)) ||
    ((RIGHT_BORDER_L <= pix_x) && (pix_x <= RIGHT_BORDER_R) && (BOT_BORDER_B <= pix_y) && (pix_y <= TOP_BORDER_T)) ||
    ((TOP_BORDER_B   <= pix_y) && (pix_y <= TOP_BORDER_T) && (LEFT_BORDER_L < pix_x) && (pix_x <= RIGHT_BORDER_R)) ||
    ((BOT_BORDER_B   <= pix_y) && (pix_y <= BOT_BORDER_T) && (LEFT_BORDER_L < pix_x) && (pix_x <= RIGHT_BORDER_R)));
    
    if (~video_on) begin // WHITE
        rgb = 12'b1;
    end
    else if (snake_on) begin   // GREEN
        rgb = 12'b000000001111;
    end
    else if (fruit_on) begin
        rgb = 12'b111100000000;
    end
    else if (border_on) begin
        rgb = 12'b111100000000;
    end
    else begin
        rgb = 12'b000011110000;
    end
end
   
endmodule
