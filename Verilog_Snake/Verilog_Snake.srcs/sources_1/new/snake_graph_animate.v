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

// snake with 20 parts, 10 bits each for location2
// it's y then x
reg [19:0] snake [19:0];
integer length = 5'b00000;
integer j;

reg [3:0] direction = 4'b0010; // bit 0 is up, bit 1 is right, bit 2 is down, bit 3 is left

localparam SNAKE_PV = 1;
localparam SNAKE_0V = 0;
localparam SNAKE_NV = -1;
wire [19:0] snake_next;
integer snake_x_vel, snake_y_vel;
integer snake_x_vel_next, snake_y_vel_next;

// Location of fruit
reg  [9:0] FRUIT_X_REG, FRUIT_Y_REG;
reg [9:0] FRUIT_X_NEXT, FRUIT_Y_NEXT;

wire snake_on, fruit_on, border_on;


always @(posedge clk, posedge reset) begin
    if (reset) begin
        // reset length to 3, reset first 3 parts of snake to consecutive 3 bits
        length = 3;
        snake[0] <= (20'd240 << 10) | 20'd320;
        snake[1] <= (20'd240 << 10) | 20'd319;
        snake[2] <= (20'd240 << 10) | 20'd318;
        for (j = length; j < 20; j = j + 1) begin
            // clear all remaining snake parts
            snake[j] <= 20'b0;
        end
        snake_x_vel <= SNAKE_PV;
        snake_y_vel <= SNAKE_0V;
        FRUIT_X_REG <= 330;
        FRUIT_Y_REG <= 240;
    end
    else begin
        // update length?
        // update all snake parts
        snake[0] <= snake_next;
        for (j = 1; j < 20; j = j + 1) begin
            // clear all remaining snake parts
            if (j < length) begin
                snake[j] <= snake[j + 1];
            end
            else begin
                snake[j] = 20'b0;
            end
        end
        /*snake[1] <= snake[0];
        snake[2] <= snake[1];
        snake[3] <= snake[2];
        snake[4] <= snake[3];
        snake[5] <= snake[4];
        snake[6] <= snake[5];
        snake[7] <= snake[6];
        snake[8] <= snake[7];
        snake[9] <= snake[8];
        snake[10] <= snake[9];
        snake[11] <= snake[10];
        snake[12] <= snake[11];
        snake[13] <= snake[12];
        snake[14] <= snake[13];
        snake[15] <= snake[14];
        snake[16] <= snake[15];
        snake[17] <= snake[16];
        snake[18] <= snake[17];
        snake[19] <= snake[18];*/
        snake_x_vel <= snake_x_vel_next;
        snake_y_vel <= snake_y_vel_next;
    end
end

// (((snake[0][19:10] + snake_y_vel) << 10) | (snake[0][9:0] + snake_x_vel)) : snake[0];
assign snake_next = (clk) ? (((snake[0][19:10] + snake_y_vel) << 10) | (snake[0][9:0] + snake_x_vel)) : snake[0];
// update snake velocity
always @(posedge clk) begin
    if (eaten) begin
        length = length + 1;
        eaten <= !eaten;
        FRUIT_X_REG <= FRUIT_X_REG + 2;
        FRUIT_Y_REG <= FRUIT_Y_REG + 3;
        if(FRUIT_X_REG > MAX_X) FRUIT_X_REG <= FRUIT_X_REG - 20;
        if(FRUIT_Y_REG > MAX_Y) FRUIT_Y_REG <= FRUIT_Y_REG - 40;
    end
    
    if (btn == 4'b0000) begin
        snake_x_vel_next = snake_x_vel;
        snake_y_vel_next = snake_y_vel;
    end
    else begin
    
    if (btn[0] && ~direction[0] && ~direction[2]) begin
        snake_x_vel_next = SNAKE_0V;
        snake_y_vel_next = SNAKE_PV;
    end
    
    else if (btn[1] && ~direction[1] && ~direction[3]) begin
        snake_x_vel_next = SNAKE_PV;
        snake_y_vel_next = SNAKE_0V;
    end
    
    else if (btn[2] && ~direction[0] && ~direction[2]) begin
        snake_x_vel_next = SNAKE_0V;
        snake_y_vel_next = SNAKE_NV;
    end
    
    else if (btn[3] && ~direction[1] && ~direction[3]) begin
        snake_x_vel_next = SNAKE_NV;
        snake_y_vel_next = SNAKE_0V;
    end
    
    end
    
end

//---------------------------------- BORDERS -------------------------------------
    localparam LEFT_BORDER_L  = MIN_X - 4;
    localparam LEFT_BORDER_R  = MIN_X - 2;
    
    localparam RIGHT_BORDER_L = MAX_X + 2;
    localparam RIGHT_BORDER_R = MAX_X + 4;
    
    localparam TOP_BORDER_T   = MAX_Y + 4; 
    localparam TOP_BORDER_B   = MAX_Y + 2;
    
    localparam BOT_BORDER_T   = MIN_Y - 2;
    localparam BOT_BORDER_B   = MIN_Y - 4;


reg [19:0] snake_parts_on;

assign snake_on = snake_parts_on[0] || snake_parts_on[1] || snake_parts_on[2] || snake_parts_on[3] || snake_parts_on[4] ||
                  snake_parts_on[5] || snake_parts_on[6] || snake_parts_on[7] || snake_parts_on[8] || snake_parts_on[9] ||
                  snake_parts_on[10] || snake_parts_on[11] || snake_parts_on[12] || snake_parts_on[13] || snake_parts_on[14] ||
                  snake_parts_on[15] || snake_parts_on[16] || snake_parts_on[17] || snake_parts_on[18] || snake_parts_on[19];
assign fruit_on = ((FRUIT_X_REG == pix_x) && (FRUIT_Y_REG == pix_y));
assign border_on = (((LEFT_BORDER_L  <= pix_x) && (pix_x <= LEFT_BORDER_R) && (BOT_BORDER_B <= pix_y) && (pix_y <= TOP_BORDER_T)) ||
    ((RIGHT_BORDER_L <= pix_x) && (pix_x <= RIGHT_BORDER_R) && (BOT_BORDER_B <= pix_y) && (pix_y <= TOP_BORDER_T)) ||
    ((TOP_BORDER_B   <= pix_y) && (pix_y <= TOP_BORDER_T) && (LEFT_BORDER_L < pix_x) && (pix_x <= RIGHT_BORDER_R)) ||
    ((BOT_BORDER_B   <= pix_y) && (pix_y <= BOT_BORDER_T) && (LEFT_BORDER_L < pix_x) && (pix_x <= RIGHT_BORDER_R)));

always @(*) begin
    for (j = 0; j < 20; j = j + 1) begin
        snake_parts_on[j] = (snake[j] == {pix_y, pix_x});
    end
    //snake_head_x_reg = 320;
    //snake_head_y_reg = 240;
    //snake_head_on = ((snake_head_x_reg == pix_x) && (snake_head_y_reg == pix_y));
        
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