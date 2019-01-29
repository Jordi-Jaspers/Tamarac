module datapath(clock, reset, switches, alucntl, 
rsw, wmar, rmem, wmem, wpc, rpc, wacc, racc, wir, rir, warg, wbuf, rbuf, opc, pc, acc, leds);
`include "tamarac.h"

input		clock, reset;
input	[15:0] switches;
input [1:0] alucntl; 
input	rsw, wmar, rmem, wmem, wpc, rpc, wacc, racc, wir, rir, warg, wbuf, rbuf;
output	[2:0] opc;
output [12:0] pc;
output [15:0] acc;
output [15:0] leds;

reg	[2:0] opc;
reg [12:0] pc; // Instruction register reg [12:0]
reg [15:0] acc;
reg [15:0] leds;
reg [15:0] ir;	 // Instruction register 
reg [12:0] mar;	// memory address register
reg [15:0] arg;	// argument register for ALU input 
reg [15:0] bufr;	// buffer register for ALU output

reg	[15:0] databus;
wire [15:0] aluout;
wire [15:0] data_wr, data_rd, ram_rd; 
wire wled;
wire zero;

mem ram(.clock(clock), .reset(reset), .data_in(databus),.address(mar),.write(wmem),.data_out(ram_rd));
// Memory and Memory Mapped I/O separation
// [0..8189] : RAM Memory
// [8190]	: GPIO Leds[15:0]
// [8191] :	: GPIO Switches[15:0] 
assign wled = (mar == 8190) & wmem;
assign data_rd = (mar == 8191) ? switches : ram_rd;

alu alu1(.in1(arg),.in2(databus),.mode(alucntl),.out(aluout)); 
always @* opc = ir[15:13];

always @(posedge clock)
if (reset)	bufr <= 0;
else if (wbuf) bufr <= aluout;

always @(rsw, rmem, rpc, racc, rir, rbuf, switches, data_rd, pc, acc, ir, bufr)
begin 
if	(rsw)	databus = switches;  //  data wordt in de databus ingelezen
else if (rmem) databus = data_rd; 
else if (rpc)	databus = {3'b0, pc};
else if (racc) databus = acc;
else if (rir) databus = ir;
else if (rbuf) databus = bufr;
else	databus = 0; end

always @(posedge clock) if (reset) begin
mar	<= 0;
pc	<= 0;
acc	<= 0;
ir	<= 0;
arg	<= 0;
leds <= 0; 

end else begin // data uit
if (wmar) mar <= databus[12:0]; 
if (wpc)  pc  <= databus[12:0]; 
if (wacc) acc  <= databus;
if (wir) ir <= databus;
if (warg) arg <= databus;
if (wled) leds <= databus; 
end	
endmodule
 
