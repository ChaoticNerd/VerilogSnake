`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 12:42:38 PM
// Design Name: 
// Module Name: snake_animate_tb
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


module snake_animate_tb(

    );
    
//input wire clk,
//        input wire reset,
//        input wire video_on, eaten,
//        input wire [3:0] btn,
//        input wire [9:0] apple_x, apple_y,
//        input wire [9:0] pix_x,
//        input wire [9:0] pix_y,
        
//        output reg [2:0] graph_rgb

reg clk;
reg reset, video_on, eaten;
reg [3:0] btn;
reg [9:0] pix_x, pix_y;
reg [9:0] apple_x, apple_y;
reg [2:0] graph_rgb;

//snake_graph_animate UUT (.clk(clk), .reset(reset), .video_on(video_on), .eaten(eaten), .btn(btn), .apple_x(apple_x), .apple_y(apple_y), .pix_x(pix_x), .pix_y(pix_y), .graph_rgb(graph_rgb));
/*localparam MAX_X = 352;
localparam MIN_X = 288;

localparam MAX_Y = 272;
localparam MIN_Y = 208;*/
always #5 clk <= ~clk;
//reg [9:0] snake_head;
// 320 x 340 y


/*wire snake_head_on;
reg snake_head_x;
wire snake_head_y;

reg [9:0] snake_head_x_next;
reg [3:0] direction;

assign snake_head_on = ((snake_head_x)&&(snake_head_y));
assign snake_head_y = (240 == pix_y);*/

initial begin
    video_on = 1;
    reset = 1;
    pix_x = 319;
    pix_y = 240;
    btn = 4'b0010;
    apple_x = 320;
    apple_y = 239;
    eaten = 1;
    #10;
    eaten = 0;
    reset = 0;
    clk = 0;
    
    /*#10;
    reset = 0;
    pix_x = 320;
    pix_y = 240;
    #10;
    pix_x = 320;
    pix_y = 239;
    #10;
    pix_x = 320;
    pix_y = 240;
    clk = 0;
    direction = 4'b0010;
    snake_head_x_next = 320;*/
end


/*always @(posedge clk) begin
    snake_head_x_next = snake_head_x_next + 1;
    case(direction)
        //4'b0001 : snake_head_x = (((snake_head_x_next - 2) <= pix_x) && (pix_x <= snake_head_x_next)); // up
        4'b0010 : snake_head_x = (((snake_head_x_next - 2) <= pix_x) && (pix_x <= snake_head_x_next)); // right
        //4'b0100 : snake_head_x = (((snake_head_x_next - 2) <= pix_x) && (pix_x <= snake_head_x_next)); // down
        4'b1000 : snake_head_x = (((snake_head_x_next) <= pix_x) && (pix_x <= (snake_head_x_next + 2))); // left
        default : snake_head_x = snake_head_x;
    endcase
    //for (pix_x = MIN_X; pix_x < MAX_X; pix_x = pix_x + 1) begin
    //for (pix_y = MIN_Y; pix_y < MAX_Y; pix_y = pix_y + 1) begin
    //if (graph_rgb == 3'b010) begin
    //    $display("snake", pix_x, pix_y);
    //end
    //else if (graph_rgb == 3'b100) begin
    //end
    //else if (graph_rgb == 3'b001) begin
    //    $display("fruit", pix_x, pix_y);
    //end
    //end
    //end
    //pix_x  = pix_x + 1;
    //if (pix_x > MAX_X) begin
    //    pix_x = MAX_X;
    //end
end*/
   
   
// screen size (64x64)
localparam MAX_X = 352;
localparam MIN_X = 288;
    
localparam MAX_Y = 272;
localparam MIN_Y = 208;

// Location of fruit
reg  [9:0] FRUIT_X_REG, FRUIT_Y_REG;
reg [9:0] FRUIT_X_NEXT, FRUIT_Y_NEXT;

// screen refresh time, based on beginning and end of screen
wire refr_tick;

// snake positions
wire [9:0] snake_head_x, snake_head_y, snake_tail_x, snake_tail_y; // current snake head/tail position
wire [9:0] snake_head_x_next, snake_head_y_next, snake_tail_x_next, snake_tail_y_next; // next snake head/tail positions
reg [9:0] snake_head_x_reg = 320, snake_head_y_reg = 240, snake_tail_x_reg = 318, snake_tail_y_reg = 240; // track snake position
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
reg snake_head_x_delta_next, snake_head_y_delta_next, snake_tail_x_delta_next, snake_tail_y_delta_next; // next snake head/tail velocity
reg snake_head_x_delta_reg = SNAKE_PV, snake_head_y_delta_reg = SNAKE_0V; // current snake head velocity
reg snake_tail_x_delta_reg = SNAKE_PV, snake_tail_y_delta_reg = SNAKE_0V; // current snake tail velocity

// check if game has ended
integer game_end = 0;

// supports up to 32 turns
reg [4:0] turns = 5'b00000;
// save each turn as 10 bits by saving head location whenever a turn happens
// shift by 10 * (turns - 1) for each turn
reg [319:0] turn_x;
reg [319:0] turn_y;

// for checking snake_on, check if parts, head, and tail are on
reg [31:0] snake_parts; // parts = body part, returns 1 whenever a part exists
reg snake_head_on;
reg snake_tail_on;
reg fruit_on; // check if fruit is on
reg snake_on;

// int i for loop
integer i = 1;
// temporary for checking turns. takes calues from turn_x and turn_y
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
        turn_x <= 0;
        turn_y <= 0;
        turns1x <= 0;
        turns1y <= 0;
        turns2x <= 0;
        turns2y <= 0;
        turn_x_temp <= 0;
        turn_y_temp <= 0;
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

assign refr_tick = (pix_y==MAX_Y) && (pix_x==MAX_X); 


// turn on snake and appple if applicable

always@(posedge clk) begin
// check turns
// turns being 0 means snake is a straight line like -------
// in short: just check between head and tail 
if (turns == 5'b00000) begin
    case(direction)
        4'b0001 : snake_head_on = ((snake_tail_y <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x)); // up
        4'b0010 : snake_head_on = ((snake_tail_x <= pix_x) && (pix_x <= snake_head_x) && (pix_y == snake_head_y)); // right
        4'b0100 : snake_head_on = ((snake_head_y <= pix_y) && (pix_y <= snake_tail_y) && (pix_x == snake_head_x)); // down
        4'b1000 : snake_head_on = ((snake_head_x <= pix_x) && (pix_x <= snake_tail_x) && (pix_y == snake_head_y)); // left
        default : snake_head_on = snake_head_on;
    endcase
end

// otherwise
// snake is like
//  |- - -
//  |
//  |
// therefore: snake on is between head and first turn, then first turn and tail
else if (turns == 5'b00001) begin
    //fruit_on = ((apple_x == pix_x) && (apple_y == pix_y));
    // check if snake tail is above, below, right, or left of turn, then fill accordingly
    if (snake_tail_x < turn_x[9:0]) begin
        snake_tail_on = (((snake_tail_x <= pix_x) && (pix_x <= turn_x[9:0])) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_x > turn_x[9:0]) begin
        snake_tail_on = (((turn_x[9:0] <= pix_x) && (pix_x <= snake_tail_x)) && (pix_y == snake_tail_y));
    end
    else if (snake_tail_y < turn_y[9:0]) begin
        snake_tail_on = (((snake_tail_y <= pix_y) && (pix_y <= turn_y[9:0])) && (pix_x == snake_tail_x));
    end
    else if (snake_tail_y > turn_y[9:0]) begin
        snake_tail_on = (((turn_y[9:0] <= pix_y) && (pix_y <= snake_tail_y)) && (pix_x == snake_tail_x));
    end
    // then check direction head is going, and fill behind it to turn
    case(direction)
        4'b0001 : snake_head_on = (((turn_y[9:0] <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x))); // up
        4'b0010 : snake_head_on = (((turn_x[9:0] <= pix_x) && (pix_x <= snake_head_x) && (pix_y == snake_head_y))); // right
        4'b0100 : snake_head_on = (((snake_head_y <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_head_x))); // down
        4'b1000 : snake_head_on = (((snake_head_x <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_y == snake_head_y))); // left
        default : snake_head_on = snake_head_on;
    endcase
    //snake_on = snake_head_on || snake_tail_on;
    end
else if (turns > 5'b00001) begin
    //fruit_on = (apple_x <= pix_x) && (apple_y <= pix_y);
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
                snake_parts[i - 1] = ((turns1y <= pix_y) && (pix_x <= turns2y) && (pix_x == turns1x));
            end
        end
        // then check head cases
            // note: fill in BOTH X AND Y. CHECK IF X/Y VALUE SAME THEN CHECK IF PIX IS BETWEEN Y/X
            // use OR for snake_on. we are not filling in a square of snake. they are individual lines
            // in short it is checking OR for body parts. it is a SOP.
            // ((snake_tail_y <= pix_y) && (pix_y <= turn_y[i]) && (snake_tail_x == turn[x])) || etc.
            //i = turns + 1;
        end
        case(direction)
        4'b0001 : snake_head_on = (((turn_y[9:0] <= pix_y) && (pix_y <= snake_head_y) && (pix_x == snake_head_x))); // up
        4'b0010 : snake_head_on = (((turn_x[9:0] <= pix_x) && (pix_x <= snake_head_x) && (pix_y == snake_head_y))); // right
        4'b0100 : snake_head_on = (((snake_head_y <= pix_y) && (pix_y <= turn_y[9:0]) && (pix_x == snake_head_x))); // down
        4'b1000 : snake_head_on = (((snake_head_x <= pix_x) && (pix_x <= turn_x[9:0]) && (pix_y == snake_head_y))); // left
        default : snake_head_on = snake_head_on;
    endcase
    // check tail cases. turns2 should be updated to the last turn case at this point
    if (snake_tail_x < turns2x) begin
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
    always @(posedge clk, posedge eaten) begin
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
        
        // check if up button is pressed and the current direction is not vertical
        if (btn[0] && ~direction[0] && ~direction[2]) begin
        // turn upward, make y movement positive and no x movement
        direction = 4'b0001;
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_PV;
        // add a turn, set turn location to turn list
        turn_x = turn_x | (snake_head_x_reg << (10 * turns));
        turn_y = turn_y | (snake_head_y_reg << (10 * turns));
        turns = turns + 5'b00001;
        end
    else if (btn[1] && ~direction[1] && ~direction[3]) begin
        direction = 4'b0010;
        snake_head_x_delta_next = SNAKE_PV;
        snake_head_y_delta_next = SNAKE_0V;
        turn_x = turn_x | (snake_head_x << (10 * turns));
        turn_y = turn_y | (snake_head_y << (10 * turns));
        turns = turns + 5'b00001;
        end
    else if (btn[2] && ~direction[2] && ~direction[0]) begin
        direction = 4'b0100;
        snake_head_x_delta_next = SNAKE_0V;
        snake_head_y_delta_next = SNAKE_NV;
        turn_x = turn_x | (snake_head_x << (10 * turns));
        turn_y = turn_y | (snake_head_y << (10 * turns));
        turns = turns + 5'b00001;
        end
    else if (btn[3] && ~direction[3] && ~direction[1]) begin
        direction = 4'b1000;
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
        // no turns means tail velociy is same as head velocity
        snake_tail_x_delta_next = snake_head_x_delta_next;
        snake_tail_y_delta_next = snake_head_y_delta_next;
    end
    else begin
        // stores latest turn
        turn_x_temp = {turn_x[turns*10-1],turn_x[turns* 10-2],turn_x[turns*10-3],turn_x[turns*10-4],turn_x[turns*10-5],turn_x[turns*10-6],turn_x[turns*10-7],turn_x[turns*10-8],turn_x[turns*10-9],turn_x[turns*10-10]};
        turn_y_temp = {turn_y[turns*10-1],turn_y[turns* 10-2],turn_y[turns*10-3],turn_y[turns*10-4],turn_y[turns*10-5],turn_y[turns*10-6],turn_y[turns*10-7],turn_y[turns*10-8],turn_y[turns*10-9],turn_y[turns*10-10]};
        // if the snake tail reaches a turn: turn remove a turn and clear the spot where the turn was
        if ((snake_tail_x_reg == turn_x_temp) && (snake_tail_y_reg == turn_y_temp)) begin
            turns = turns - 5'b00001;
            turn_x = turn_x & (10'b0 << (turns * 10));
            turn_y = turn_y & (10'b0 << (turns * 10));
        end else
        if (snake_tail_x < turn_x_temp) begin
            snake_tail_x_delta_next = SNAKE_PV;
            snake_tail_y_delta_next = SNAKE_0V;
        end
        else if (snake_tail_x > turn_x_temp) begin
            snake_tail_x_delta_next = SNAKE_NV;
            snake_tail_y_delta_next = SNAKE_0V;
        end
        else if (snake_tail_y < turn_y_temp) begin
            snake_tail_x_delta_next = SNAKE_0V;
            snake_tail_y_delta_next = SNAKE_PV;
        end
        else if (snake_tail_y > turn_y_temp) begin
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

// so THIS runs...
always @* begin
    //snake_head_x_reg = 320;
    //snake_head_y_reg = 240;
    //snake_head_on = ((snake_head_x_reg == pix_x) && (snake_head_y_reg == pix_y));
    snake_on = (snake_head_on || snake_tail_on || snake_parts[31] || snake_parts[30] || snake_parts[29] || snake_parts[28] || snake_parts[26] || snake_parts[25] || snake_parts[24] || snake_parts[23] || snake_parts[22] || snake_parts[21] || snake_parts[20] || snake_parts[19] || snake_parts[18] || snake_parts[17] || snake_parts[16] || snake_parts[15] || snake_parts[14] || snake_parts[13] || snake_parts[12] || snake_parts[11] || snake_parts[10] || snake_parts[9] || snake_parts[8] || snake_parts[7] || snake_parts[6] || snake_parts[5] || snake_parts[4] || snake_parts[3] || snake_parts[2] || snake_parts[1] || snake_parts[0]);
    fruit_on = ((apple_x == pix_x) && (apple_y == pix_y));
    if (~video_on) begin
        graph_rgb = 3'b000; // off
    end
    else if (snake_on) begin
        graph_rgb = 3'b010; // green?
    end
    else if (fruit_on) begin
        graph_rgb = 3'b001; // red
    end
    else if (border_on) begin
        graph_rgb = border_RGB;
    end
    else begin
        graph_rgb = 3'b100; // blue
    end
end

initial begin
    btn = 4'b0001;
    #20;
    btn = 4'b0010;
    eaten = 1;
    #5;
    eaten = 0;
    #10;
    btn = 4'b0100;
    #10;
    btn = 4'b1000;
    #20;
end

   
endmodule
