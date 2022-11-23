`timescale 1ns / 1ps
////////////////////////////////////////////
//      I N S T R U C T I O N 
//          M E M O R Y 
//
//      Instruction as described in HW 0
//      Changed to receive .mem file for HW1
///////////////////////////////////////////


module InstMem#(
        parameter DWL = 32,
        parameter AWL = 5,
        parameter DEPTH = 2**AWL
    )(
//        input   EN, RST,
        input   [AWL-1:0] IMA,
        output  [DWL-1:0] IMRD
    );

reg [DWL-1:0] rom [0:DEPTH-1];

initial $readmemb("initIMEM.mem", rom);

//always @* begin
//    if (RST)  
//        IMRD <=0;
assign IMRD = rom[IMA];
//end 
endmodule