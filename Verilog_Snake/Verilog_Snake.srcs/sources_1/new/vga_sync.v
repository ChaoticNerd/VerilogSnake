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
    input clk,
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
    output reg [9:0] CounterX,
    output reg [9:0] CounterY,
    output reg clk_out
  );
    reg vga_HS, vga_VS;
    wire reset;
    wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
    wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480

    clk_dvdr clkdiv(.clk_in(clk), .rst(reset), .clk_div(clk_div));
    
    always @(posedge clk_out)
    if (CounterXmaxed)
      CounterX <= 0;
    else
      CounterX <= CounterX + 1;

    always @(posedge clk_out)
    begin
      if (CounterXmaxed)
      begin
        if(CounterYmaxed)
          CounterY <= 0;
        else
          CounterY <= CounterY + 1;
      end
    end

    always @(posedge clk_out)
    begin
      vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
      vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
    end

    always @(posedge clk)
    begin
        inDisplayArea <= (CounterX < 640) && (CounterY < 480);
    end

    assign vga_h_sync = ~vga_HS;
    assign vga_v_sync = ~vga_VS;

endmodule