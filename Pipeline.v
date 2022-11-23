`timescale 1ns / 1ps
                                    //
//////////////////////////////////////
//        P I P E L I N E D         //
//                                  //
//        P R O C E S S O R         //
//////////////////////////////////////            

module Pipeline(
        input CLK, RST
    );
//////////////////////////////////////    
//              WIRES               //
//////////////////////////////////////
    //Fetch
wire [31:0] PCw, PCp1F, PCBranchD, PCF, IMw;
    //Decode
wire [31:0]  InstrD, PCp1D, RFo1, RFo2, SImmD, RF1D, RF2D; 
wire RFWED, MtoRFSelD, DMWED, ALUInSelD, RFDSelD, BranchD, PCSelD, Jump, RFFclr, ForwardAD, ForwardBD, EqualD;
wire [2:0] ALUSelD;
wire [4:0] RsD, RtD, RdD, shamtD;
wire [7:0] ConD;
    //Execute
wire [31:0] RF1E, RF2E, SImmE, ALUIn1E, ALUIn2E, ALUOutE, DMdinE;
wire [4:0] RsE, RtE, RdE, shamtE, RFAE; 
wire [7:0] ConE;
    //Mem
wire [31:0] ALUOutM, DMdinM, DMoM;
wire [4:0] RFAM;
wire [2:0] ConM;
    //WB
wire RFWEW;
wire [4:0] RFAW;
wire [31:0] ResultW, DMOutW, ALUOutW;
wire [1:0] ConW;
    //HAZARD
wire Flush, Stall;
wire [1:0] ForwardAE, ForwardBE;    
//////////////////////////////////////    
//          Assignments             //
//////////////////////////////////////
assign RFFclr = Jump | PCSelD;
assign RsD = InstrD[25:21];
assign RtD = InstrD[20:16];
assign RdD = InstrD[15:11]; 
assign shamtD = InstrD[10:6];
assign ConD = {RFWED,MtoRFSelD,DMWED,ALUSelD[2:0],ALUInSelD,RFDSelD};
assign RFWEW = ConW[1];
assign PCSelD = BranchD & EqualD;
assign EqualD = (RF1D==RF2D);
//////////////////////////////////////
//             MODULES              //
//////////////////////////////////////
Mux21   PCS (
        .I0(PCp1F),
        .I1(PCBranchD),
        .sel(PCSelD),
        .dout(PCw)
            ); 

// ANOTHER 2-1 MUX HERE TO SUPPORT JUMP INST

PC  PC  (
    .CLK(CLK),
    .RST(RST),
    .stall(Stall),
    .PC_(PCw),
    .PC(PCF)        
        );

ALU Ainc    (
        .R1(PCF),
        .R2(1),
        .sel(3'b010),
        .ADO(PCp1F)
            );  

InstMem IM  (
        .IMA(PCF),
        .IMRD(IMw)
            );
            
Reg IMFetch (.CLK(CLK), .RST(RFFclr | RST), .EN(!Stall), .in(IMw), .out(InstrD));
Reg PCFetch (.CLK(CLK), .RST(RFFclr | RST), .EN(!Stall), .in(PCp1F), .out(PCp1D)); 
                                    
ConUnit CU (
        .Opcode(InstrD[31:26]),
        .Funct(InstrD[5:0]),
        .ALUSel(ALUSelD),
        .MtoRFSel(MtoRFSelD),
        .DMWE(DMWED),
        .Branch(BranchD),
        .ALUInSel(ALUInSelD),
        .RFDSel(RFDSelD),
        .RFWE(RFWED),
        .Jump(Jump)
            );

RegFile RF  (
        .CLK(CLK),
        .RFWE(RFWEW),
        .RFR1(InstrD[25:21]),
        .RFR2(InstrD[20:16]),
        .RFWA(RFAW),
        .RFWD(ResultW),
        .RFRD1(RFo1),
        .RFRD2(RFo2)
            );

SE  SE  (
        .Imm(InstrD[15:0]),
        .SImm(SImmD)
        ); 

ALU ALUbranch (
        .R1(SImmD),
        .R2(PCp1D),
        .sel(3'b010),
        .ADO(PCBranchD)
            );           
            
Mux21 RFE1  (
        .I0(RFo1),
        .I1(ALUOutM),
        .sel(ForwardAD),
        .dout(RF1D)
            );    
            
Mux21 RFE2  (
        .I0(RFo2),
        .I1(ALUOutM),
        .sel(ForwardBD),
        .dout(RF2D)
            );  
              
//End of Decode Stage            
Reg #(.WL(8)) ConSD (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(ConD), .out(ConE));   
Reg RF1Decode (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(RF1D), .out(RF1E)); 
Reg RF2Decode (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(RF2D), .out(RF2E)); 
Reg #(.WL(5)) RsDecode (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(RsD), .out(RsE));
Reg #(.WL(5)) RtDecode (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(RtD), .out(RtE));
Reg #(.WL(5)) RdDecode (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(RdD), .out(RdE));  
Reg #(.WL(5)) shamtDecode (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(shamtD), .out(shamtE));
Reg RSImmDecode (.CLK(CLK), .EN(1'b1), .RST(Flush | RST), .in(SImmD), .out(SImmE));
//Begin Execute Stage

ALU ALUEx   (
        .R1(ALUIn1E),
        .R2(ALUIn2E),
        .shamt(shamtE),
        .sel(ConE[4:2]),
        //.zero_flg(),
        .ADO(ALUOutE)
            );
            
Mux3to1 ALUSel1E    (
        .I0(RF1E),
        .I1(ResultW),
        .I2(ALUOutM),
        .sel(ForwardAE),
        .dout(ALUIn1E)
                    );
                    
Mux3to1 DMSelE    (
        .I0(RF2E),
        .I1(ResultW),
        .I2(ALUOutM),
        .sel(ForwardBE),
        .dout(DMdinE)
                    );  

Mux21 ALUSel2E  (
        .I0(DMdinE),
        .I1(SImmE),
        .sel(ConE[1]),
        .dout(ALUIn2E)
                );

Mux21 #(.WL(5)) 
    AddSel    (
        .I0(RtE),
        .I1(RdE),
        .sel(ConE[0]),
        .dout(RFAE)
                ); 

//End EXECUTE stage
Reg #(.WL(3)) ConEM (.CLK(CLK), .EN(1'b1), .RST(1'b0 | RST), .in(ConE[7:5]), .out(ConM)); 
Reg ALUExecute (.CLK(CLK), .EN(1'b1), .RST(1'b0 | RST), .in(ALUOutE), .out(ALUOutM)); 
Reg DMinExecute (.CLK(CLK), .EN(1'b1), .RST(1'b0 | RST), .in(DMdinE), .out(DMdinM));
Reg #(.WL(5)) AddressExecute (.CLK(CLK), .EN(1'b1 | RST), .RST(1'b0), .in(RFAE), .out(RFAM)); 
//Begin Mem Stage

DataMem DM  (
        .CLK(CLK),
        .DMA(ALUOutM),
        .DMWD(DMdinM),
        .DMWE(ConM[0]),
        .DMRD(DMoM)
            );

//End MEM stage
Reg #(.WL(2)) ConMW (.CLK(CLK), .EN(1'b1), .RST(1'b0 | RST), .in(ConM[2:1]), .out(ConW[1:0]));
Reg DMMem (.CLK(CLK), .EN(1'b1), .RST(1'b0 | RST), .in(DMoM), .out(DMOutW));
Reg ALUOutMem (.CLK(CLK), .EN(1'b1), .RST(1'b0 | RST), .in(ALUOutM), .out(ALUOutW));
Reg #(.WL(5)) AddressMem (.CLK(CLK), .EN(1'b1), .RST(1'b0 | RST), .in(RFAM), .out(RFAW));
//Begin WRITE BACK  

Mux21 MRFSel    (
        .I0(ALUOutW),
        .I1(DMOutW),
        .sel(ConW[0]),
        .dout(ResultW)
                );
//  HAZARD UNIT CONNECTIONS
HazardUnit  HU  (
        .stall(Stall),
        .BranchD(BranchD),
        .Jump(Jump),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD),
        .RsD(RsD),
        .RtD(RtD),
        .Flush(Flush),
        .RsE(RsE),
        .RtE(RtE),
        .RFAE(RFAE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .MtoRFSelE(ConE[6]),
        .RFWEE(ConE[7]),
        .RFAM(RFAM),
        .RFWEM(ConM[2]),
        .MtoRFSelM(ConW[1]),
        .RFAW(RFAW),
        .RFWEW(RFWEW)
                );
endmodule
