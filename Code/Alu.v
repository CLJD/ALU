// iverilog
module Mux2 (out, signal, in1, in2);
   input [1:0]   signal;
   input [15:0]  in1;
   input [15:0]  in2;
   output [15:0] out;
   assign out = (signal[1] ? in1 : in2);
endmodule // Mux2
// Decoder4
// |   in |              out |
// |------+------------------|
// | 0000 | 0000000000000001 |
// | 0001 | 0000000000000010 |
// | 0010 | 0000000000000100 |
// | 0011 | 0000000000001000 |
// | 0100 | 0000000000010000 |
// | 0101 | 0000000000100000 |
// | 0110 | 0000000001000000 |
// | 0111 | 0000000010000000 |
// | 1000 | 0000000100000000 |
// | 1001 | 0000001000000000 |
// | 1010 | 0000010000000000 |
// | 1011 | 0000100000000000 |
// | 1100 | 0001000000000000 |
// | 1101 | 0010000000000000 |
// | 1110 | 0100000000000000 |
// | 1111 | 1000000000000000 |
module Decoder4(n, out);
   input [15:0]  n;
   output [15:0] out;
   assign out[0] =  {~n[3] & ~n[2] & ~n[1] & ~n[0]};
   assign out[1] =  {~n[3] & ~n[2] & ~n[1] &  n[0]};
   assign out[2] =  {~n[3] & ~n[2] &  n[1] & ~n[0]};
   assign out[3] =  {~n[3] & ~n[2] &  n[1] &  n[0]};
   assign out[4] =  {~n[3] &  n[2] & ~n[1] & ~n[0]};
   assign out[5] =  {~n[3] &  n[2] & ~n[1] &  n[0]};
   assign out[6] =  {~n[3] &  n[2] &  n[1] & ~n[0]};
   assign out[7] =  {~n[3] &  n[2] &  n[1] &  n[0]};
   assign out[8] =  { n[3] & ~n[2] & ~n[1] & ~n[0]};
   assign out[9] =  { n[3] & ~n[2] & ~n[1] &  n[0]};
   assign out[10] = { n[3] & ~n[2] &  n[1] & ~n[0]};
   assign out[11] = { n[3] & ~n[2] &  n[1] &  n[0]};
   assign out[12] = { n[3] &  n[2] & ~n[1] & ~n[0]};
   assign out[13] = { n[3] &  n[2] & ~n[1] &  n[0]};
   assign out[14] = { n[3] &  n[2] &  n[1] & ~n[0]};
   assign out[15] = { n[3] &  n[2] &  n[1] &  n[0]};
endmodule // Decoder4
// anti-right-arbiter
// this makes all bits 1 to the right of the first 1 from the left
module ARA
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

