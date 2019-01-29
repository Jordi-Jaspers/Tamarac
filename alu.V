module alu(in1, in2, mode, out);

parameter ALU_NUL = 0; 
parameter ALU_INC = 1;
parameter ALU_SUB = 2; 
parameter ALU_ADD = 3;

input	[15:0] in1;
input	[15:0] in2;
input	[1:0] mode;
output [15:0] out;

reg [15:0] out;

always @(mode or in1 or in2) 
case (mode)
ALU_NUL :	out	=	0;	
ALU_INC :	out	=	in2	+	1;
ALU_SUB :	out	=	in1	-	in2;
ALU_ADD :	out	=	in1	+	in2;
default:	out	=	0;		
endcase 
endmodule
