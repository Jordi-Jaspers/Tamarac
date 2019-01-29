module dec(decin,seg0,seg1);
input [4:0] decin; // input  [7:0] number;
output reg [3:0] seg0;
output reg [3:0] seg1;

   // Internal variable for storing bits
   reg [12:0] shift;
   integer i;
   
   always @(decin)
   begin
      // Clear previous number and store new number in shift register
      shift[12:5] = 0;
      shift[4:0] = decin;
      
      // Loop eight times
      for (i=0; i<5; i=i+1) begin
         if (shift[8:5] >= 5)
            shift[8:5] = shift[8:5] + 3;
            
         if (shift[12:9] >= 5)
            shift[12:9] = shift[12:9] + 3;                
         
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
      seg1 = shift[12:9];
      seg0 = shift[8:5];
  end
endmodule