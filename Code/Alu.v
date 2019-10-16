// iverilog

module AddHalf (input a, b, 
                output sum, c_out);
   xor G1(sum, a, b);	// Gate instance names are optional
   and G2(c_out, a, b);
endmodule // AddHalf

module AddFull (input a, b, c_in, 
                output c_out, sum);	 
   wire w1, w2, w3;				// w1 is c_out; w2 is sum of first half adder
   AddHalf M1 (a, b, w1, w2);
   AddHalf M0 (w2, c_in, w3, sum);
   or (c_out, w1, w3);
endmodule; // AddFull

module Add(input a, b, cin, 
           output sum, cout);
endmodule; // Add

module Sub(input a, b, 
           output difference);

endmodule; // Sub

/* a shift value greater than 0 will shift right and
 * a shift value less than 0 will shift left
 */ 
module Shift(input num, shift,
             output shifted);
   
endmodule; // Shift

module Mult(input a, b,
            output upper, lower);
   
endmodule; // Mult

module Div(input dividen, divisor,
           output quotient, remainder);
   
endmodule; // Div

module ALU(input opcode, operand1, operand2, statusIn 
           output result, statusOut);
   
endmodule; // ALU

module testbench();
   
endmodule; // testbench
