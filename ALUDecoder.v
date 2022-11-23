
`timescale 1ns / 1ps

module ALUDecoder(
        input [5:0] Funct,
        input [1:0] ALUOp,
        output reg [2:0] ALUSel
    );

always @* begin
   case(ALUOp)
        2'b00: ALUSel=3'b010;
        2'b01: ALUSel=3'b110;
        2'b10, 2'b11: begin case(Funct)
                        6'b100000: ALUSel=3'b010;   //  add
                        6'b100010: ALUSel=3'b110;   //  subtract
                        6'b100100: ALUSel=3'b000;   //  and
                        6'b100101: ALUSel=3'b001;   //  or
                        6'b000000: ALUSel=3'b111;   //  sll
                        6'b000100: ALUSel=3'b011;   //  sllv
                        6'b000111: ALUSel=3'b100;   //  srav
                    endcase end
   endcase 
end    
endmodule

