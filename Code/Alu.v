// iverilog

module AddHalf (input a, b, 
                output c_out, sum);
   xor G1(sum, a, b);	// Gate instance names are optional
   and G2(c_out, a, b);
endmodule // AddHalf

module AddFull (input a, b, c_in, 
                output c_out, sum);	 
   wire w1, w2, w3;				// w1 is c_out; w2 is sum of first half adder
   AddHalf M1 (a, b, w1, w2);
   AddHalf M0 (w2, c_in, w3, sum);
   or (c_out, w1, w3);
endmodule // AddFull

module Add(a, b, 
           cout, sum);
   input [15:0] a, b;
   output [15:0] sum;
   output        cout;
   wire [14:0]   carry;
   AddFull A0(a[0], b[0], 1'b0, carry[0], sum[0]);
   AddFull A1(a[1], b[1], carry[0], carry[1], sum[1]);
   AddFull A2(a[2], b[2], carry[1], carry[2], sum[2]);
   AddFull A3(a[3], b[3], carry[2], carry[3], sum[3]);
   AddFull A4(a[4], b[4], carry[3], carry[4], sum[4]);
   AddFull A5(a[5], b[5], carry[4], carry[5], sum[5]);
   AddFull A6(a[6], b[6], carry[5], carry[6], sum[6]);
   AddFull A7(a[7], b[7], carry[6], carry[7], sum[7]);
   AddFull A8(a[8], b[8], carry[7], carry[8], sum[8]);
   AddFull A9(a[9], b[9], carry[8], carry[9], sum[9]);
   AddFull A10(a[10], b[10], carry[9], carry[10], sum[10]);
   AddFull A11(a[11], b[11], carry[10], carry[11], sum[11]);
   AddFull A12(a[12], b[12], carry[11], carry[12], sum[12]);
   AddFull A13(a[13], b[13], carry[12], carry[13], sum[13]);
   AddFull A14(a[14], b[14], carry[13], carry[14], sum[14]);
   AddFull A15(a[15], b[15], carry[14], cout, sum[15]);
endmodule // Add

module Sub(input a, b, 
           output difference);

endmodule // Sub

/* a shift value greater than 0 will shift right and
 * a shift value less than 0 will shift left
 */ 
module Shift(input num, shift,
             output shifted);
   
endmodule // Shift

module Mult(input a, b,
            output upper, lower);
   
endmodule // Mult

module Div(input dividen, divisor,
           output quotient, remainder);
   
endmodule // Div

module ALU(input opcode, operand1, operand2, statusIn,
           output result, statusOut);
   
endmodule // ALU

module testbench();
   ////////////////////
   // test Add
   ////////////////////
   reg [15:0]  val1, val2;
   reg [15:0]  result;
   reg         overflow;
   wire [15:0] a;
   wire [15:0] b;
   wire [15:0] sum;
   wire       carry;
   Add G1(a, b, carry, sum);
   initial begin
      forever begin
         #10 val1 = a;
         val2 = b;
         result = sum;
         overflow = carry;
         $display("ADD:%s: %d + %d = %d%d",
                  (result == val1 + val2 + overflow * 16)? "PASS":"FAIL",val1, val2, overflow, result);
      end
   end
   
   initial begin
      assign a = 16'b1111111111111111;
      assign b = 16'b1111111111111111;
      #10 $finish;
   end
endmodule // testbench
