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

module binaryMux4( input [15:0] a,                 // 4-bit input called a
                         input [15:0] b,                 // 4-bit input called b
                         input [15:0] c,                 // 4-bit input called c
                         input [15:0] d,                 // 4-bit input called d
                         input [1:0] sel,               // input sel used to select between a,b,c,d
                         output [15:0] out);             // 4-bit output based on input sel
 
   // When sel[1] is 0, (sel[0]? b:a) is selected and when sel[1] is 1, (sel[0] ? d:c) is taken
   // When sel[0] is 0, a is sent to output, else b and when sel[0] is 0, c is sent to output, else d
   assign out = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);
endmodule

module Sub(a, b, cout, diff);
   parameter n = 16;
   input [n-1:0] a, b;
   output [n-1:0] diff;
   output        cout;
   wire [n-1:0]   carry;
   wire [n-1:0]   w;
   wire [n-1:0]   xorWire;
   assign xorWire = {n{1'b1}}; //fill cinWire up with the cin value n times so it can be xor'd
   assign w = b ^ xorWire; //xor the values
   genvar i; //variable for iteration in generate for loop
   generate //generate code over and over
      for (i = 0;i<n;i=i+1) begin //generate multiple instances
         if(i==0) //For the first time take the cin
            AddFull A0(a[i], w[i], 1'b1, carry[i], diff[i]);
         else //otherwise just do the usual
            AddFull A(a[i], w[i], carry[i-1], carry[i], diff[i]);
         end
      assign cout = carry[n-1]^1'b1; //assign the cout to the proper value
   endgenerate
endmodule // Sub

module sixteenBitMux(input [15:0] D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,input [3:0] selector,output [15:0] out);
   wire [15:0] out1,out2,out3,out4;
   binaryMux4 m1(D0,D1,D2,D3,selector[1:0],out1);
   binaryMux4 m2(D4,D5,D6,D7,selector[1:0],out2);
   binaryMux4 m3(D8,D9,D10,D11,selector[1:0],out3);
   binaryMux4 m4(D12,D13,D14,D15,selector[1:0],out4);
   binaryMux4 final(out1,out2,out3,out4,selector[3:2],out);
endmodule

module comparator(
    Data_in_A,  //input A
    Data_in_B,  //input B
    less,       //high when A is less than B
    equal,       //high when A is equal to B
    greater         //high when A is greater than B    
    );

    //what are the input ports.
    input [3:0] Data_in_A;
    input [3:0] Data_in_B;
    //What are the output ports.
    output less;
     output equal;
     output greater;
     //Internal variables
     reg less;
     reg equal;
     reg greater;

    //When the inputs and A or B are changed execute this block
    always @(Data_in_A or Data_in_B)
     begin
        if(Data_in_A > Data_in_B)   begin  //check if A is bigger than B.
            less = 0;
            equal = 0;
            greater = 1;    end
        else if(Data_in_A == Data_in_B) begin //Check if A is equal to B
            less = 0;
            equal = 1;
            greater = 0;    end
        else    begin //Otherwise - check for A less than B.
            less = 1;
            equal = 0;
            greater =0;
        end 
    end
endmodule

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
   assign con1 = {{o3[0]|o3[1]},{o2[0]|o2[1]},{o1[0]|o1[1]},{o0[0]|o0[1]}}; //used to determine the first 
   //2 bits of the output of the encoder based on the section the highest priority 1 is located in
   wire v0,v1,v2,v3,v4,v5;
   fourBitPriorityEncoder e1(in[3:0],o0,v0);
   fourBitPriorityEncoder e2(in[7:4],o1,v1);
   fourBitPriorityEncoder e3(in[11:8],o2,v2);
   fourBitPriorityEncoder e4(in[15:12],o3,v3);
   fourBitPriorityEncoder e5(con1,out[3:2],v4); //We encode con1 to use the out as a selector for the mux
   fourBitPriorityEncoder e6(con2,out[1:0],v5); 
   binaryMux4 m(in[3:0],in[7:4],in[11:8],in[15:12],out[3:2],con2); //depending on which section we choose the second part of the accordingly
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

module ShiftLeft(num, shift, shifted);
   input [15:0]  num;
   input [3:0]   shift;          // max shift amount is 15
   output [15:0] shifted;
   
   wire [15:0]   layer0;
   wire [15:0]   layer1;
   wire [15:0]   layer2;

   parameter n = 1;
   // layer 0
   Mux2 #(n) L0_0  (layer0[0],  shift[0], 1'b0,    num[0]);
   Mux2 #(n) L0_1  (layer0[1],  shift[0], num[0],  num[1]);
   Mux2 #(n) L0_2  (layer0[2],  shift[0], num[1],  num[2]);
   Mux2 #(n) L0_3  (layer0[3],  shift[0], num[2],  num[3]);
   Mux2 #(n) L0_4  (layer0[4],  shift[0], num[3],  num[4]);
   Mux2 #(n) L0_5  (layer0[5],  shift[0], num[4],  num[5]);
   Mux2 #(n) L0_6  (layer0[6],  shift[0], num[5],  num[6]);
   Mux2 #(n) L0_7  (layer0[7],  shift[0], num[6],  num[7]);
   Mux2 #(n) L0_8  (layer0[8],  shift[0], num[7],  num[8]);
   Mux2 #(n) L0_9  (layer0[9],  shift[0], num[8],  num[9]);
   Mux2 #(n) L0_10 (layer0[10], shift[0], num[9],  num[10]);
   Mux2 #(n) L0_11 (layer0[11], shift[0], num[10], num[11]);
   Mux2 #(n) L0_12 (layer0[12], shift[0], num[11], num[12]);
   Mux2 #(n) L0_13 (layer0[13], shift[0], num[12], num[13]);
   Mux2 #(n) L0_14 (layer0[14], shift[0], num[13], num[14]);
   Mux2 #(n) L0_15 (layer0[15], shift[0], num[14], num[15]);
   // layer 2
   Mux2 #(n) L1_0  (layer1[0],  shift[1], 1'b0,       layer0[0]);
   Mux2 #(n) L1_1  (layer1[1],  shift[1], 1'b0,       layer0[1]);
   Mux2 #(n) L1_2  (layer1[2],  shift[1], layer0[0],  layer0[2]);
   Mux2 #(n) L1_3  (layer1[3],  shift[1], layer0[1],  layer0[3]);
   Mux2 #(n) L1_4  (layer1[4],  shift[1], layer0[2],  layer0[4]);
   Mux2 #(n) L1_5  (layer1[5],  shift[1], layer0[3],  layer0[5]);
   Mux2 #(n) L1_6  (layer1[6],  shift[1], layer0[4],  layer0[6]);
   Mux2 #(n) L1_7  (layer1[7],  shift[1], layer0[5],  layer0[7]);
   Mux2 #(n) L1_8  (layer1[8],  shift[1], layer0[6],  layer0[8]);
   Mux2 #(n) L1_9  (layer1[9],  shift[1], layer0[7],  layer0[9]);
   Mux2 #(n) L1_10 (layer1[10], shift[1], layer0[8],  layer0[10]);
   Mux2 #(n) L1_11 (layer1[11], shift[1], layer0[9],  layer0[11]);
   Mux2 #(n) L1_12 (layer1[12], shift[1], layer0[10], layer0[12]);
   Mux2 #(n) L1_13 (layer1[13], shift[1], layer0[11], layer0[13]);
   Mux2 #(n) L1_14 (layer1[14], shift[1], layer0[12], layer0[14]);
   Mux2 #(n) L1_15 (layer1[15], shift[1], layer0[13], layer0[15]);
   // layer 2
   Mux2 #(n) L2_0  (layer2[0],  shift[2], 1'b0,       layer1[0]);
   Mux2 #(n) L2_1  (layer2[1],  shift[2], 1'b0,       layer1[1]);
   Mux2 #(n) L2_2  (layer2[2],  shift[2], 1'b0,       layer1[2]);
   Mux2 #(n) L2_3  (layer2[3],  shift[2], 1'b0,       layer1[3]);
   Mux2 #(n) L2_4  (layer2[4],  shift[2], layer1[0],  layer1[4]);
   Mux2 #(n) L2_5  (layer2[5],  shift[2], layer1[1],  layer1[5]);
   Mux2 #(n) L2_6  (layer2[6],  shift[2], layer1[2],  layer1[6]);
   Mux2 #(n) L2_7  (layer2[7],  shift[2], layer1[3],  layer1[7]);
   Mux2 #(n) L2_8  (layer2[8],  shift[2], layer1[4],  layer1[8]);
   Mux2 #(n) L2_9  (layer2[9],  shift[2], layer1[5],  layer1[9]);
   Mux2 #(n) L2_10 (layer2[10], shift[2], layer1[6],  layer1[10]);
   Mux2 #(n) L2_11 (layer2[11], shift[2], layer1[7],  layer1[11]);
   Mux2 #(n) L2_12 (layer2[12], shift[2], layer1[8],  layer1[12]);
   Mux2 #(n) L2_13 (layer2[13], shift[2], layer1[9],  layer1[13]);
   Mux2 #(n) L2_14 (layer2[14], shift[2], layer1[10], layer1[14]);
   Mux2 #(n) L2_15 (layer2[15], shift[2], layer1[11], layer1[15]);
   // layer 3
   Mux2 #(n) L3_0  (shifted[0],  shift[3], 1'b0,      layer2[0]);
   Mux2 #(n) L3_1  (shifted[1],  shift[3], 1'b0,      layer2[1]);
   Mux2 #(n) L3_2  (shifted[2],  shift[3], 1'b0,      layer2[2]);
   Mux2 #(n) L3_3  (shifted[3],  shift[3], 1'b0,      layer2[3]);
   Mux2 #(n) L3_4  (shifted[4],  shift[3], 1'b0,      layer2[4]);
   Mux2 #(n) L3_5  (shifted[5],  shift[3], 1'b0,      layer2[5]);
   Mux2 #(n) L3_6  (shifted[6],  shift[3], 1'b0,      layer2[6]);
   Mux2 #(n) L3_7  (shifted[7],  shift[3], 1'b0,      layer2[7]);
   Mux2 #(n) L3_8  (shifted[8],  shift[3], layer2[0], layer2[8]);
   Mux2 #(n) L3_9  (shifted[9],  shift[3], layer2[1], layer2[9]);
   Mux2 #(n) L3_10 (shifted[10], shift[3], layer2[2], layer2[10]);
   Mux2 #(n) L3_11 (shifted[11], shift[3], layer2[3], layer2[11]);
   Mux2 #(n) L3_12 (shifted[12], shift[3], layer2[4], layer2[12]);
   Mux2 #(n) L3_13 (shifted[13], shift[3], layer2[5], layer2[13]);
   Mux2 #(n) L3_14 (shifted[14], shift[3], layer2[6], layer2[14]);
   Mux2 #(n) L3_15 (shifted[15], shift[3], layer2[7], layer2[15]);
endmodule // ShiftLeft

module divideModule(dividend, divisor, quotientBit, result);
   parameter n = 16;
   input [n-1:0] dividend;
   input [n-1:0] divisor;
   output quotientBit;
   output [n-1:0] result;
   reg quotientBit;
   wire [n-1:0] difference;
   wire ovf;

   AddSub1 s(dividend,divisor,1'b1,difference,ovf);
   always @(divisor or dividend) begin
      if (divisor>=dividend) begin
         quotientBit = 0;
      end
      else begin
         quotientBit = 1;
      end
   #10 $display("Dividend: %b, Divisor: %b, QuotientBit: %b, Result: %b",dividend, divisor, quotientBit,result);
   end
   Mux2 #(n) m(result, quotientBit, difference, dividend);

endmodule

module divide(dividend, divisor, quotient, remainder);
   parameter n = 16;
   input [15:0] dividend;
   input [15:0] divisor;
   output [15:0] quotient;
   output [15:0] remainder;
   wire [15:0] ovf;
   wire [15:0] valid0;
   wire [15:0] valid1;
   wire [15:0] valid2;
   wire [3:0] dendSize;
   wire [3:0] sorSize;
   wire [3:0] diffSize;
   wire [15:0] shiftedDivisor;
   wire subOverflow;
   wire sign = dividend[15] ^ divisor[15];
   wire [15:0] dividendFixed;
   //    always @(sign) begin
   //       if (sign == 0) begin
   //          Sub S1(16'b0,dividend,subOverflow,dividendFixed);
   //       end
   //       else begin
   //          dividendFixed = dividend;
   //       end
   //    end
   sixteenBitPriorityEncoder e(dividend, dendSize, valid0[0]);
   sixteenBitPriorityEncoder e1(divisor, sorSize, valid1[0]);
   Sub #(16) S2(dendSize,sorSize,valid2[0],diffSize);
   ShiftLeft sll(divisor,diffSize,shiftedDivisor);
   divideModule divideM(dividend,shiftedDivisor,quotient[0],remainder);
   integer i;

   always @(quotient) begin
      $display("shiftedDivisor:%b",quotient);
   end

   initial begin
      for (i = 1; i < diffSize; i = i + 1) begin
      end
   end

   divideModule dM(dividend,shiftedDivisor,quotient[0],remainder);
   // genvar i; //variable for iteration in generate for loop
   //    generate //generate code over and over
   //       for (i = 0;i<n;i=i+1) begin //generate multiple instances
   //          if(i==0) begin//For the first time take the cin
   //             sixteenBitPriorityEncoder e(dividend, dendSize, valid0[i]);
   //             sixteenBitPriorityEncoder e1(divisor, sorSize, valid1[i]);
   //             Sub #(16) S2(dendSize,sorSize,valid2[i],diffSize);
   //             ShiftLeft sll(divisor,diffSize,shiftedDivisor);
   //             divideModule dM(dividend,shiftedDivisor,quotient[i],);
   //             end
   //          else begin //otherwise just do the usual
   //             sixteenBitPriorityEncoder e(dividend, dendSize, valid0[i]);
   //             sixteenBitPriorityEncoder e1(divisor, sorSize, valid1[i]);
   //             Sub #(16) S2(dendSize,sorSize,valid2[i],diffSize);
   //             ShiftRight srl(divisor,diffSize,shiftedDivisor);
   //             //divideModule dM();
   //             end
   //          end
   //    endgenerate

   // always @(dividend or divisor) begin
   //    if()
   // end
endmodule

module testbench();
// reg [31:0] dividend = 10000;
// reg [31:0] divisor = 1000;
// wire [31:0] quotient;
// wire [31:0] remainder;
parameter n = 16;
reg [15:0] dividend = 16'b1000_0000_0000_0000;
reg [15:0] divisor = 4'b1000;
wire [5:0] quotient;
wire [2:0] remainder;
wire cout;
wire [3:0] diff;

reg [15:0] test3 = 16'b0100_0000_0000_0000;
reg [15:0] test4 = 16'b0010_0000_0000_0000;
reg [15:0] test5 = 16'b0001_0000_0000_0000;
reg shiftAmount = 1'b1;
wire [15:0] shiftResult;
wire [15:0] muxResult;
wire [3:0] peAnswer0;
wire [3:0] peAnswer1;
wire [3:0] selector = 4'b1111;
wire valid0,valid1;

//Divide D(ready,quotient,remainder,dividend,divider,sign,clk);
//Sub #(5) S(test2,test1,cout,sum);
//Sub S(test2,test1,cout,sum);
//AddSub1 #(5) As(test4,test3,1'b1,sum,overflow);
divide d(dividend, divisor, quotient, remainder);
sixteenBitPriorityEncoder PE0(test3,peAnswer0, valid0);
sixteenBitPriorityEncoder PE1(test4,peAnswer1, valid1);
sixteenBitMux mux16(1'b0,1'b1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,selector,muxResult);
ShiftRight sr(test5,shiftAmount,shiftResult);
Sub #(n) S(peAnswer0,peAnswer1,cout,diff);

initial begin
   #10 $display("Dividend: %d, Divisor: %d, Quotient: %d, Remainder: %d",dividend, divisor, quotient,remainder);
   #10 $display("%d - %d =%d ovf:%b",peAnswer0,peAnswer1,diff,cout);
   #10 $display("%b %b",selector,muxResult);
   #10 $display("%b %b",peAnswer1,valid1);
   #10 $display("Dividend: %b. Divisor: %b.",dividend,divisor);
end

endmodule