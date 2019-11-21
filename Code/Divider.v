module Mux2 (out, signal, in1, in2);
   parameter n = 16;
   input signal;
   input [n-1:0] in1;
   input [n-1:0] in2;
   output [n-1:0] out;
   assign out = (signal? in1 : in2);
endmodule

module Mux4(a3, a2, a1, a0, s, b);
   parameter k = 4;
   input [k-1:0] a3, a2, a1, a0; // inputs
   input [3:0]   s;              // one-hot select
   output reg[k-1:0] b;
   always @(a3, a2, a1, a0, s, b)
     b = (s[0]? a0 :
          (s[1]? a1 :
           (s[2]? a2 : a3)));
endmodule // Mux4

module binaryMux( input [3:0] a,                 // 4-bit input called a
                         input [3:0] b,                 // 4-bit input called b
                         input [3:0] c,                 // 4-bit input called c
                         input [3:0] d,                 // 4-bit input called d
                         input [1:0] sel,               // input sel used to select between a,b,c,d
                         output [3:0] out);             // 4-bit output based on input sel
 
   // When sel[1] is 0, (sel[0]? b:a) is selected and when sel[1] is 1, (sel[0] ? d:c) is taken
   // When sel[0] is 0, a is sent to output, else b and when sel[0] is 0, c is sent to output, else d
   assign out = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a); 
 
endmodule

