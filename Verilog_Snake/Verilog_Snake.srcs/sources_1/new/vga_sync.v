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

module vga_sync(
    input clk, reset,
    output h_sync,
    output v_sync,
    output reg inDisplayArea,
    output reg [9:0] h_counter,
    output reg [9:0] v_counter,
    output reg clk_out
  );
   
    clk_dvdr clkdiv(.clk_in(clk), .rst(reset), .clk_div(clk_div));
    reg [9:0] h_counter, v_counter;
    
    //640x480@60Hz, got param values out from http://www.tinyvga.com/vga-timing/640x480@60Hz
    // Hsync
    parameter H_DISPLAY = 640;
    parameter H_FRONT = 16;
    parameter H_SYNC = 96;
    parameter H_BACK = 48;
    parameter H_TOTAL = 800;
    
    // Vsync
    parameter V_DISPLAY = 480;
    parameter V_FRONT = 10;
    parameter V_SYNC = 2;
    parameter V_BACK = 33;
    parameter V_TOTAL = 525;
    // assigning sync pulse, when the waveform need to be 0
    assign h_sync = ~(h_counter >= (H_DISPLAY + H_FRONT) && h_counter < (H_DISPLAY + H_FRONT + H_SYNC));             
    assign v_sync = ~(v_counter >= (V_DISPLAY + V_FRONT) && v_counter < (V_DISPLAY + V_FRONT + V_SYNC));
   
    //assigning addressable video, (this would be the visible area) 
     assign display = (h_counter < H_DISPLAY) && (v_counter < V_DISPLAY);
    
    
    assign x = (h_counter < H_DISPLAY) ? h_counter : 10'd0;
    assign y = (v_counter < V_DISPLAY) ? v_counter : 10'd0;
    
    
    always @(posedge clk_div)
    begin
        if (reset) begin
            h_counter <= 0;
            v_counter <= 0;
        end
        else begin
            if (h_counter < H_TOTAL-1)
                h_counter <= h_counter + 10'd1;
            else begin
                h_counter <= 0;
                if (v_counter < V_TOTAL-1)
                    v_counter <= v_counter + 10'd1;
                else
                    v_counter <= 0;
            end
        end
    end

endmodule