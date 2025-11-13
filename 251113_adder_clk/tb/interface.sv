
// 1. Interface
interface adder_if(
    input logic clk,
    input logic rst 
);
    logic [7:0] a;
    logic [7:0] b;
    logic [8:0] y;
endinterface //adder_if
