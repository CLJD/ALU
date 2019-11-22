module Mux2 (out, signal, in1, in2);
   parameter n = 4;
   input signal;
   input [n-1:0] in1;
   input [n-1:0] in2;
   output [n-1:0] out;
   assign out = (signal? in1 : in2);
endmodule // Mux2

module Mux4(a3, a2, a1, a0, s, b);
   parameter k = 5;
   input [k-1:0] a3, a2, a1, a0; // inputs
   input [3:0]   s;              // one-hot select
   output reg[k-1:0] b;
   always @(a3, a2, a1, a0, s, b)
     b = (s[0]? a0 :
          (s[1]? a1 :
           (s[2]? a2 : a3)));
endmodule // Mux4

module Mux8(a7, a6, a5, a4, a3, a2, a1, a0, s, b);
   parameter k = 5;
   input [k-1:0] a7, a6, a5, a4, a3, a2, a1, a0;
   input [7:0]   s;
   output [k-1:0] b;
   assign b = (s[0]? a0 : 
        (s[1]? a1 :
         (s[2]? a2 :
          (s[3]? a3 :
           (s[4]? a4 :
            (s[5]? a5 :
             (s[6]? a6 : a7)))))));
endmodule // Mux8

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
   input [3:0]  n;
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
module Decoder3(n, out);
   input [2:0] n;
   output [7:0] out;
   assign out[0] =  {~n[2] & ~n[1] & ~n[0]};
   assign out[1] =  {~n[2] & ~n[1] &  n[0]};
   assign out[2] =  {~n[2] &  n[1] & ~n[0]};
   assign out[3] =  {~n[2] &  n[1] &  n[0]};
   assign out[4] =  { n[2] & ~n[1] & ~n[0]};
   assign out[5] =  { n[2] & ~n[1] &  n[0]};
   assign out[6] =  { n[2] &  n[1] & ~n[0]};
   assign out[7] =  { n[2] &  n[1] &  n[0]};
