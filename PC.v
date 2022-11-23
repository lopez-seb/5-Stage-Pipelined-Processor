`timescale 1ns / 1ps
                                    
//////////////////////////////////////
//      P R O G R A M               //
//      C O U N T E R               //
//////////////////////////////////////

module PC#  (
        parameter WL = 32
            )
    (
        input CLK, RST, stall,
        input [WL-1:0] PC_,
        output reg  [WL-1:0] PC
    );
//initial outputo value
initial PC = 0;
    
always @(posedge CLK)begin
    if (RST) PC <= 0;
    else if(stall)PC <= PC;
    else if (PC_ > 0) PC <= PC_;
   // else PC =0;
end
endmodule