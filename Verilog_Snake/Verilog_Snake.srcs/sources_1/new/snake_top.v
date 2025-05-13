`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Natasha Kho
// 
// Create Date: 05/05/2025 03:56:10 PM
// Design Name: Snake Top Module
// Module Name: snake_top
// Project Name: Verilog Snake
// Target Devices: NexysA7-100T
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module snake_top(
    input clk, reset,
    input [0:3] btn,
    output hsync, vsync,
    output [3:0] red, green, blue
    );
    wire video_on, eaten;
    wire [9:0] pix_x, pix_y;
    wire [4:0] text_on;
    reg [1:0] state_reg, state_next;
    wire [11:0] text_rgb;
    reg [11:0] rgb_next, rgb_reg;
    wire [12:0] rgb;
    integer score = 0;
    integer hi_score = 0;
    
    localparam [1:0]
    title   = 2'b00,
    game    = 2'b01,
    apple   = 2'b10,
    over    = 2'b11;
    
    clk_dvdr clkdiv(.clk_in(clk), .rst(reset), .clk_div(clk_div));
    
    // another variable to connect apple_x and apple_y to snake_graph_animate
    vga_sync vga(.clk(clk), .hSync(hsync), .vSync(vsync), .bright(video_on), 
                .hCount(pix_x), .vCount(pix_y));
//    initial begin 
//        for(i = 0; i < 10000; i = i + 1) begin
//            if(i%2)begin
//                r = 4'b0000;
//                g = 4'b0000;
//                b = 4'b1111;
//            end else begin
//                r = 4'b1111;
//                g = 4'b0000;
//                b = 4'b0000;
//            end
//        end
//    end
    snake_graph_animate snake_graph (.clk(clk_div), .reset(reset), .eaten(eaten), .video_on(video_on),
                                    .btn(btn) , .pix_x(pix_x), .pix_y(pix_y), 
                                    .rgb(rgb));
                                 
    snake_text text(.clk(clk), .pix_x(pix_X), .pix_y(pix_y),.text_on(text_on),.score(score),.hi_score(score), .text_rgb(text_rbg));
    //snake_screen screen (.display(video_on), .x_val(pix_x), .y_val(pix_y), .screen_RGB(graph_rgb));       

    //assign {red,green,blue} = video_on ? rgb[3:0] : 0;
    //snake_text text(.clk(clk_div), .pix_x(pix_X), .pix_y(pix_y),.text_on(text_on), .text_rgb());
    // Connect game output to VGA output
    assign blue      = video_on? rgb[3:0]: 0;
    assign green    = video_on? rgb[7:4]: 0;
    assign red     = video_on? rgb[11:8]: 0;
   
   //FSM Place Holder
    always @(posedge clk, posedge reset)
        if (reset) begin
            state_reg <= title;
            rgb_reg = 12'b00;
        end
        else begin
            state_reg <= state_next;
            rgb_reg <= rgb_next;
        end
    always @* begin
        state_next = state_reg;
        case(state_reg)
            title:
                begin
                score = 12'b0; //reset score to 0
                if (btn!=4'b0000) begin //press any button to start
                    state_next = game;
                end
                else if (reset == 1) begin;// reset the game and hi_scores info
                    hi_score = 0;
                end
                end
            game:
                begin
                    if (btn == 4'b1000)begin //simulated fail, snake died, on BTL L
                        state_next = over; 
                    end
                    else if (btn == 4'b0010) begin // simulated success, aka eat appl,e on BTN R
                        state_next = apple; 
                        score = score + 12'b000000000001; 
                    end
                    else //continued sim no events
                        state_next = game;
                end  
            apple:
                begin
                    state_next = game; //returns back to game
                end
            over:
                begin
                    if (score >= hi_score) begin
                        hi_score = score;
                    end
                    if (btn == 4'b1111)
                        state_next = title;
                    else
                        state_next = over;
                    end 
                endcase
           end
// RGB MANAGMENET

    always @*
        if (~video_on)
            rgb_next = 12'b0000_0000_0000;
        else if(((state_reg == over) && text_on[0] && text_on[1])// hiscoreres, scoreres on over
            || ((state_reg == title) && text_on[0])// hi score on title
            || (state_reg == (game || apple) && text_on[5])) begin // score on game or apple
            rgb_next = text_rgb;
        //else if (graph_on) need to add depend on hanna stuff?
        end
        else if (text_on[4] && (state_reg == (title || game || apple))) begin// logo on game, apple, or title
            rgb_next = text_rgb; 
        end
        else if (text_on[3] && (state_reg == over)) begin // game_over on over
            rgb_next = text_rgb;
        end
        
    assign rgb_vga = rgb_reg;

endmodule
