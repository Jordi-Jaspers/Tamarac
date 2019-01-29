module mem(clock, reset, data_in, address, write, data_out);
input clock, reset; 
input [15:0] data_in;
input [12:0] address; 
input write; 
output[15:0] data_out;

reg [15:0] memory [0:8191];
assign data_out = memory[address];
always @(posedge clock)
	if (write) memory[address] <= data_in; 
endmodule