endmodule // Decoder3
// anti-right-arbiter
// this makes all bits 1 to the right of the first 1 from the left
module ARA(in, out);
   input [15:0] in;
   output [15:0] out;

   assign out[15] = {in[15] | 1'b0};
   assign out[14] = {in[14] | out[15]};
   assign out[13] = {in[13] | out[14]};
   assign out[12] = {in[12] | out[13]};
   assign out[11] = {in[11] | out[12]};
   assign out[10] = {in[10] | out[11]};
   assign out[9] =  {in[9]  | out[10]};
   assign out[8] =  {in[8]  | out[9]};
   assign out[7] =  {in[7]  | out[8]};
   assign out[6] =  {in[6]  | out[7]};
   assign out[5] =  {in[5]  | out[6]};
   assign out[4] =  {in[4]  | out[5]};
   assign out[3] =  {in[3]  | out[4]};
   assign out[2] =  {in[2]  | out[3]};
   assign out[1] =  {in[1]  | out[2]};
   assign out[0] =  {in[0]  | out[1]};
endmodule // ARA

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
endmodule // AddFull

module Add(a, b, cin, cout, sum);
   input [15:0] a, b;
   output [15:0] sum;
   input         cin;
   output        cout;
   wire [14:0]   carry;
   AddFull A0(a[0], b[0], cin, carry[0], sum[0]);
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

module Partial(a, b, p);
   input a;
   input [15:0] b;
   output [15:0] p;
   assign p[0] = {a & b[0]};
   assign p[1] = {a & b[1]};
   assign p[2] = {a & b[2]};
   assign p[3] = {a & b[3]};
   assign p[4] = {a & b[4]};
   assign p[5] = {a & b[5]};
   assign p[6] = {a & b[6]};
   assign p[7] = {a & b[7]};
   assign p[8] = {a & b[8]};
   assign p[9] = {a & b[9]};
   assign p[10] = {a & b[10]};
   assign p[11] = {a & b[11]};
   assign p[12] = {a & b[12]};
   assign p[13] = {a & b[13]};
   assign p[14] = {a & b[14]};
   assign p[15] = {a & b[15]};

endmodule

module Mult(a, b, upper, lower);
   input [15:0] a,b;
   output [15:0] upper, lower;
   wire [15:0]   p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15;
   Partial P0(a[0], b, p0);
   Partial P1(a[1], b, p1);
   Partial P2(a[2], b, p2);
   Partial P3(a[3], b, p3);
   Partial P4(a[4], b, p4);
   Partial P5(a[5], b, p5);
   Partial P6(a[6], b, p6);
   Partial P7(a[7], b, p7);
   Partial P8(a[8], b, p8);
   Partial P9(a[9], b, p9);
   Partial P10(a[10], b, p10);
   Partial P11(a[11], b, p11);
   Partial P12(a[12], b, p12);
   Partial P13(a[13], b, p13);
   Partial P14(a[14], b, p14);
   Partial P15(a[15], b, p15);

   wire [15:0]   pl0, pl1, pl2, pl3, pl4, pl5, pl6, pl7, pl8, pl9, pl10, pl11, pl12, pl13, pl14, pl15;
   wire [15:0]   pr0, pr1, pr2, pr3, pr4, pr5, pr6, pr7, pr8, pr9, pr10, pr11, pr12, pr13, pr14, pr15;

   // values shifted left are for the lower bits
   ShiftLeft L0 (p0, 4'b0000, pl0);
   ShiftLeft L1 (p1, 4'b0001, pl1);
   ShiftLeft L2 (p2, 4'b0010, pl2);
   ShiftLeft L3 (p3, 4'b0011, pl3);
   ShiftLeft L4 (p4, 4'b0100, pl4);
   ShiftLeft L5 (p5, 4'b0101, pl5);
   ShiftLeft L6 (p6, 4'b0110, pl6);
   ShiftLeft L7 (p7, 4'b0111, pl7);
   ShiftLeft L8 (p8, 4'b1000, pl8);
   ShiftLeft L9 (p9, 4'b1001, pl9);
   ShiftLeft L10 (p10, 4'b1010, pl10);
   ShiftLeft L11 (p11, 4'b1011, pl11);
   ShiftLeft L12 (p12, 4'b1100, pl12);
   ShiftLeft L13 (p13, 4'b1101, pl13);
   ShiftLeft L14 (p14, 4'b1110, pl14);
   ShiftLeft L15 (p15, 4'b1111, pl15);

   // values shifted right are for the upper bits
   ShiftRight R1 (p1, 4'b1111, pr1);
   ShiftRight R2 (p2, 4'b1110, pr2);
   ShiftRight R3 (p3, 4'b1101, pr3);
   ShiftRight R4 (p4, 4'b1100, pr4);
   ShiftRight R5 (p5, 4'b1011, pr5);
   ShiftRight R6 (p6, 4'b1010, pr6);
   ShiftRight R7 (p7, 4'b1001, pr7);
   ShiftRight R8 (p8, 4'b1000, pr8);
   ShiftRight R9 (p9, 4'b0111, pr9);
   ShiftRight R10 (p10, 4'b0110, pr10);
   ShiftRight R11 (p11, 4'b0101, pr11);
   ShiftRight R12 (p12, 4'b0100, pr12);
   ShiftRight R13 (p13, 4'b0011, pr13);
   ShiftRight R14 (p14, 4'b0010, pr14);
   ShiftRight R15 (p15, 4'b0001, pr15);



   wire [15:0]   subl0, subl1, subl2, subl3, subl4, subl5, subl6, subl7, subl8, subl9, subl10, subl11, subl12, subl13, subl14;
   // carries from the lower bits could be included in the upper bits
   wire          cl0, cl1, cl2, cl3, cl4, cl5, cl6, cl7, cl8, cl9, cl10, cl11, cl12, cl13, cl14, cl15;
   wire [15:0]   subr0, subr1, subr2, subr3, subr4, subr5, subr6, subr7, subr8, subr9, subr10, subr11, subr12, subr13;
   // there are no possible carries from the upper bits
   wire          cr0, cr1, cr2, cr3, cr4, cr5, cr6, cr7, cr8, cr9, cr10, cr11, cr12, cr13, cr14;

   Add AL0 (pl0, pl1, 1'b0, cl0, subl0);
   Add AL1 (pl2, pl3, 1'b0, cl1, subl1);
   Add AL2 (pl4, pl5, 1'b0, cl2, subl2);
   Add AL3 (pl6, pl7, 1'b0, cl3, subl3);
   Add AL4 (pl8, pl9, 1'b0, cl4, subl4);
   Add AL5 (pl10, pl11, 1'b0, cl5, subl5);
   Add AL6 (pl12, pl13, 1'b0, cl6, subl6);
   Add AL7 (pl14, pl15, 1'b0, cl7, subl7);
   Add AL8 (subl0, subl1, 1'b0, cl8, subl8);
   Add AL9 (subl2, subl3, 1'b0, cl9, subl9);
   Add AL10 (subl4, subl5, 1'b0, cl10, subl10);
   Add AL11 (subl6, subl7, 1'b0, cl11, subl11);
   Add AL12 (subl8, subl9, 1'b0, cl12, subl12);
   Add AL13 (subl10, subl11, 1'b0, cl13, subl13);
   Add AL14 (subl12, subl13, 1'b0, cl14, lower);

   Add AR0 (16'b0, pr1, cl0, cr0, subr0);
   Add AR1 (pr2, pr3, cl1, cr1, subr1);
   Add AR2 (pr4, pr5, cl2, cr2, subr2);
   Add AR3 (pr6, pr7, cl3, cr3, subr3);
   Add AR4 (pr8, pr9, cl4, cr4, subr4);
   Add AR5 (pr10, pr11, cl5, cr5, subr5);
   Add AR6 (pr12, pr13, cl6, cr6, subr6);
   Add AR7 (pr14, pr15, cl7, cr7, subr7);
   Add AR8 (subr0, subr1, cl8, cr8, subr8);
   Add AR9 (subr2, subr3, cl9, cr9, subr9);
   Add AR10 (subr4, subr5, cl10, cr10, subr10);
   Add AR11 (subr6, subr7, cl11, cr11, subr11);
   Add AR12 (subr8, subr9, cl12, cr12, subr12);
   Add AR13 (subr10, subr11, cl13, cr13, subr13);
   Add AR14 (subr12, subr13, cl14, cr14, upper);


endmodule // Mult

module Sub(a, b, cin, ovf, sum);
   input [15:0] a, b;
   output [15:0] sum;
   input         cin;
   output        cout;
   wire [14:0]   carry;
   output           ovf;
   wire [15:0]   w;
   assign ovf = cin ^ cout; //xor carry in and carry out

   xor G0 (w[0], b[0], cin);
   xor G1 (w[1], b[1], cin);
   xor G2 (w[2], b[2], cin);
   xor G3 (w[3], b[3], cin);
   xor G4 (w[4], b[4], cin);
   xor G5 (w[5], b[5], cin);
   xor G6 (w[6], b[6], cin);
   xor G7 (w[7], b[7], cin);
   xor G8 (w[8], b[8], cin);
   xor G9 (w[9], b[9], cin);
   xor G10 (w[10], b[10], cin);
   xor G11 (w[11], b[11], cin);
   xor G12 (w[12], b[12], cin);
   xor G13 (w[13], b[13], cin);
   xor G14 (w[14], b[14], cin);
   xor G15 (w[15], b[15], cin);

   AddFull A0(a[0], w[0], cin , carry[0], sum[0]);
   AddFull A1(a[1], w[1], carry[0], carry[1], sum[1]);
   AddFull A2(a[2], w[2], carry[1], carry[2], sum[2]);
   AddFull A3(a[3], w[3], carry[2], carry[3], sum[3]);
   AddFull A4(a[4], w[4], carry[3], carry[4], sum[4]);
   AddFull A5(a[5], w[5], carry[4], carry[5], sum[5]);
   AddFull A6(a[6], w[6], carry[5], carry[6], sum[6]);
   AddFull A7(a[7], w[7], carry[6], carry[7], sum[7]);
   AddFull A8(a[8], w[8], carry[7], carry[8], sum[8]);
   AddFull A9(a[9], w[9], carry[8], carry[9], sum[9]);
   AddFull A10(a[10], w[10], carry[9], carry[10], sum[10]);
   AddFull A11(a[11], w[11], carry[10], carry[11], sum[11]);
   AddFull A12(a[12], w[12], carry[11], carry[12], sum[12]);
   AddFull A13(a[13], w[13], carry[12], carry[13], sum[13]);
   AddFull A14(a[14], w[14], carry[13], carry[14], sum[14]);
   AddFull A15(a[15], w[15], carry[14], cout, sum[15]);
endmodule // Sub

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


module Div(input dividen, divisor,
           output quotient, remainder);
   
endmodule // Div

module ALU(opcode, operand1, operand2,
           result, high, statusOut);
   parameter n = 16;
   input [3:0]   opcode;
   input [15:0]  operand1, operand2;
   output [15:0] result, high;
   output [1:0]  statusOut;
   // opcodes:
   // | code | operation |
   // |------+-----------|
   // | 0000 | no-op     |
   // | 0001 | and       |
   // | 0010 | nand      |
   // | 0011 | or        |
   // | 0100 | nor       |
   // | 0101 | xor       |
   // | 0110 | xnor      |
   // | 0111 | not       |
   // | 1000 | add       |
   // | 1001 | subtract  |
   // | 1010 | multiply  |
   // | 1011 | divide    |
   // | 1100 | shift <-  |
   // | 1101 | shift ->  |
   wire [15:0]   resultAnd, resultNand, resultOr, resultNor, resultXor, resultXnor, resultNot, resultAdd, resultSub, resultMult, resultDiv, resultSL, resultSR;
   wire          AddCout, SubCout;
   wire [15:0]   MultHigh, DivRem;
   
   and G0 [15:0] (resultAnd, operand1, operand2);
   nand G1 [15:0] (resultNand, operand1, operand2);
   or G2 [15:0] (resultOr, operand1, operand2);
   nor G3 [15:0] (resultNor, operand1, operand2);
   xor G4 [15:0] (resultXor, operand1, operand2);
   xnor G5 [15:0] (resultXnor, operand1, operand2);
   not G6 [15:0] (resultNot, operand1);
   Add a(operand1, operand2, 1'b0, AddCout, resultAdd);
   Sub s(operand1, operand2, 1'b1, SubCout, resultSub);
   Mult m(operand1, operand2, MultHigh, resultMult);
   //Div;                         // TODO: jacob please do this
   ShiftLeft sl(operand1, {operand2[3],operand2[2],operand2[1],operand2[0]}, resultSL);
   ShiftRight sr(operand1, {operand2[3],operand2[2],operand2[1],operand2[0]}, resultSR);

   wire [15:0]   arithmetic, logical, arithmeticHigh;
   wire [7:0]    op1hot;
   
   Decoder3 op({opcode[2], opcode[1], opcode[0]}, op1hot);
   // output
   Mux8 #(n) logicalDecision(resultNot,
                             resultXnor,
                             resultXor,
                             resultNor,
                             resultOr,
                             resultNand,
                             resultAnd,
                             16'b0000000000000000,
                             op1hot, logical);
   Mux8 #(n) ArithmeticDecision(16'b0000000000000000,
                                16'b0000000000000000,
                                resultSR,
                                resultSL,
                                resultDiv,
                                resultMult,
                                resultSub,
                                resultAdd,
                                op1hot, arithmetic);
   Mux2 #(n) fin1(result, opcode[3], arithmetic, logical);
   // high
   Mux8 #(n) ArithmeticHighDecision(16'b0000000000000000,
                                    16'b0000000000000000,
                                    16'b0000000000000000,
                                    16'b0000000000000000,
                                    DivRem,
                                    MultHigh,
                                    {15'b000000000000000,SubCout},
                                    {15'b000000000000000,AddCout},
                                    op1hot, arithmeticHigh);
   Mux2 #(n) fin2(high, opcode[3], arithmeticHigh, 16'b0000000000000000);
   
   // if statusOut is non zero then there is an error
   // | code | error          |
   // |------+----------------|
   // |   00 | no error       |
   // |   01 | carry-over     |
   // |   10 | divide by zero |
   // |   11 | overflow       |
   wire          carryover = SubCout | AddCout;
   wire          dividebyzero = !(operand2 & 0);
   wire          overflow = ((!operand1[15] & !operand2[15]) & resultAdd[15]) | // two positive yeilding negative
                 ((operand1[15] & operand2[15]) & !resultAdd[15]); // two negative yeilding a positive
   // assign statusOut[0] = carryover | overflow;
   // assign statusOut[1] = dividebyzero | overflow;
   Mux8 #(2) status({1'b0,1'b0},
                    {1'b0,1'b0},
                    {1'b0,1'b0},
                    {1'b0,1'b0},
                    {dividebyzero, 1'b0},
                    {1'b0,1'b0},
                    {overflow, overflow | carryover},
                    {overflow, overflow | carryover},
                    op1hot, statusOut);
endmodule // ALU

module testbench();
   /////////////////////
   // test ALU
   /////////////////////
   // opcodes:
   // | code | operation |
   // |------+-----------|
   // | 0000 | no-op     |
   // | 0001 | and       |
   // | 0010 | nand      |
   // | 0011 | or        |
   // | 0100 | nor       |
   // | 0101 | xor       |
   // | 0110 | xnor      |
   // | 0111 | not       |
   // | 1000 | add       |
   // | 1001 | subtract  |
   // | 1010 | multiply  |
   // | 1011 | divide    |
   // | 1100 | shift <-  |
   // | 1101 | shift ->  |
   wire signed [15:0] val1 = 32768;
   wire signed [15:0] val2 = 32768;
   wire [15:0] result1, result2;
   reg [31:0]  MultResult;
   wire [1:0]  status;
   reg [3:0]   Opcode = 4'b1000;
   wire [3:0]  opcode = Opcode;
  
   ALU G(opcode, val1, val2, result1, result2, status);

   initial begin
      // for debugging
      // $display("AND: \t%16b", G.resultAnd);
      // $display("NAND: \t%16b", G.resultNand);
      // $display("OR: \t%16b", G.resultOr);
      // $display("NOR: \t%16b", G.resultNor);
      // $display("XOR: \t%16b", G.resultXor);
      // $display("XNOR: \t%16b", G.resultXnor);
      // $display("NOT: \t%16b", G.resultNot);
      // $display("ADD: \t%16b", G.resultAdd);
      // $display("SUB: \t%16b", G.resultSub);
      // #100 $display("MULT: \t%16b", G.resultMult);
      // $display("SL: \t%16b", G.resultSL);
      // $display("SR: \t%16b", G.resultSR);
      // #10 MultResult = result2;
      // MultResult = result1 + (MultResult << 16);
      // $display("ALU: %b : %d", status, result1);
      
      
   end
              
   ////////////////////
   // test Add
   ////////////////////
   // reg [15:0]  val1, val2;
   // reg [15:0]  result;
   // reg         overflow;
   // reg [15:0] a;
   // reg [15:0] b;
   // wire [15:0] sum;
   // wire       carry;
   // Add A(a, b, 1'b0, carry, sum);
   // initial begin
   //     forever begin
   //         #10 val1 = a;
   //         val2 = b;
   //         result = sum;
   //         overflow = carry;
   //         $display("ADD:%s: %d + %d = %d%d",
   //                 (result == val1 + val2 + overflow * 16)? "PASS":"FAIL",val1, val2, overflow, result);
   //     end
   // end
   // initial begin
   //    assign a = 16'b1111111111111111;
   //     assign b = 16'b1111111111111111;
   //    #10 $finish;
   // end

   ////////////////////
   // test Sub
   ////////////////////
   // reg [15:0]  val1, val2;
   // reg [15:0]  result;
   // reg         overflow;
   // reg [15:0] a;
   // reg [15:0] b;
   // wire [15:0] sum;
   // wire       carry;
   // Sub S(a, b, 1'b1, carry, sum);
   // initial begin
   //   forever begin
   //      #10 val1 = a;
   //       val2 = b;
   //       result = sum;
   //       overflow = carry;
   //       $display("SUB:%s: %d - %d =%d ovf:%d",
   //                (result == val1 - val2)? "PASS":"FAIL",val1, val2, result, overflow);
   //    end
   // end
   // initial begin
   //  assign a = 16'b1000001000000000;
   //  assign b = 16'b1000000000000000;
   //    #10 $finish;
   // end
   
   ///////////////////// 
   // test ShiftLeft
   ///////////////////// 
   // wire [15:0] value = 24;
   // wire [3:0]  shift = 5;
   // wire [15:0] result;

   // ShiftLeft S(value, shift, result);
   
   // initial begin
   //    #10 $display("SHIFT: %b << %b = %b",value, shift, result);
   // end
   ///////////////////// 
   // test ShiftRight
   ///////////////////// 
   // reg [15:0] value = 16384;
   // reg [3:0]  shift = 8;
   // wire [15:0] result;

   // ShiftRight S(value, shift, result);
   
   // initial begin
   //    #10 $display("SHIFT: %b >> %b = %b",value, shift, result);
   // end   
   // initial begin
   //    #1 value = 5;
   //    shift = 1;
   //    #10 value = 5;
   //    shift = -1;
   //    #10 $finish;
   // end

   /////////////////////
   // test Multiply
   /////////////////////

   // reg [15:0] a;
   // reg [15:0] b;
   // wire [15:0] up;
   // wire [15:0] low;
   // reg [15:0] up_res;
   // reg [15:0] low_res;
   // reg cOut;
   // Mult M(a, b, up, low);
   // initial begin
   //   forever begin
   //       #10
   //       up_res = up;
   //         low_res = low;
   //     $display("Multiply %b %b %b %b", a, b, up_res, low_res);
   //     end
   // end
   // initial begin
   //   assign b = 16'b1111110111101000;
   //   assign a = 16'b1111110111101000;
   //   #10
   //   $finish;
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
   //////////////////////////////////
   // test ARA (anti-right-arbiter)
   //////////////////////////////////
   // wire [15:0] in = 16'b0000000000000010;
   // wire [15:0] out;
   
   // ARA A(in, out);

   // initial begin
   //    #140 $display("%15b -> %15b", in, out);
   // end
   
endmodule // testbench