module Add(a, b, cout, sum);
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
module Shift(num, shift, shifted);
   input [15:0]  num;
   input [3:0]   shift;          // max shift amount is 15
   output [15:0] shifted;
   
   wire [15:0]  layer1;
   wire [15:0]  layer2;
   wire [15:0]  layer3;
   
   // layer 1
   Mux2 L1_0 (layer1[0], shift[0], num[0], 1'b0);
   Mux2 L1_1 (layer1[1], shift[0], num[1], num[0]);
   Mux2 L1_2 (layer1[2], shift[0], num[2], num[1]);
   Mux2 L1_3 (layer1[3], shift[0], num[3], num[2]);
   Mux2 L1_4 (layer1[4], shift[0], num[4], num[3]);
   Mux2 L1_5 (layer1[5], shift[0], num[5], num[4]);
   Mux2 L1_6 (layer1[6], shift[0], num[6], num[5]);
   Mux2 L1_7 (layer1[7], shift[0], num[7], num[6]);
   Mux2 L1_8 (layer1[8], shift[0], num[8], num[7]);
   Mux2 L1_9 (layer1[9], shift[0], num[9], num[8]);
   Mux2 L1_10 (layer1[10], shift[0], num[10], num[9]);
   Mux2 L1_11 (layer1[11], shift[0], num[11], num[10]);
   Mux2 L1_12 (layer1[12], shift[0], num[12], num[11]);
   Mux2 L1_13 (layer1[13], shift[0], num[13], num[12]);
   Mux2 L1_14 (layer1[14], shift[0], num[14], num[13]);
   Mux2 L1_15 (layer1[15], shift[0], num[15], num[14]);
   // layer 2
   Mux2 L2_0 (layer2[0], shift[1], layer1[0], 1'b0);
   Mux2 L2_1 (layer2[1], shift[1], layer1[1], 1'b0);
   Mux2 L2_2 (layer2[2], shift[1], layer1[2], layer1[0]);
   Mux2 L2_3 (layer2[3], shift[1], layer1[3], layer1[1]);
   Mux2 L2_4 (layer2[4], shift[1], layer1[4], layer1[2]);
   Mux2 L2_5 (layer2[5], shift[1], layer1[5], layer1[3]);
   Mux2 L2_6 (layer2[6], shift[1], layer1[6], layer1[4]);
   Mux2 L2_7 (layer2[7], shift[1], layer1[7], layer1[5]);
   Mux2 L2_8 (layer2[8], shift[1], layer1[8], layer1[6]);
   Mux2 L2_9 (layer2[9], shift[1], layer1[9], layer1[7]);
   Mux2 L2_10 (layer2[10], shift[1], layer1[10], layer1[8]);
   Mux2 L2_11 (layer2[11], shift[1], layer1[11], layer1[9]);
   Mux2 L2_12 (layer2[12], shift[1], layer1[12], layer1[10]);
   Mux2 L2_13 (layer2[13], shift[1], layer1[13], layer1[11]);
   Mux2 L2_14 (layer2[14], shift[1], layer1[14], layer1[12]);
   Mux2 L2_15 (layer2[15], shift[1], layer1[15], layer1[13]);
   // layer 3
   Mux2 L3_0 (layer3[0], shift[2], layer2[0], 1'b0);
   Mux2 L3_1 (layer3[1], shift[2], layer2[1], 1'b0);
   Mux2 L3_2 (layer3[2], shift[2], layer2[2], 1'b0);
   Mux2 L3_3 (layer3[3], shift[2], layer2[3], 1'b0);
   Mux2 L3_4 (layer3[4], shift[2], layer2[4], layer2[0]);
   Mux2 L3_5 (layer3[5], shift[2], layer2[5], layer2[1]);
   Mux2 L3_6 (layer3[6], shift[2], layer2[6], layer2[2]);
   Mux2 L3_7 (layer3[7], shift[2], layer2[7], layer2[3]);
   Mux2 L3_8 (layer3[8], shift[2], layer2[8], layer2[4]);
   Mux2 L3_9 (layer3[9], shift[2], layer2[9], layer2[5]);
   Mux2 L3_10 (layer3[10], shift[2], layer2[10], layer2[6]);
   Mux2 L3_11 (layer3[11], shift[2], layer2[11], layer2[7]);
   Mux2 L3_12 (layer3[12], shift[2], layer2[12], layer2[8]);
   Mux2 L3_13 (layer3[13], shift[2], layer2[13], layer2[9]);
   Mux2 L3_14 (layer3[14], shift[2], layer2[14], layer2[10]);
   Mux2 L3_15 (layer3[15], shift[2], layer2[15], layer2[11]);
   // layer 4
   Mux2 L4_0 (shifted[0], shift[3], layer3[0], 1'b0);
   Mux2 L4_1 (shifted[1], shift[3], layer3[1], 1'b0);
   Mux2 L4_2 (shifted[2], shift[3], layer3[2], 1'b0);
   Mux2 L4_3 (shifted[3], shift[3], layer3[3], 1'b0);
   Mux2 L4_4 (shifted[4], shift[3], layer3[4], 1'b0);
   Mux2 L4_5 (shifted[5], shift[3], layer3[5], 1'b0);
   Mux2 L4_6 (shifted[6], shift[3], layer3[6], 1'b0);
   Mux2 L4_7 (shifted[7], shift[3], layer3[7], 1'b0);
   Mux2 L4_8 (shifted[8], shift[3], layer3[8], layer3[0]);
   Mux2 L4_9 (shifted[9], shift[3], layer3[9], layer3[1]);
   Mux2 L4_10 (shifted[10], shift[3], layer3[10], layer3[2]);
   Mux2 L4_11 (shifted[11], shift[3], layer3[11], layer3[3]);
   Mux2 L4_12 (shifted[12], shift[3], layer3[12], layer3[4]);
   Mux2 L4_13 (shifted[13], shift[3], layer3[13], layer3[5]);
   Mux2 L4_14 (shifted[14], shift[3], layer3[14], layer3[6]);
   Mux2 L4_15 (shifted[15], shift[3], layer3[15], layer3[7]);
endmodule // Shift

module Mult(input a, b,
            output upper, lower);
   
endmodule // Mult

module Div(input dividen, divisor,
           output quotient, remainder);
   
endmodule // Div

module ALU(input opcode, operand1, operand2, statusIn,
           output result, statusOut);
   // state machine goes here
endmodule // ALU

module testbench();
   ////////////////////
   // test Add
   ////////////////////
   // reg [15:0]  val1, val2;
   // reg [15:0]  result;
   // reg         overflow;
   // wire [15:0] a;
   // wire [15:0] b;
   // wire [15:0] sum;
   // wire       carry;
   // Add A(a, b, carry, sum);
   // initial begin
   //    forever begin
   //       #10 val1 = a;
   //       val2 = b;
   //       result = sum;
   //       overflow = carry;
   //       $display("ADD:%s: %d + %d = %d%d",
   //                (result == val1 + val2 + overflow * 16)? "PASS":"FAIL",val1, val2, overflow, result);
   //    end
   // end
   // initial begin
   //    assign a = 16'b1111111111111111;
   //    assign b = 16'b1111111111111111;
   //    #10 $finish;
   // end
   
   /////////////////////
   // test Shift
   /////////////////////
   // reg [15:0] Value;
   // reg [3:0] Shift;
   // reg [15:0] Result;
   
   // wire [15:0] value = 5;
   // wire [3:0]  shift = 1;
   // wire [15:0] result = Result;

   // Shift S(value, shift, result);
   // initial begin
   //    forever begin
   //       #10 Result = result;
   //       $display("SHIFT:%s: %b >> %b = %b",
   //                    (Result == Value >> Shift)? "PASS" : "FAIL", value, shift, result);
   //    end
   // end

   // initial begin
   //    #1 Value = 5;
   //    Shift = 1;
   //    #10 Value = 5;
   //    Shift = -1;
   //    #10 $finish;
   // end
   /////////////////////
   // test Decoder4
   /////////////////////
   // wire [3:0]  in = 15;
   // wire [15:0] out;

   // Decoder4 D4(in, out);
   
   // initial begin
   //    #10 $display("%4b -> %16b", in, out);
   // end
   

endmodule // testbench
