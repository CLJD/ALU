// iverilog

module Add(input reg a, b, cin, 
           output reg sum, cout);

endmodule; // Add

module Sub(input reg a, b, 
           output reg difference);

endmodule; // Sub

module Shift(input reg num, shift,
             output reg shifted);
   
endmodule; // Shift

module Mult(input reg a, b,
            output reg upper, lower);
   
endmodule; // Mult

module Div(input reg dividen, divisor,
           output reg quotient, remainder);
   
endmodule; // Div

module ALU(input reg opcode, operand1, operand2, statusIn 
           output reg result, statusOut);
   
endmodule; // ALU

module testbench();
   
endmodule; // testbench
