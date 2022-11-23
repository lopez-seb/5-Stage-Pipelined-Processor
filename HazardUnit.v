`timescale 1ns / 1ps
                                    //
//////////////////////////////////////
//      H A Z A R D   U N I T       //
//                                  //
//  for the pipelined processor     //
//////////////////////////////////////

module HazardUnit(
    // FETCH
        output reg stall,
    // DECODE
        input BranchD, Jump,
        output reg ForwardAD, ForwardBD,
        input [4:0] RsD,RtD,
        output reg Flush,
    // EXECUTE      
        input [4:0] RsE, RtE, RFAE,
        output reg [1:0] ForwardAE, ForwardBE,
        input MtoRFSelE, RFWEE,
    // MEM      
        input [4:0] RFAM,
        input RFWEM, MtoRFSelM, 
    // WRITE BACK    
        input [4:0] RFAW,
        input RFWEW  
    );
reg LWstall, BRstall;  
//initial LWstall = 1'b0;
//initial BRstall = 1'b0; 
//initial stall = 1'b0;

always @* begin 
//forwarding from M/W to EX-A
    if((RsE!=0) & RFWEM & (RsE==RFAM)) ForwardAE = 2'b10;
    else if ((RsE!=0) & RFWEW & (RsE==RFAW)) ForwardAE = 2'b01;
    else ForwardAE = 2'b00;
//forwarding from M/W to EX-B
    if((RtE!=0) & RFWEM & (RtE==RFAM)) ForwardBE = 2'b10;
    else if ((RtE!=0) & RFWEW & (RtE==RFAW)) ForwardBE = 2'b01;
    else ForwardBE = 2'b00;
//LW-STALLING
    LWstall=(MtoRFSelE & ((RtE==RsD) | (RtE==RtD)));
// HAZARDS
    ForwardAD = ((RsD!=0) & (RsD==RFAM) & RFWEM);
    ForwardBD = ((RtD!=0) & (RtD==RFAM) & RFWEM);
//BRANCH-STALLING
    BRstall = (((RsD==RFAE | RtD==RFAE)& BranchD & RFWEE) | ((RsD==RFAM | RtD==RFAM) & BranchD & MtoRFSelM));   
    stall = BRstall | LWstall;
    
    Flush = stall | Jump;      
end     
endmodule
