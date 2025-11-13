module adder_clk (
    input logic clk,
    input logic rst,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [8:0] y
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) y <= 0;
        else     y <= a + b;
    end
endmodule
