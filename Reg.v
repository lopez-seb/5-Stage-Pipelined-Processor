`timescale 1ns / 1ps
                                    
//////////////////////////////////////
//             PARAMETRIC           //
//          MULTI - PURPOSE         //
//              REGISTER            //
//////////////////////////////////////

module Reg#(
            WL = 32
            )(
            input CLK, EN, RST,
            input [WL-1:0] in,
            output reg [WL-1:0] out
            );
initial out = 0;
//      logic
always @(posedge CLK)begin
    if (RST) out <= 0;
    else if(EN) out <= in;
    else out <= out; 
end        
endmodule