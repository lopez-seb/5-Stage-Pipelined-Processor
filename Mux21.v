`timescale 1ns / 1ps
                                    //
//////////////////////////////////////
//      2   T O   1  M U X          //
//                                  //
//  Designed for the single cycle   //
//          processor               //
//////////////////////////////////////                                     

module Mux21#(
    parameter WL = 32
        )(
        input [WL-1:0] I0, I1,
        input sel,
        output reg [WL-1:0] dout 
    );
    
always @* begin
    case (sel)
        0: dout = I0;
        1: dout = I1;
    endcase    
end    
endmodule