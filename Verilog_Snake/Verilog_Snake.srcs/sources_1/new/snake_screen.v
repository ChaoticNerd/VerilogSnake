`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho, Hanna Estrada, Justin Narciso
// 
// Create Date: 04/03/2025 03:03:10 AM
// Design Name: Snake Screen
// Module Name: snake_screen
// Project Name: Verilog Snake
// Target Devices: NexysA7-100T
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module snake_screen(
    input wire display,             // Display barriers/snake/fruit or blank screen
    input wire [9:0] x_val, y_val,  // X and Y coordinate values for positioning
    output reg [2:0] screen_RGB     // Setting colors to specific components on screen
    );
    
    wire border_on, sq_fruit_on, rd_fruit_on;
    wire [2:0] border_RGB, fruit_rgb;
    
    localparam FRUIT_SIZE = 4;
    
    // Want fruit in middle of screen ~239 - ~339
    localparam FRUIT_L = 339;                       // Left part of fruit
    localparam FRUIT_R = FRUIT_L + FRUIT_SIZE - 1;  // Right part of fruit (-1 since 339 is the first pixel)
    
    localparam FRUIT_T = 239;                       // Top of Fruit
    localparam FRUIT_B = FRUIT_T + FRUIT_SIZE -1;   // Bot of fruit (-1 since it starts at 239)
    
    localparam MAX_HEIGHT = 640;    // CAN CHANGE THIS, would need to change x_val and y_val
    localparam MAX_WIDTH  = 480;
    
    //---------------------------------- BORDERS -------------------------------------
    localparam LEFT_BORDER_L  = MAX_WIDTH;
    localparam LEFT_BORDER_R  = MAX_WIDTH - 2;
    
    localparam RIGHT_BORDER_L = 2;
    localparam RIGHT_BORDER_R = 0;
    
    localparam TOP_BORDER_T   = MAX_HEIGHT - 16; // 16 is space for text
    localparam TOP_BORDER_B   = MAX_HEIGHT - 2 - 16;
    
    localparam BOT_BORDER_T   = 2;
    localparam BOT_BORDER_B   = 0;
    
    assign border_on = (LEFT_BORDER_L  <= x_val) && (x_val <= LEFT_BORDER_R)  &&
                       (RIGHT_BORDER_L <= x_val) && (x_val <= RIGHT_BORDER_R) &&
                       (TOP_BORDER_T   <= y_val) && (y_val <= TOP_BORDER_B)   &&
                       (BOT_BORDER_T   <= y_val) && (y_val <= BOT_BORDER_B);
    assign border_RGB = 3'b111; // WHITE
    
    //---------------------------------- SNAKE ---------------------------------------
    
    //---------------------------------- FRUIT ---------------------------------------
    // Fruit is 4x4 
    assign sq_fruit_on = (FRUIT_L <= x_val) && (x_val <= FRUIT_R)&&
                         (FRUIT_T <= y_val) && (y_val <= FRUIT_B);
    assign fruit_rgb = 3'b100; // RED
    //------------------------------- RGB MULTIPLEXING ----------------------------------
    always @*
        if(~display)
            screen_RGB = 3'b000; // BLACK
        else
            if(border_on)
                screen_RGB = border_RGB;
            else if(sq_fruit_on)
                screen_RGB = fruit_rgb;
            // PUT OTHER STUFF LIKE SNAKE HERE TOO
            else
                screen_RGB = 3'b010; // GREEN      
endmodule
