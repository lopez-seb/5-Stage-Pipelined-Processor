`timescale 1ns / 1ps
                                    //
//////////////////////////////////////
//          C O N T R O L           //
//              U N I T             //
//                                  //
//  Control Unit for the single     //
//          cycle processor         //
//////////////////////////////////////

module ConUnit(
    input [5:0] Opcode,
    input [5:0] Funct,
    output [2:0] ALUSel,
    output MtoRFSel, DMWE, Branch,
    output ALUInSel, RFDSel, RFWE, Jump
    );
wire [1:0] ALUOp;   
 
//instantiating sub modules
MainDecoder MD1 (
                .Opcode(Opcode),
                .MtoRFSel(MtoRFSel),
                .DMWE(DMWE),
                .Branch(Branch),
                .ALUInSel(ALUInSel),
                .RFDSel(RFDSel),
                .RFWE(RFWE),
                .jump(Jump),
                .ALUOp(ALUOp)
                );
                
ALUDecoder AD1  (
                .Funct(Funct),
                .ALUOp(ALUOp),
                .ALUSel(ALUSel)
                );                    
endmodule