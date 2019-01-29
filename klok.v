module klok(reset, clock,klok);
output klok;
input reset;
input clock;
reg [30:0] counter;
reg klok;
always @(posedge clock)
if (reset) begin
counter = 0;
klok = 0;
end else begin
if (counter == 24999999) begin // every half second
klok = !klok; 
counter = 0;
end else
counter = counter + 1;
end
endmodule