module Sub(a, b, cout, sum);
   parameter n = 16;
   input [n-1:0] a, b;
   output [n-1:0] sum;
   output        cout;
   wire [n-1:0]   carry;
   wire [n-1:0]   w;
   wire [n-1:0]   xorWire;
   assign xorWire = {n{1'b1}}; //fill cinWire up with the cin value n times so it can be xor'd
   assign w = b ^ xorWire; //xor the values
   genvar i; //variable for iteration in generate for loop
   generate //generate code over and over
      for (i = 0;i<n;i=i+1) begin: addTogether //generate multiple instances
         if(i==0) //For the first time take the cin
            AddFull A0(a[i], w[i], , carry[i], sum[i]);
         else //otherwise just do the usual
            AddFull A(a[i], w[i], carry[i-1], carry[i], sum[i]);
         end
      assign cout = carry[n-1]^1'b1; //assign the cout to the proper value
   endgenerate
endmodule // Sub

module fourBitPriorityEncoder(in, out, valid);
   input [3:0] in;
   output valid;
   output [1:0] out;
   wire and1;
   and A1(and1, in[1],~in[2]);
   or O1(out[1], in[2],in[3]);
   or O2(out[0],in[3],and1);
   assign valid = in[3] | in[2] | in[1] | in[0];
endmodule

module sixteenBitPriorityEncoder(in, out, valid);
   input [15:0] in;
   output [3:0] out;
   output valid;
   wire [1:0] o0;
   wire [1:0] o1;
   wire [1:0] o2;
   wire [1:0] o3;
   wire [3:0] con1;
   wire [3:0] con2;
   assign con1 = {{o3[0]|o3[1]},{o2[0]|o2[1]},{o1[0]|o1[1]},{o0[0]|o0[1]}};
   wire v0,v1,v2,v3,v4,v5;
   fourBitPriorityEncoder e1(in[3:0],o0,v0);
   fourBitPriorityEncoder e2(in[7:4],o1,v1);
   fourBitPriorityEncoder e3(in[11:8],o2,v2);
   fourBitPriorityEncoder e4(in[15:12],o3,v3);
   fourBitPriorityEncoder e5(con1,out[3:2],v4);
   fourBitPriorityEncoder e6(con2,out[1:0],v5);
   binaryMux m(in[3:0],in[7:4],in[11:8],in[15:12],out[3:2],con2);
   assign valid = v4 | v5;
endmodule


module AddSub1(a,b,sub,s,ovf) ;
   parameter n = 16;
   input [n-1:0] a, b;
   input sub; // subtract if sub=1, otherwise add
   output [n-1:0] s;
   output ovf; // 1 if overflow
   wire c1, c2; // carry out of last two bits
   assign ovf = c1 ^ c2; // overflow if signs don't match
   assign {c1, s[n-2:0]} = a[n-2:0] + (b[n-2:0] ^ {n-1{sub}}) + sub; // add non sign bits
   assign {c2, s[n-1]} = a[n-1] + (b[n-1] ^ sub) + c1; // add sign bits
endmodule

module AddHalf (input a, b, 
                output c_out, sum);
   xor G1(sum, a, b);	// Gate instance names are optional
   and G2(c_out, a, b);
endmodule // AddHalf

module AddFull (input a, b, c_in, 
                output c_out, sum);	 
   
   wire                w1, w2, w3;				// w1 is c_out; w2 is sum of first half adder
   AddHalf M1 (a, b, w1, w2);
   AddHalf M0 (w2, c_in, w3, sum);
   or (c_out, w1, w3);
endmodule

module ShiftRight(num, shift, shifted);
   input [15:0] num;
   input [3:0]  shift;
   output [15:0] shifted;

   wire [15:0]   layer0;
   wire [15:0]   layer1;
   wire [15:0]   layer2;

   parameter n = 1;

   // layer 0
   Mux2 #(n) L0_0  (layer0[0],  shift[0], num[1],  num[0]);
   Mux2 #(n) L0_1  (layer0[1],  shift[0], num[2],  num[1]);
   Mux2 #(n) L0_2  (layer0[2],  shift[0], num[3],  num[2]);
   Mux2 #(n) L0_3  (layer0[3],  shift[0], num[4],  num[3]);
   Mux2 #(n) L0_4  (layer0[4],  shift[0], num[5],  num[4]);
   Mux2 #(n) L0_5  (layer0[5],  shift[0], num[6],  num[5]);
   Mux2 #(n) L0_6  (layer0[6],  shift[0], num[7],  num[6]);
   Mux2 #(n) L0_7  (layer0[7],  shift[0], num[8],  num[7]);
   Mux2 #(n) L0_8  (layer0[8],  shift[0], num[9],  num[8]);
   Mux2 #(n) L0_9  (layer0[9],  shift[0], num[10], num[9]);
   Mux2 #(n) L0_10 (layer0[10], shift[0], num[11], num[10]);
   Mux2 #(n) L0_11 (layer0[11], shift[0], num[12], num[11]);
   Mux2 #(n) L0_12 (layer0[12], shift[0], num[13], num[12]);
   Mux2 #(n) L0_13 (layer0[13], shift[0], num[14], num[13]);
   Mux2 #(n) L0_14 (layer0[14], shift[0], num[15], num[14]);
   Mux2 #(n) L0_15 (layer0[15], shift[0], 1'b0,    num[15]);
   // layer 2
   Mux2 #(n) L1_0  (layer1[0],  shift[1], layer0[2],  layer0[0]);
   Mux2 #(n) L1_1  (layer1[1],  shift[1], layer0[3],  layer0[1]);
   Mux2 #(n) L1_2  (layer1[2],  shift[1], layer0[4],  layer0[2]);
   Mux2 #(n) L1_3  (layer1[3],  shift[1], layer0[5],  layer0[3]);
   Mux2 #(n) L1_4  (layer1[4],  shift[1], layer0[6],  layer0[4]);
   Mux2 #(n) L1_5  (layer1[5],  shift[1], layer0[7],  layer0[5]);
   Mux2 #(n) L1_6  (layer1[6],  shift[1], layer0[8],  layer0[6]);
   Mux2 #(n) L1_7  (layer1[7],  shift[1], layer0[9],  layer0[7]);
   Mux2 #(n) L1_8  (layer1[8],  shift[1], layer0[10], layer0[8]);
   Mux2 #(n) L1_9  (layer1[9],  shift[1], layer0[11], layer0[9]);
   Mux2 #(n) L1_10 (layer1[10], shift[1], layer0[12], layer0[10]);
   Mux2 #(n) L1_11 (layer1[11], shift[1], layer0[13], layer0[11]);
   Mux2 #(n) L1_12 (layer1[12], shift[1], layer0[14], layer0[12]);
   Mux2 #(n) L1_13 (layer1[13], shift[1], layer0[15], layer0[13]);
   Mux2 #(n) L1_14 (layer1[14], shift[1], 1'b0,       layer0[14]);
   Mux2 #(n) L1_15 (layer1[15], shift[1], 1'b0,       layer0[15]);
   // layer 2
   Mux2 #(n) L2_0  (layer2[0],  shift[2], layer1[4],  layer1[0]);
   Mux2 #(n) L2_1  (layer2[1],  shift[2], layer1[5],  layer1[1]);
   Mux2 #(n) L2_2  (layer2[2],  shift[2], layer1[6],  layer1[2]);
   Mux2 #(n) L2_3  (layer2[3],  shift[2], layer1[7],  layer1[3]);
   Mux2 #(n) L2_4  (layer2[4],  shift[2], layer1[8],  layer1[4]);
   Mux2 #(n) L2_5  (layer2[5],  shift[2], layer1[9],  layer1[5]);
   Mux2 #(n) L2_6  (layer2[6],  shift[2], layer1[10], layer1[6]);
   Mux2 #(n) L2_7  (layer2[7],  shift[2], layer1[11], layer1[7]);
   Mux2 #(n) L2_8  (layer2[8],  shift[2], layer1[12], layer1[8]);
   Mux2 #(n) L2_9  (layer2[9],  shift[2], layer1[13], layer1[9]);
   Mux2 #(n) L2_10 (layer2[10], shift[2], layer1[14], layer1[10]);
   Mux2 #(n) L2_11 (layer2[11], shift[2], layer1[15], layer1[11]);
   Mux2 #(n) L2_12 (layer2[12], shift[2], 1'b0,       layer1[12]);
   Mux2 #(n) L2_13 (layer2[13], shift[2], 1'b0,       layer1[13]);
   Mux2 #(n) L2_14 (layer2[14], shift[2], 1'b0,       layer1[14]);
   Mux2 #(n) L2_15 (layer2[15], shift[2], 1'b0,       layer1[15]);
   // layer 3
   Mux2 #(n) L3_0  (shifted[0],  shift[3], layer2[8],  layer2[0]);
   Mux2 #(n) L3_1  (shifted[1],  shift[3], layer2[9],  layer2[1]);
   Mux2 #(n) L3_2  (shifted[2],  shift[3], layer2[10], layer2[2]);
   Mux2 #(n) L3_3  (shifted[3],  shift[3], layer2[11], layer2[3]);
   Mux2 #(n) L3_4  (shifted[4],  shift[3], layer2[12], layer2[4]);
   Mux2 #(n) L3_5  (shifted[5],  shift[3], layer2[13], layer2[5]);
   Mux2 #(n) L3_6  (shifted[6],  shift[3], layer2[14], layer2[6]);
   Mux2 #(n) L3_7  (shifted[7],  shift[3], layer2[15], layer2[7]);
   Mux2 #(n) L3_8  (shifted[8],  shift[3], 1'b0,       layer2[8]);
   Mux2 #(n) L3_9  (shifted[9],  shift[3], 1'b0,       layer2[9]);
   Mux2 #(n) L3_10 (shifted[10], shift[3], 1'b0,       layer2[10]);
   Mux2 #(n) L3_11 (shifted[11], shift[3], 1'b0,       layer2[11]);
   Mux2 #(n) L3_12 (shifted[12], shift[3], 1'b0,       layer2[12]);
   Mux2 #(n) L3_13 (shifted[13], shift[3], 1'b0,       layer2[13]);
   Mux2 #(n) L3_14 (shifted[14], shift[3], 1'b0,       layer2[14]);
   Mux2 #(n) L3_15 (shifted[15], shift[3], 1'b0,       layer2[15]);
endmodule // ShiftRight

module divideModule(dividend, divisor, quotientBit, result);
   parameter n = 16;
   input [n-1:0] dividend;
   input [n-1:0] divisor;
   output quotientBit;
   output [n-1:0] result;
   reg quotientBit;
   wire [n-1:0] difference;
   wire ovf;
   wire [n-1:0] shifted;

   AddSub1 s(dividend,divisor,1'b1,difference,ovf);
   always @* begin
      if (divisor>dividend) begin
         quotientBit = 0;
      end
      else begin
         quotientBit = 1;
      end
   end
   Mux2 #(n) m(result, quotientBit, difference, divisor);

endmodule

module testbench();
// reg [31:0] dividend = 10000;
// reg [31:0] divisor = 1000;
// wire [31:0] quotient;
// wire [31:0] remainder;
reg [5:0] dividend = 5'b0110;
reg [2:0] divisor = 3'b000;
wire [5:0] quotient;
wire [2:0] remainder;
wire [15:0] sum;
wire overflow,cout;
wire [4:0] sum1;
wire [15:0] cout1;

reg [4:0] test1 = 5'b01010;
reg [4:0] test2 = 5'b10101;
reg [4:0] test3 = 5'b01010;
reg [4:0] test4 = 5'b10101;
reg [15:0] test5 = 16'b0000_1000_0001_0000;
wire [3:0] peAnswer;
wire valid;
wire [5:0] testAnswer = test1 ^ test2;

//Divide D(ready,quotient,remainder,dividend,divider,sign,clk);
//Sub #(5) S(test2,test1,cout,sum);
//Sub S(test2,test1,cout,sum);
AddSub1 #(5) As(test4,test3,1'b1,sum1,overflow);
sixteenBitPriorityEncoder PE(test5,peAnswer, valid);

initial begin
   #10 $display("Dividend: %d, Divisor: %d, Quotient: %b, Remainder: %b",dividend, divisor, quotient,remainder);
   #10 $display("%d - %d = %b or %d cout:%b",test2,test1,sum,sum,cout);
   #10 $display("%d - %d = %b or %d ovf:%b",test4,test3,sum1,sum1,overflow);
   #10 $display("%b %b %b",test5,peAnswer,valid);
end

endmodule