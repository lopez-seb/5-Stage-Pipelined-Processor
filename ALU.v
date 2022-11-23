`timescale 1ns / 1ps
                                    
//////////////////////////////////////
//      A R I T H M E T I C         //
//          L O G I C               //
//           U N I T                //
//                                  //
//                                  //
//   STRICTLY designed for the      // 
//      single cycle processor      //
//////////////////////////////////////

module ALU#(
        parameter DWL = 32
    )(
    input signed [DWL-1:0] R1, R2,
    input [4:0] shamt,
    input [2:0] sel,
    output reg zero_flg,
    output reg signed [DWL-1:0] ADO
    );
    
//  initial values for ADOputs
initial zero_flg = 0;
initial ADO = 0;

//logic
always @* begin
    zero_flg = 0;
    case(sel)
        3'b010 : ADO = R1 + R2;
        3'b110 : ADO = R1 - R2;
        3'b000 : ADO = R1 & R2;
        3'b001 : ADO = R1 | R2;
        3'b111 : ADO = R2 << shamt;     //  sll : operates on R2!
        3'b011 : ADO = R2 << R1;        //  sllv
        3'b100 : ADO = R2 >>> R1;       //  srav
        default : ADO =  R1;            // ensures the zero flg isnt triggered for null op-code
    endcase
    if(ADO == 0) zero_flg <=1;
    else zero_flg <=0;
end
endmodule