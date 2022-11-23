`timescale 1ns / 1ps

/////////////////////////////////////
//          D A T A 
//        M E M O R Y 
//
//  Synchronous ROM as described 
//          in HW 1
/////////////////////////////////////

module DataMem#(
        parameter DWL=32,
        parameter AWL=9,
        parameter DEPTH= 2**AWL
      )(
        input   CLK,
        input   [AWL-1:0] DMA,  //data memory address
        input   [DWL-1:0] DMWD, //data-memory write data
        input   DMWE,           // data -mem write enable
        output  [DWL-1:0] DMRD  // data-mem data out
      );

//  initializing the rom
reg [DWL-1:0] rom [0:DEPTH-1];

// assigning the data
initial $readmemb ("initdmem.mem", rom);

assign DMRD = rom[DMA];

always @(posedge CLK) begin
    if (DMWE) rom[DMA] <= DMWD;
    
end      
endmodule
