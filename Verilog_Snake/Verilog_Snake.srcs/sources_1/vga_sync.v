`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Natasha Kho, Hanna Estrada, Justin Narciso
// 
// Create Date: 04/04/2025 04:16:40 PM
// Design Name: VGA
// Module Name: vga_sync
// Project Name: Verilog Snake
// Target Devices: NexysA7-100T
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// :::WIP::: REVIEW TEXTBOOK FOR BETTER UNDERSTANDING :::WIP:::
module vga_sync(
    input wire clk, reset,
    output wire hori_sync, vert_sync, vid_on, p_tick,
    output wire [9:0] pixel_x, pixel_y
    );
    // 640 by 480 screen (CHANGE IF WANT DIFF SCREEN SIZE)
    localparam hori_display = 640; // Horizontal Display Area 
    localparam hori_front   = 48;  // Left border           (given by textbook)
    localparam hori_back    = 16;  // Right border          (given by textbook)
    localparam hori_retrace = 96;  // Horizontal Retrace    (given by textbook)
    
    localparam vert_display = 480; // Vertical Dispaly Area
    localparam vert_front   = 10;
    localparam vert_back    = 33;
    localparam vert_retrace = 2;
    
    // mod-2 counter
    reg mod2_reg;
    wire mod2_next;
    
    // sync counters
    reg [9:0] hori_count_reg, hori_count_next;
    reg [9:0] vert_count_reg, vert_count_next;
    
    // output buffers
    reg vsync_reg, hsync_reg;
    wire vsync_next, hsync_next;
    
    // status signal (check if vert/hori scans are done
    wire h_end, v_end, pixel_tick;
    
    // body
    // registers :::LOOK OVER THIS:::
    always @(posedge clk, posedge reset)
        if(reset) begin // these are default values
            mod2_reg <= 1'b0;
            vert_count_reg <= 0;
            hori_count_reg <= 0;
            vsync_reg <= 1'b0;
            hsync_reg <= 1'b0;
        end else begin
            mod2_reg <= mod2_next;
            vert_count_reg <= vert_count_next;
            hori_count_reg <= hori_count_next;
            vsync_reg <= vsync_next;
            hsync_reg <= hsync_next;
        end
        
    // mod-2 circuit to generate 25MHz enable tick (enables/disables mod2_next?)
        assign mod2_next = ~mod2_reg;
        assign pixel_tick = mod2_reg;
        
   // Status signals (check if done)
   // end = 799
   assign h_end = (hori_count_reg == (hori_display + hori_front + hori_back + hori_retrace -1));
   
   // end = 524
   assign v_end = (vert_count_reg == (vert_display + vert_front + vert_back + vert_retrace -1));
   
   // next-state logic, mod-800 hsync counter
   always @*
        if(pixel_tick) // 25 MHz pulse
            if(h_end)
                hori_count_next = 0;
            else
                hori_count_next = hori_count_reg + 1;
        else
            hori_count_next = hori_count_reg;   
            
   // next-state logic, mod-525 vsync counter
   always @*
        if(pixel_tick & h_end)
            if(v_end)
                vert_count_next = 0;
            else
                vert_count_next = vert_count_reg + 1;
        else
            vert_count_next = vert_count_reg;
            
            
   // Hsync and vsync buffered to avoid glitches
   // hsync_next between 656 and 751
   assign hsync_next = (hori_count_reg >= (hori_display + hori_back) &&
                            hori_count_reg <= (hori_display + hori_back + hori_retrace -1));
   
   // vsync_next between 490 and 491
   assign vsync_next = (vert_count_reg >= (vert_display + vert_back) &&
                        vert_count_reg <= (vert_display + vert_back + vert_retrace - 1));
                        
   // if the scan isn't done (all the way to the edge), then video won't turn on                     
   assign video_on = (hori_count_reg < hori_display) && (vert_count_reg < vert_display);  
   
   // updates outputs
   assign hsync = hsync_reg;
   assign vsync = vsync_reg;
   assign pixel_x = hori_count_reg;
   assign pixel_y = vert_count_reg;
   assign p_tick = pixel_tick;                       
endmodule
