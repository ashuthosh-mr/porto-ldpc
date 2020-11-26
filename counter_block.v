`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.11.2020 12:24:43
// Design Name:
// Module Name: blocking_counter
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


module counter_block(reset,clk,enable,count);
input reset,clk;
input enable;
output reg[12:0]count;

always@(posedge clk or posedge reset)
begin
if(reset) begin

count=13'd0;

end
else if(enable)
begin
count=count+1;
end
else begin
count=count;
end

end
endmodule
