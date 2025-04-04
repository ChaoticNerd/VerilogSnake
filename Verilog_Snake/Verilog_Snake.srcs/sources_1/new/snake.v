`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 11:04:58 PM
// Design Name: 
// Module Name: snake
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


module snake(
    input [5:0] snake_len,
    output reg [63:0] snake
    );
reg [63:0] snake_bits;
snake_decoder decoder (.address(snake_len), .out(snake_bits));
integer i;

// to do: how to update snake_len?
// also what would snake connect to in main file....
// maybe put fruit update in main file?
// when fruit = 1, it updates snake length, which updates in this file
// then at the end of if statement, fruit = 0 again and waits until fruit = 1 to trigger length update

always@(*) begin
    snake = snake | snake_bits; // updates length of snake
    // as in 0011 | 0010 stays 0011, then 0011 | 0100 becomes 0111
    // i feel like this would lead to some fucked up thing in the main file that checks if snake[i] = 1
    // it CAN be done pretty easy with a loop. hm.
    
    // i was thinking if it's 1, then it like. updates the snake tiles or smthn. idk.
end

endmodule
