module tamarac(iCLK_50, iKEY, iSW,oHEX0_D,oHEX1_D,oHEX2_D,oHEX3_D,
oHEX4_D, oHEX5_D,oHEX6_D,oHEX7_D, oLEDR, oLEDG);
`include "tamarac.h"
//inputs
// clock
input	iCLK_50;
wire clock;
klok kl(reset,iCLK_50,clock);
//keybuttons
input [3:0]iKEY;
wire reset, button, single_step_pulse_toggle;
assign reset = !iKEY[0];

edge_detect e0(clock, reset, !iKEY[1], single_step_pulse_toggle);
edge_detect e1(clock, reset, !iKEY[2], single_step_pulse_button);
edge_detect e2(clock, reset, !iKEY[3], button);

wire single_step_pulse_button,single_step_pulse;
reg state_toggle;

always @(posedge clock or posedge reset)
if (reset) state_toggle = 0; 
else if (single_step_pulse_toggle) 
state_toggle = !state_toggle;

mux mux0(single_step_pulse_button,1'b1,state_toggle,single_step_pulse);


//switches
input [17:0] iSW;
wire [1:0] knob;
wire [15:0] switches;
assign knob = iSW[17:16];
assign switches = iSW[15:0];


//outputs
output [15:0] oLEDR ; 
wire [15:0] leds;
assign oLEDR = leds;

//PROGRAM COUNTER (PC)
output [6:0]oHEX4_D,oHEX5_D ;
dec7seg d4(pc[3:0],oHEX4_D);
dec7seg d5(pc[7:4],oHEX5_D);
wire [12:0] pc;

// ACCUMULATOR (ACC)
wire [15:0] acc;
output [6:0] oHEX0_D,oHEX1_D,oHEX2_D,oHEX3_D;
dec7seg d0(acc[3:0],oHEX0_D);
dec7seg d1(acc[7:4],oHEX1_D);
dec7seg d2(acc[11:8],oHEX2_D);
dec7seg d3(acc[15:12],oHEX3_D);

//MICRO PROGRAM COUNTER (MPC)
output [6:0] oHEX6_D,oHEX7_D;
wire [4:0] mpc;
wire [3:0] seg6,seg7;
dec dec0(mpc,seg6,seg7);
dec7seg d6(seg6,oHEX6_D);
dec7seg d7(seg7,oHEX7_D);


output	[8:8] oLEDG;
wire run;
assign oLEDG[8] = run;

wire rsw, wmar, rmem, wmem, wpc, rpc, wacc, racc, wir, rir, warg, wbuf, rbuf;
wire [1:0] alucntl;
wire [2:0] opc;



controller cont(.clock(clock),
.reset(reset),
.knob(knob),
.button(button),
.rsw(rsw),
.wmar(wmar),
.rmem(rmem),
.wmem(wmem),
.wpc(wpc),
.wir(wir),
.rir(rir),
.warg(warg),
.alucntl(alucntl),
.wbuf(wbuf),
.rbuf(rbuf),
.acc(acc),
.opc(opc),
.run(run),
.mpc(mpc),
.single_step_pulse(single_step_pulse)
);

datapath dp(.clock(clock), .reset(reset),
.switches(switches),
.rsw(rsw),
.wmar(wmar),
.rmem(rmem),
.wmem(wmem),
.wpc(wpc),
.rpc(rpc),
.wacc(wacc),
.racc(racc),
.wir(wir),
.rir(rir),
.warg(warg),
.alucntl(alucntl),
.wbuf(wbuf),
.rbuf(rbuf),
.pc(pc),
.acc(acc),
.opc(opc),
.leds(leds)
);
endmodule
