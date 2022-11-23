`timescale 1ns / 1ps


module MainDecoder(
        input [5:0] Opcode,
        output reg MtoRFSel, DMWE, Branch, ALUInSel,
        output reg RFDSel, RFWE, jump,
        output reg [1:0] ALUOp
    );
//initial MtoRFSel = 1'b0;            /// ADDED THIS
always @* begin
    case(Opcode)
        6'b000000: begin RFWE=1; RFDSel=1; ALUInSel=0; Branch=0; DMWE=0; MtoRFSel=0; ALUOp=2'b10; jump=0; end   //  R-Type Instrucgtion
        6'b100011: begin RFWE=1; RFDSel=0; ALUInSel=1; Branch=0; DMWE=0; MtoRFSel=1; ALUOp=2'b00; jump=0; end   //  lw 
        6'b101011: begin RFWE=0;           ALUInSel=1; Branch=0; DMWE=1;             ALUOp=2'b00; jump=0; end   //  sw
        6'b000100: begin RFWE=0;           ALUInSel=0; Branch=1; DMWE=0;             ALUOp=2'b01; jump=0; end   //  beq
        6'b001010: begin RFWE=1; RFDSel=0; ALUInSel=1; Branch=0; DMWE=0; MtoRFSel=0; ALUOp=2'b11; jump=0; end   //  slti
        6'b001000: begin RFWE=1; RFDSel=0; ALUInSel=1; Branch=0; DMWE=0; MtoRFSel=0; ALUOp=2'b00; jump=0; end   //  addi
        6'b000010: begin RFWE=0;                                 DMWE=0;                          jump=1; end   //  j
    endcase     
end    
endmodule