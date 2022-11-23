`timescale 1ns / 1ps



module TB_PipeJump(

    );
reg CLK, RST;
    
Pipe_Jump PL1    (
        .CLK(CLK),
        .RST(RST)
                ); 
//initializing CLK
 parameter HalfClkPeriod = 5;
 integer ClkPeriod = HalfClkPeriod*2;
 initial begin :ClockGenerator
 CLK = 1'b0;
 forever #HalfClkPeriod CLK =~CLK;
 end
                 
initial begin
RST=1;#2;RST=0; 
#1000;
$finish;
end
                 
endmodule
