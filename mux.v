module mux(in1,in2,select,out);
input in1,in2,select;
output reg out;
always @(select or in1 or in2) begin
case (select)
1: out = in1;
0: out = in2;
endcase 
end

endmodule
