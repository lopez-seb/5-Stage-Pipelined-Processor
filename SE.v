`timescale 1ns / 1ps
                                    
//////////////////////////////////////
//          S I G N                 //
//      E X T E N D E R             //
//                                  //
//  sign extension unit designed    //
//  for the single cycle processor  //
//////////////////////////////////////

module SE#(
        parameter HWL = 16,
        parameter WL = 32
    )(
        input signed [HWL-1:0]  Imm,
        output reg signed [WL-1:0]  SImm
    );
    
reg [WL-1:0] temp;
integer x;
always @* begin
SImm <= Imm;
end
endmodule