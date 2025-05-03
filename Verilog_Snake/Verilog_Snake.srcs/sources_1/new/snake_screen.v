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
        
    // Want fruit in middle of screen ~239 - ~339
    localparam FRUIT_X = 320;
    localparam FRUIT_Y = 240;
    
    // Active area of the screen
    localparam MAX_X = 352;
    localparam MIN_X = 288;
    
    localparam MAX_Y = 272;
    localparam MIN_Y = 208;
    
    //---------------------------------- BORDERS -------------------------------------
    localparam LEFT_BORDER_L  = MIN_X - 4;
    localparam LEFT_BORDER_R  = MIN_X - 2;
    
    localparam RIGHT_BORDER_L = MAX_X + 2;
    localparam RIGHT_BORDER_R = MAX_X + 4;
    
    localparam TOP_BORDER_T   = MAX_Y + 4; 
    localparam TOP_BORDER_B   = MAX_Y + 2;
    
    localparam BOT_BORDER_T   = MIN_Y - 2;
    localparam BOT_BORDER_B   = MIN_Y - 4;
    
    assign border_on = (LEFT_BORDER_L  <= x_val) && (x_val <= LEFT_BORDER_R)  &&
                       (RIGHT_BORDER_L <= x_val) && (x_val <= RIGHT_BORDER_R) &&
                       (TOP_BORDER_T   <= y_val) && (y_val <= TOP_BORDER_B)   &&
                       (BOT_BORDER_T   <= y_val) && (y_val <= BOT_BORDER_B);
    assign border_RGB = 3'b111; // WHITE
    
    //---------------------------------- SNAKE ---------------------------------------
    
    //---------------------------------- FRUIT ---------------------------------------
    // Fruit is 1 pix
    assign sq_fruit_on = (FRUIT_X <= x_val) && (FRUIT_Y <= y_val);
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
