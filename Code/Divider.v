// module Divide(ready,quotient,remainder,dividend,divider,sign,clk);

//    input         clk;
//    input         sign;
//    input [31:0]  dividend, divider;
//    output [31:0] quotient, remainder;
//    output        ready;

//    reg [31:0]    quotient, quotient_temp;
//    reg [63:0]    dividend_copy, divider_copy, diff;
//    reg           negative_output;
   
//    wire [31:0]   remainder = (!negative_output) ? 
//                              dividend_copy[31:0] : 
//                              ~dividend_copy[31:0] + 1'b1;

//    reg [5:0]     bit; 
//    wire          ready = !bit;

//    initial bit = 0;
//    initial negative_output = 0;

//    always @( posedge clk ) 

//      if( ready ) begin

//         bit = 6'd32;
//         quotient = 0;
//         quotient_temp = 0;
//         dividend_copy = (!sign || !dividend[31]) ? 
//                         {32'd0,dividend} : 
//                         {32'd0,~dividend + 1'b1};
//         divider_copy = (!sign || !divider[31]) ? 
//                        {1'b0,divider,31'd0} : 
//                        {1'b0,~divider + 1'b1,31'd0};

//         negative_output = sign &&
//                           ((divider[31] && !dividend[31]) 
//                         ||(!divider[31] && dividend[31]));
        
//      end 
//      else if ( bit > 0 ) begin

//         diff = dividend_copy - divider_copy;

//         quotient_temp = quotient_temp << 1;

//         if( !diff[63] ) begin

//            dividend_copy = diff;
//            quotient_temp[0] = 1'd1;

//         end

//         quotient = (!negative_output) ? 
//                    quotient_temp : 
//                    ~quotient_temp + 1'b1;

//         divider_copy = divider_copy >> 1;
//         bit = bit - 1'b1;

//      end
// endmodule

// module Divide(dividend, divisor, quotient, remainder, err, ready);
//    input [15:0]  dividend, divisor;
//    output [15:0] quotient, remainder;
//    output ready;
//    output err;
//    reg [15:0] quotient;
//    reg [15:0] remainder;
//    reg err,ready;

//    integer i;
//    reg [7:0] ram [0:255];
//    initial begin
//       for (i = 0; i < 256; i = i + 1) begin
//     end
//     assign ready = 1;
//     assign err = 0;
//    end
// endmodule
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

module shifter(input a, output b);

endmodule

module Divide(dividend, divisor, q, r);
input [5:0] dividend; // dividend
input [2:0] divisor; // divisor
output [5:0] q; // quotient
output [2:0] r; // remainder
wire co5, co4, co3, co2, co1, co0; // carry out of adders
wire sum5; // sum out of adder - stage 1
AddFull sub5(dividend[5],~divisor[0],1'b1, co5, sum5);
assign q[5] = co5 & ~(|divisor[2:1]); // if divisor<<5 bigger than dividend, q[5] is 0
wire [5:0] r4 = q[5]? {sum5,dividend[4:0]} : dividend;
wire [1:0] sum4; // sum out of the adder - stage 2
AddFull sub4(r4[5:4],~divisor[1:0],1'b1, co4, sum4);
assign q[4] = co4 & ~divisor[2]; // compare
wire [5:0] r3 = q[4]? {sum4,r4[3:0]} : r4;
wire [2:0] sum3; // sum out of the adder - stage 3
AddFull sub3(r3[5:3],~divisor,1'b1, co3, sum3);
assign q[3] = co3 ; // compare
wire [5:0] r2 = q[3]? {sum3,r3[2:0]} : r3;
wire [3:0] sum2; // sum out of the adder - stage 4
AddFull sub2(r2[5:2],{1'b1,~divisor},1'b1, co2, sum2);
assign q[2] = co2 ; // compare
wire [4:0] r1 = q[2]? {sum2[2:0],r2[1:0]} : r2[4:0]; //msb is zero, drop it
wire [3:0] sum1; // sum out of the adder - stage 5
AddFull sub1(r1[4:1],{1'b1,~divisor},1'b1, co1, sum1);
assign q[1] = co1; // compare
wire [3:0] r0 = q[1]? {sum1[2:0],r1[0]} : r1[3:0]; //msb is zero, drop it
wire [2:0] sum0; // sum out of the adder - stage 6
AddFull sub0(r0[3:0],{1'b1,~divisor},1'b1, co0, sum0);
assign q[0] = co0; // compare
assign r = q[0]? sum0[2:0] : r0[2:0]; // msb is zero, drop it
always @* begin
   if (divisor == 1'b0) begin
      $display("Error: Divide by 0");
   end
end
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
wire ready;
wire err;

//Divide D(ready,quotient,remainder,dividend,divider,sign,clk);
Divide D(dividend, divisor, quotient, remainder);

initial begin
   #10 $display("Dividend: %d, Divisor: %d, Quotient: %b, Remainder: %b",dividend, divisor, quotient,remainder);
end

endmodule