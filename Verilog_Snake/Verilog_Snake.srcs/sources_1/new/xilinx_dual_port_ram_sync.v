`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 07:38:59 PM
// Design Name: 
// Module Name: xilinx_dual_port_ram_sync
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


module xilinx_dual_port_ram_sync
   #(
     parameter ADDR_WIDTH = 6,
               DATA_WIDTH = 8
   )
   (
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr_a, addr_b,
    input wire [DATA_WIDTH-1:0] din_a,
    output wire [DATA_WIDTH-1:0] dout_a, dout_b
   );

   // signal declaration
   reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
   reg [ADDR_WIDTH-1:0] addr_a_reg, addr_b_reg;

   // body
   always @(posedge clk)
   begin
      if (we)  // write operation
        ram[addr_a] <= din_a;
      addr_a_reg <= addr_a;
      addr_b_reg <= addr_b;
   end
   // two read operations
   assign dout_a = ram[addr_a_reg];
   assign dout_b = ram[addr_b_reg];

endmodule