`timescale 1ns / 1ps

////////////////////////////////////
//      R E G I S T E R 
//          F I L E 
//
//      WRITE FIRST MODE
//      as described in HW 0
///////////////////////////////////

module RegFile#(
        parameter AWL=5,
        parameter DWL=32,
        parameter DEPTH = 2**AWL
    )(
        input   CLK, RFWE,
        input   [AWL-1:0] RFR1, RFR2, RFWA,
        input   [DWL-1:0] RFWD,
        output  [DWL-1:0] RFRD1, RFRD2
    );
    
reg [DWL-1:0] reg_file [0:DEPTH-1];
initial $readmemb ("initreg.mem", reg_file);

//assign RFRD1 = reg_file[RFR1];
//assign RFRD2 = reg_file[RFR2];

//register file in WRITE-FIRST mode
always @(posedge CLK) begin
    if (RFWE) begin
         reg_file[RFWA] <= RFWD;  
    end      
end
assign RFRD1=RFWE ? ((RFWA==RFR1)?RFWD:reg_file[RFR1]):reg_file[RFR1];
assign RFRD2=RFWE ? ((RFWA==RFR2)?RFWD:reg_file[RFR2]):reg_file[RFR2];
endmodule
