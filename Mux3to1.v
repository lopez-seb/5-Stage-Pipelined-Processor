`timescale 1ns / 1ps



module Mux3to1#(
    parameter WL = 32
        )(
        input [WL-1:0] I0, I1, I2,
        input [1:0] sel,
        output reg [WL-1:0] dout 
    );
    
always @* begin
    case (sel)
        0: dout = I0;
        1: dout = I1;
        2: dout = I2;
    endcase    
end    
endmodule
