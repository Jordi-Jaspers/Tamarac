module controller(clock,reset,knob,button,rsw, wmar,rmem ,wmem,wpc,rpc,wacc,racc,wir,rir,warg,alucntl,wbuf,
rbuf,acc,opc,run,mpc,single_step_pulse);
`include "tamarac.h"

input	clock;
input		reset; 
input	[ 1:0] knob;
input		button; 
input [15:0] acc;
input [2:0]opc;

input single_step_pulse;
output reg rsw, wmar,rmem ,wmem,wpc,rpc, wacc, racc,wir,rir,warg,wbuf,rbuf;
output reg [1:0] alucntl;
output run;
output [4:0] mpc; 

reg idle;
assign run = !idle;

reg [4:0] mpc; // microprogram counter

always @(posedge clock) begin 

if (reset) begin
mpc <= 0; end 

else begin
if (single_step_pulse) case (mpc)
00: if (button) mpc <= 1;
01: case (knob) // mpc <= knob + 2; 
KNOB_LOAD_PC: mpc <= 2; 
KNOB_LOAD_AC: mpc <= 3; 
KNOB_STORE:	mpc <= 4; 
KNOB_RUN:	mpc <= 5;
endcase 
02: mpc <= 0;
03: mpc <= 0;
04: mpc <= 7;
05: mpc <= button ? 0 : 6;
06: mpc <= 8;
07: mpc <= 0;
08: mpc <= 9;
09: case (opc) // mpc <= opc + 10; 
OPC_HLT: mpc <= 10; 
OPC_JMP: mpc <= 11; 
OPC_JZR: mpc <= 12; 
OPC_ADD: mpc <= 13; 
OPC_SUB: mpc <= 14; 
OPC_LDA: mpc <= 15; 
OPC_STA: mpc <= 16; 
OPC_NOP: mpc <= 17;
endcase 
10: mpc <= 0;
11: mpc <= 5;
12: mpc <= (acc == 0) ? 11 : 17;
13: mpc <= 19;
14: mpc <= 22;
15: mpc <= 24;
16: mpc <= 25;
17: mpc <= 18;
18: mpc <= 5;
19: mpc <= 20;
20: mpc <= 21;
21: mpc <= 17;
22: mpc <= 23;
23: mpc <= 21;
24: mpc <= 17;
25: mpc <= 17;
default: mpc <= 0; endcase
end
end



//
// microprogram control signal decode
//
// databus actief zetten
always @(mpc) begin
// default values for control signals is "0"
rsw = 0; wmar = 0; rmem = 0; wmem = 0; wpc = 0; rpc = 0; idle = 0;
wacc = 0; racc = 0; wir = 0; rir = 0; warg = 0; wbuf = 0; rbuf = 0; alucntl = ALU_NUL;
case(mpc)
00: begin idle = 1; end
02: begin rsw = 1;	wpc = 1;	end
03: begin rsw = 1;	wacc = 1; end
04: begin rpc = 1;	wmar = 1; end
05: begin rpc = 1;	wmar = 1; end
07: begin racc = 1; wmem = 1; end
08: begin rmem = 1; wir = 1;	end
09: begin rir = 1;	wmar = 1; end
11: begin rir = 1;	wpc = 1;	end
13: begin racc = 1; warg = 1; end
14: begin racc = 1; warg = 1; end
17: begin rpc = 1;	wbuf = 1; alucntl = ALU_INC; end 
18: begin rbuf = 1; wpc = 1;	end
20: begin rmem = 1;	wbuf = 1; alucntl = ALU_ADD; end 
21: begin rbuf = 1; wacc = 1; end
23: begin rmem = 1; wbuf = 1; alucntl = ALU_SUB; end 
24: begin rmem = 1; wacc = 1; end
25: begin racc = 1; wmem = 1; end 
endcase
end

endmodule